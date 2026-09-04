import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/labour.dart';
import '../../../widgets/status_badge.dart';

class LabourRequestDetailsScreen extends StatelessWidget {
  final LabourRequest request;
  final VoidCallback onBack;
  final Function(LabourRequest) onCancelRequest;

  const LabourRequestDetailsScreen({
    Key? key,
    required this.request,
    required this.onBack,
    required this.onCancelRequest,
  }) : super(key: key);

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Labour Request?'),
        content: Text(
          'Are you sure you want to cancel the request to ${request.workerName} for ${request.work}? This action cannot be undone.',
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
              final cancelled = request.copyWith(status: 'Cancelled');
              onCancelRequest(cancelled);
              AppUtils.showSnackBar(context, 'Labour request cancelled');
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            title: const Text('Request Details'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? constraints.maxWidth * 0.18 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Banner
                _buildStatusBanner(context),
                const SizedBox(height: 20),

                // Worker Information Card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AgroColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Assigned Worker',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: request.workerImage != null ? NetworkImage(request.workerImage!) : null,
                              backgroundColor: AgroColors.primaryContainer,
                              child: Text(
                                request.workerName.isNotEmpty ? request.workerName[0].toUpperCase() : 'W',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AgroColors.primaryDark),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.workerName,
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Specialty: ${request.work}',
                                    style: const TextStyle(fontSize: 13, color: AgroColors.primaryDark, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rate: ₹${request.dailyWage.toStringAsFixed(0)} / worker per day',
                                    style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: request.status),
                          ],
                        ),
                        if (request.isAccepted && request.workerPhone != null) ...[
                          const Divider(height: 24, color: AgroColors.border),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 16, color: AgroColors.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    request.workerPhone!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  AppUtils.showSnackBar(
                                    context,
                                    'Simulating call to ${request.workerName} (${request.workerPhone})',
                                  );
                                },
                                icon: const Icon(Icons.call, size: 14),
                                label: const Text('Call Worker'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AgroColors.primary,
                                  side: const BorderSide(color: AgroColors.primary),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Request Information
                const Text(
                  'Work & Schedule Specifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AgroColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _detailRow('Work Type', request.work, Icons.work_outline),
                        const Divider(height: 18, color: AgroColors.border),
                        if (request.cropDescription != null && request.cropDescription!.isNotEmpty) ...[
                          _detailRow('Description', request.cropDescription!, Icons.eco_outlined),
                          const Divider(height: 18, color: AgroColors.border),
                        ],
                        _detailRow('Scheduled Date', request.date, Icons.calendar_today_outlined),
                        const Divider(height: 18, color: AgroColors.border),
                        _detailRow('Duration', request.duration, Icons.schedule_outlined),
                        const Divider(height: 18, color: AgroColors.border),
                        _detailRow('Workers Count', '${request.workersNeeded} Workers', Icons.group_outlined),
                        const Divider(height: 18, color: AgroColors.border),
                        _detailRow('Farm Location', request.location, Icons.location_on_outlined),
                        if (request.notes != null && request.notes!.isNotEmpty) ...[
                          const Divider(height: 18, color: AgroColors.border),
                          _detailRow('Special Notes', request.notes!, Icons.notes_outlined),
                        ],
                        if (request.createdAt != null) ...[
                          const Divider(height: 18, color: AgroColors.border),
                          _detailRow('Requested On', request.createdAt!, Icons.history_toggle_off),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Wage & Billing Summary
                Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AgroColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Wage Summary',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Rate per worker (${request.duration})',
                              style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                            Text(
                              '₹${request.dailyWage.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Number of Workers',
                              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                            Text(
                              '× ${request.workersNeeded}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: AgroColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Estimated Wage',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                            Text(
                              '₹${request.total.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AgroColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Zero platform fees. Paid directly to workers upon task completion.',
                          style: TextStyle(fontSize: 11, color: AgroColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Actions according to status
                if (request.isPending) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelConfirmation(context),
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                      label: const Text(
                        'Cancel Labour Request',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ] else if (request.isAccepted) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.thumb_up_alt_outlined, color: Color(0xFF2E7D32)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Request confirmed! The worker will arrive at the scheduled date and location.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (request.isCancelled) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFCDD2)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Color(0xFFC62828)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This request has been cancelled by the farmer.',
                            style: TextStyle(fontSize: 13, color: Color(0xFFC62828), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String title;
    String desc;

    if (request.isPending) {
      bg = const Color(0xFFFFF3E0);
      border = const Color(0xFFFFE0B2);
      text = const Color(0xFFE65100);
      icon = Icons.hourglass_top;
      title = 'Request Pending Worker Acceptance';
      desc = 'Waiting for ${request.workerName} to review and accept the booking date and requirements.';
    } else if (request.isAccepted) {
      bg = const Color(0xFFE8F5E9);
      border = const Color(0xFFC8E6C9);
      text = const Color(0xFF2E7D32);
      icon = Icons.check_circle_outline;
      title = 'Labour Request Accepted';
      desc = 'The worker has accepted your request. Please ensure farm plot is accessible on the requested date.';
    } else if (request.isCompleted) {
      bg = const Color(0xFFE0F2F1);
      border = const Color(0xFFB2DFDB);
      text = const Color(0xFF00695C);
      icon = Icons.task_alt;
      title = 'Work Completed';
      desc = 'This farm operation has been completed.';
    } else if (request.isCancelled) {
      bg = const Color(0xFFFFEBEE);
      border = const Color(0xFFFFCDD2);
      text = const Color(0xFFC62828);
      icon = Icons.cancel_outlined;
      title = 'Request Cancelled';
      desc = 'This booking was cancelled. You can hire other available workers.';
    } else {
      bg = const Color(0xFFFFEBEE);
      border = const Color(0xFFFFCDD2);
      text = const Color(0xFFC62828);
      icon = Icons.highlight_off;
      title = 'Request Declined';
      desc = 'Worker was unavailable on the selected date. Please search for other available workers.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: text, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: text),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 13, color: text.withOpacity(0.85)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AgroColors.textLight),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textDark),
          ),
        ),
      ],
    );
  }
}
