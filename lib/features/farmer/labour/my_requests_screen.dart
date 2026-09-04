import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/labour.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

class MyRequestsScreen extends StatefulWidget {
  final List<LabourRequest> requests;
  final VoidCallback onFindLabour;
  final Function(LabourRequest)? onViewRequestDetails;
  final Function(LabourRequest)? onCancelRequest;
  final VoidCallback? onBack;

  const MyRequestsScreen({
    Key? key,
    required this.requests,
    required this.onFindLabour,
    this.onViewRequestDetails,
    this.onCancelRequest,
    this.onBack,
  }) : super(key: key);

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  String _selectedStatus = 'All'; // 'All', 'Pending', 'Accepted', 'Completed', 'Cancelled'

  void _showCancelDialog(LabourRequest req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Labour Request?'),
        content: Text(
          'Are you sure you want to cancel the request to ${req.workerName} for ${req.work} on ${req.date}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Request', style: TextStyle(color: AgroColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (widget.onCancelRequest != null) {
                final cancelled = req.copyWith(status: 'Cancelled');
                widget.onCancelRequest!(cancelled);
              }
              AppUtils.showSnackBar(context, 'Labour request cancelled');
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  List<LabourRequest> get _filteredRequests {
    if (_selectedStatus == 'All') return widget.requests;
    return widget.requests.where((r) {
      if (_selectedStatus == 'Pending') return r.isPending;
      if (_selectedStatus == 'Accepted') return r.isAccepted;
      if (_selectedStatus == 'Completed') return r.isCompleted;
      if (_selectedStatus == 'Cancelled') return r.isCancelled || r.status.toLowerCase() == 'rejected';
      return r.status.toLowerCase() == _selectedStatus.toLowerCase();
    }).toList();
  }

  int _countByStatus(String status) {
    if (status == 'All') return widget.requests.length;
    return widget.requests.where((r) {
      if (status == 'Pending') return r.isPending;
      if (status == 'Accepted') return r.isAccepted;
      if (status == 'Completed') return r.isCompleted;
      if (status == 'Cancelled') return r.isCancelled || r.status.toLowerCase() == 'rejected';
      return r.status.toLowerCase() == status.toLowerCase();
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRequests;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            leading: widget.onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  )
                : null,
            title: const Text('My Labour Requests'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_search_outlined),
                tooltip: 'Find More Labour',
                onPressed: widget.onFindLabour,
              ),
            ],
          ),
          body: widget.requests.isEmpty
              ? EmptyStateWidget(
                  title: 'No labour requests yet',
                  description: 'Hire skilled farm workers, tractor operators, and harvesting crews directly for your farm.',
                  icon: Icons.people_outline,
                  buttonText: 'Find Labour',
                  onButtonPressed: widget.onFindLabour,
                )
              : Column(
                  children: [
                    // Status Filter Bar
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Pending', 'Accepted', 'Completed', 'Cancelled'].map((status) {
                            final isSelected = _selectedStatus == status;
                            final count = _countByStatus(status);

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text('$status ($count)'),
                                selected: isSelected,
                                selectedColor: AgroColors.primaryContainer,
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                                onSelected: (_) => setState(() => _selectedStatus = status),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AgroColors.border),

                    // List of Requests
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No $_selectedStatus Requests',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'There are no requests matching this status filter.',
                                      style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedButton(
                                      onPressed: () => setState(() => _selectedStatus = 'All'),
                                      child: const Text('Show All Requests'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? constraints.maxWidth * 0.15 : 16,
                                vertical: 16,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final req = filtered[index];
                                return _buildRequestCard(req);
                              },
                            ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: widget.onFindLabour,
            backgroundColor: AgroColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.person_add),
            label: const Text('Find Labour'),
          ),
        );
      },
    );
  }

  Widget _buildRequestCard(LabourRequest req) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border, width: 0.8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (widget.onViewRequestDetails != null) {
            widget.onViewRequestDetails!(req);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Worker Name + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: req.workerImage != null ? NetworkImage(req.workerImage!) : null,
                        backgroundColor: AgroColors.primaryContainer,
                        child: Text(
                          req.workerName.isNotEmpty ? req.workerName[0].toUpperCase() : 'W',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.workerName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                          ),
                          Text(
                            req.work,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  StatusBadge(status: req.status),
                ],
              ),
              const SizedBox(height: 12),

              // Description if available
              if (req.cropDescription != null && req.cropDescription!.isNotEmpty) ...[
                Text(
                  req.cropDescription!,
                  style: const TextStyle(fontSize: 13, color: AgroColors.textDark),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Schedule Info Row
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AgroColors.cardBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AgroColors.textLight),
                        const SizedBox(width: 5),
                        Text(req.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.textDark)),
                        const SizedBox(width: 10),
                        const Icon(Icons.schedule, size: 14, color: AgroColors.textLight),
                        const SizedBox(width: 5),
                        Text(req.duration, style: const TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.groups, size: 15, color: AgroColors.textLight),
                        const SizedBox(width: 4),
                        Text('${req.workersNeeded} workers', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.textDark)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AgroColors.textLight),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      req.location,
                      style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AgroColors.border),

              // Wage & Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Estimated Wage', style: TextStyle(fontSize: 11, color: AgroColors.textLight)),
                      Text(
                        '₹${req.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AgroColors.primary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (req.isPending) ...[
                        OutlinedButton(
                          onPressed: () => _showCancelDialog(req),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 0.8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 34),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          if (widget.onViewRequestDetails != null) {
                            widget.onViewRequestDetails!(req);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: req.isPending ? AgroColors.primary : AgroColors.primaryContainer,
                          foregroundColor: req.isPending ? Colors.white : AgroColors.primaryDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: const Size(0, 34),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
