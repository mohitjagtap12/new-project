import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/crop.dart';
import '../../../widgets/crop_card.dart';
import '../../../widgets/empty_state.dart';

class MyCropsScreen extends StatefulWidget {
  final List<Crop> crops;
  final VoidCallback onAddCrop;
  final Function(Crop) onViewCrop;
  final Function(Crop) onEditCrop;

  const MyCropsScreen({
    Key? key,
    required this.crops,
    required this.onAddCrop,
    required this.onViewCrop,
    required this.onEditCrop,
  }) : super(key: key);

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';

  final List<String> _statusFilters = [
    'All',
    'Growing',
    'Ready for Harvest',
    'Harvested',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Crop> get _filteredCrops {
    return widget.crops.where((crop) {
      final matchesStatus = _selectedStatusFilter == 'All' || crop.status == _selectedStatusFilter;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          crop.name.toLowerCase().contains(q) ||
          crop.variety.toLowerCase().contains(q) ||
          crop.location.toLowerCase().contains(q) ||
          crop.notes.toLowerCase().contains(q);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  int _countForStatus(String status) {
    if (status == 'All') return widget.crops.length;
    return widget.crops.where((c) => c.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCrops;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        final useGrid = isDesktop || isTablet;

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: widget.onAddCrop,
            backgroundColor: AgroColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Add Crop',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 28 : 16,
              vertical: isDesktop ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Desktop Header
                    if (isDesktop) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'My Crops',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Track your cultivated crops, acreages and harvest timelines',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: widget.onAddCrop,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('+ Add New Crop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AgroColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Search & Quick Stats bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AgroColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AgroColors.textMuted, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) => setState(() => _searchQuery = val),
                              decoration: InputDecoration(
                                hintText: 'Search crops by name, variety, or village...',
                                hintStyle: const TextStyle(fontSize: 14, color: AgroColors.textLight),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close, size: 18, color: AgroColors.textMuted),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips Bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _statusFilters.map((status) {
                          final isSelected = _selectedStatusFilter == status;
                          final count = _countForStatus(status);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text('$status ($count)'),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedStatusFilter = status),
                              selectedColor: AgroColors.primaryContainer,
                              checkmarkColor: AgroColors.primary,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AgroColors.primaryDark : AgroColors.textMuted,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? AgroColors.primary : AgroColors.border,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Showing count info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${filtered.length} of ${widget.crops.length} crops',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AgroColors.textMuted,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty || _selectedStatusFilter != 'All')
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _selectedStatusFilter = 'All';
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Reset filters', style: TextStyle(fontSize: 13)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Crop Cards Content
                    if (widget.crops.isEmpty)
                      EmptyStateWidget(
                        title: 'No crops added yet.',
                        description: 'Record your crops to track planting, growth, and harvest schedules.',
                        icon: Icons.agriculture_outlined,
                        buttonText: '+ Add Crop',
                        onButtonPressed: widget.onAddCrop,
                      )
                    else if (filtered.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48, color: AgroColors.textLight),
                            const SizedBox(height: 12),
                            const Text(
                              'No matching crops found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try changing your search term or selecting "All" status.',
                              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _selectedStatusFilter = 'All';
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Clear Search & Filters'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AgroColors.primary),
                                foregroundColor: AgroColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (useGrid)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 2 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isDesktop ? 1.55 : 1.35,
                        ),
                        itemBuilder: (context, index) {
                          final crop = filtered[index];
                          return CropCard(
                            crop: crop,
                            onView: () => widget.onViewCrop(crop),
                            onEdit: () => widget.onEditCrop(crop),
                          );
                        },
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final crop = filtered[index];
                          return CropCard(
                            crop: crop,
                            onView: () => widget.onViewCrop(crop),
                            onEdit: () => widget.onEditCrop(crop),
                          );
                        },
                      ),

                    const SizedBox(height: 70), // space for FloatingActionButton
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
