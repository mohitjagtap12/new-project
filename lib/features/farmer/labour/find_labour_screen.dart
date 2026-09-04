import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/labour.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/labour_card.dart';

class FindLabourScreen extends StatefulWidget {
  final List<LabourWorker> workers;
  final Function(LabourWorker) onViewWorkerDetails;
  final Function(LabourWorker) onRequestWorker;
  final VoidCallback onViewMyRequests;
  final int myRequestsCount;

  const FindLabourScreen({
    Key? key,
    required this.workers,
    required this.onViewWorkerDetails,
    required this.onRequestWorker,
    required this.onViewMyRequests,
    this.myRequestsCount = 0,
  }) : super(key: key);

  @override
  State<FindLabourScreen> createState() => _FindLabourScreenState();
}

class _FindLabourScreenState extends State<FindLabourScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedWorkFilter = 'All';
  String _selectedAvailabilityFilter = 'All'; // 'All', 'Available', 'Booked'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedWorkFilter = 'All';
      _selectedAvailabilityFilter = 'All';
    });
  }

  List<LabourWorker> get _filteredWorkers {
    return widget.workers.where((worker) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = worker.name.toLowerCase().contains(q);
        final matchWork = worker.work.toLowerCase().contains(q);
        final matchLocation = worker.location.toLowerCase().contains(q);
        final matchSkills = worker.skills.any((s) => s.toLowerCase().contains(q));
        if (!matchName && !matchWork && !matchLocation && !matchSkills) {
          return false;
        }
      }

      // 2. Work Type Filter
      if (_selectedWorkFilter != 'All') {
        if (worker.work.toLowerCase() != _selectedWorkFilter.toLowerCase()) {
          return false;
        }
      }

      // 3. Availability Filter
      if (_selectedAvailabilityFilter != 'All') {
        if (worker.status.toLowerCase() != _selectedAvailabilityFilter.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredWorkers;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Find Labour'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: widget.onViewMyRequests,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.history, color: AgroColors.primary),
                      if (widget.myRequestsCount > 0)
                        Positioned(
                          right: -6,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AgroColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '${widget.myRequestsCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: const Text(
                    'My Requests',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade700,
                        child: const Icon(Icons.people, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Find Farm Labour • शेतमजूर शोधा',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hire verified local farm workers, tractor operators, and harvesting crews directly.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF1565C0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by worker name, skill, or village...',
                    prefixIcon: const Icon(Icons.search, color: AgroColors.textLight),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AgroColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AgroColors.border),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => _searchQuery = val.trim());
                  },
                ),
                const SizedBox(height: 16),

                // Work Type Filter Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Work Type',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                    ),
                    if (_selectedWorkFilter != 'All' || _selectedAvailabilityFilter != 'All' || _searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: _resetFilters,
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AgroColors.primary),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', ...AppConstants.labourWorkTypes].map((work) {
                      final isSelected = _selectedWorkFilter == work;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(work),
                          selected: isSelected,
                          selectedColor: AgroColors.primaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) => setState(() => _selectedWorkFilter = work),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Availability Filter Chips
                Row(
                  children: [
                    const Text(
                      'Availability: ',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                    ),
                    const SizedBox(width: 8),
                    ...['All', 'Available', 'Booked'].map((status) {
                      final isSelected = _selectedAvailabilityFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: status == 'Available'
                              ? const Color(0xFFE8F5E9)
                              : (status == 'Booked' ? const Color(0xFFFFF3E0) : AgroColors.primaryContainer),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? (status == 'Available'
                                    ? const Color(0xFF2E7D32)
                                    : (status == 'Booked' ? const Color(0xFFE65100) : AgroColors.primaryDark))
                                : AgroColors.textDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedAvailabilityFilter = status);
                          },
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // Workers Count & Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Workers (${filtered.length})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                    ),
                    const Text('Verified local profiles', style: TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 12),

                // Workers List / Grid / Empty State
                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: EmptyStateWidget(
                      title: 'No workers found',
                      description: 'No labour matching your current search or filter criteria. Try resetting filters.',
                      icon: Icons.people_outline,
                      buttonText: 'Reset Filters',
                      onButtonPressed: _resetFilters,
                    ),
                  )
                else if (isDesktop || isTablet)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 2 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 220,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final worker = filtered[index];
                      return LabourCard(
                        worker: worker,
                        onTap: () => widget.onViewWorkerDetails(worker),
                        onRequest: () => widget.onRequestWorker(worker),
                      );
                    },
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final worker = filtered[index];
                      return LabourCard(
                        worker: worker,
                        onTap: () => widget.onViewWorkerDetails(worker),
                        onRequest: () => widget.onRequestWorker(worker),
                      );
                    },
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
