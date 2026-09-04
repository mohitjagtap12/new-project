import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/farm_waste.dart';
import '../../../widgets/agro_search_bar.dart';

class MyWasteListingsScreen extends StatefulWidget {
  final List<FarmWaste> listings;
  final Function(FarmWaste) onSelectListing;
  final Function(FarmWaste) onEditListing;
  final Function(String id) onCancelListing;
  final Function(String id) onMarkAsSold;
  final VoidCallback onAddNewListing;
  final VoidCallback? onBrowseMarketplace;
  final VoidCallback? onBack;

  const MyWasteListingsScreen({
    Key? key,
    required this.listings,
    required this.onSelectListing,
    required this.onEditListing,
    required this.onCancelListing,
    required this.onMarkAsSold,
    required this.onAddNewListing,
    this.onBrowseMarketplace,
    this.onBack,
  }) : super(key: key);

  @override
  State<MyWasteListingsScreen> createState() => _MyWasteListingsScreenState();
}

class _MyWasteListingsScreenState extends State<MyWasteListingsScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'All';

  final List<String> _statuses = ['All', 'Active', 'Sold', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final filtered = widget.listings.where((item) {
      final matchesStatus = _selectedStatus == 'All' || item.status.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          item.wasteType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesQuery;
    }).toList();

    final activeCount = widget.listings.where((w) => w.isActive).length;
    final soldCount = widget.listings.where((w) => w.isSold).length;
    final totalPotentialRevenue = widget.listings
        .where((w) => w.isActive)
        .fold<double>(0.0, (sum, w) => sum + w.totalEstimatedValue);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Waste Listings'),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        actions: [
          if (widget.onBrowseMarketplace != null)
            TextButton.icon(
              onPressed: widget.onBrowseMarketplace,
              icon: const Icon(Icons.storefront, size: 18),
              label: const Text('Marketplace', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddNewListing,
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Sell Farm Waste', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Top Metrics Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              border: Border(bottom: BorderSide(color: Colors.brown.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Active Listings',
                    value: '$activeCount',
                    color: AgroColors.primaryDark,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.brown.shade200),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Sold',
                    value: '$soldCount',
                    color: Colors.blue.shade800,
                    icon: Icons.task_alt,
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.brown.shade200),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Active Value',
                    value: '₹${totalPotentialRevenue.toStringAsFixed(0)}',
                    color: Colors.brown.shade900,
                    icon: Icons.currency_rupee,
                  ),
                ),
              ],
            ),
          ),

          // Search & Status Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: AgroSearchBar(
              hintText: 'Search my waste listings...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Status Filter Tabs
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statuses.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = _statuses[index];
                final isSelected = _selectedStatus == status;
                final count = status == 'All'
                    ? widget.listings.length
                    : widget.listings.where((l) => l.status.toLowerCase() == status.toLowerCase()).length;

                return ChoiceChip(
                  label: Text('$status ($count)'),
                  selected: isSelected,
                  selectedColor: Colors.brown.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.brown.shade900 : AgroColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedStatus = status);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Listings List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _buildWasteCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AgroColors.textMuted, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWasteCard(FarmWaste item) {
    Color statusColor;
    Color statusBg;

    if (item.isActive) {
      statusColor = AgroColors.primaryDark;
      statusBg = AgroColors.primaryContainer;
    } else if (item.isSold) {
      statusColor = Colors.blue.shade800;
      statusBg = Colors.blue.shade50;
    } else {
      statusColor = Colors.red.shade800;
      statusBg = Colors.red.shade50;
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: InkWell(
        onTap: () => widget.onSelectListing(item),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.image,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 88,
                        height: 88,
                        color: Colors.brown.shade50,
                        child: Icon(Icons.recycling, color: Colors.brown.shade400, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.wasteType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${item.formattedPrice}/${item.quantityUnit}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AgroColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${item.formattedQuantity}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AgroColors.textLight),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.location,
                                style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.event_available, size: 14, color: AgroColors.textLight),
                            const SizedBox(width: 4),
                            Text(
                              'Avail: ${item.availableDate}',
                              style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AgroColors.border),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => widget.onSelectListing(item),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View Details', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  if (item.isActive) ...[
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => widget.onEditListing(item),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _confirmMarkSold(item),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Mark Sold', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AgroColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 20),
                      tooltip: 'Cancel Listing',
                      onPressed: () => _confirmCancel(item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmMarkSold(FarmWaste item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark as Sold?'),
        content: Text('Mark "${item.wasteType}" as sold? This will update your listing status.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onMarkAsSold(item.id);
              AppUtils.showSnackBar(context, 'Listing marked as sold!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AgroColors.primary),
            child: const Text('Confirm Sold'),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(FarmWaste item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Listing?'),
        content: Text('Are you sure you want to cancel the listing for "${item.wasteType}"? Buyers will no longer see it in the marketplace.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onCancelListing(item.id);
              AppUtils.showSnackBar(context, 'Waste listing cancelled');
            },
            child: const Text('Yes, Cancel Listing', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.recycling_outlined, size: 64, color: Colors.brown.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty ? 'No Matching Waste Listings' : 'No Waste Listings Yet',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try searching with a different keyword.'
                  : 'Turn crop residue into profit by posting wheat straw, rice straw, sugarcane trash, and stalks.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AgroColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.onAddNewListing,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Post Farm Waste for Sale'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
