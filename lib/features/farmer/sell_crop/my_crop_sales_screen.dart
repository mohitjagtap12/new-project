import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

class MyCropSalesScreen extends StatefulWidget {
  final List<CropSale> sales;
  final VoidCallback onAddNewSale;
  final Function(CropSale) onRemoveSale;
  final Function(CropSale) onEditSale;
  final Function(CropSale) onViewSaleDetails;
  final Function(CropSale)? onCancelSale;
  final VoidCallback? onBack;

  const MyCropSalesScreen({
    Key? key,
    required this.sales,
    required this.onAddNewSale,
    required this.onRemoveSale,
    required this.onEditSale,
    required this.onViewSaleDetails,
    this.onCancelSale,
    this.onBack,
  }) : super(key: key);

  @override
  State<MyCropSalesScreen> createState() => _MyCropSalesScreenState();
}

class _MyCropSalesScreenState extends State<MyCropSalesScreen> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'All'; // 'All', 'Active', 'Sold', 'Cancelled'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmCancel(BuildContext context, CropSale sale) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Cancel Sale Listing',
        message:
            'Are you sure you want to cancel your listing for "${sale.cropName}"? Buyers will no longer see this offer.',
        confirmLabel: 'Cancel Listing',
        cancelLabel: 'Keep Active',
        isDestructive: true,
      ),
    );

    if (result == true) {
      if (widget.onCancelSale != null) {
        final updated = sale.copyWith(status: 'Cancelled');
        widget.onCancelSale!(updated);
      } else {
        widget.onRemoveSale(sale);
      }
      AppUtils.showSnackBar(context, 'Sale listing cancelled');
    }
  }

  List<CropSale> get _filteredSales {
    return widget.sales.where((sale) {
      // Status filter
      if (_selectedStatusFilter == 'Active') {
        if (!sale.isActive) return false;
      } else if (_selectedStatusFilter == 'Sold') {
        if (!sale.isSold) return false;
      } else if (_selectedStatusFilter == 'Cancelled') {
        if (!sale.isCancelled) return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final nameMatch = sale.cropName.toLowerCase().contains(q);
        final varietyMatch = sale.variety.toLowerCase().contains(q);
        final locMatch = sale.location.toLowerCase().contains(q);
        return nameMatch || varietyMatch || locMatch;
      }

      return true;
    }).toList();
  }

  int get _activeCount =>
      widget.sales.where((s) => s.isActive).length;
  int get _soldCount => widget.sales.where((s) => s.isSold).length;
  int get _cancelledCount => widget.sales.where((s) => s.isCancelled).length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        final gridColumns = isDesktop ? 3 : (isTablet ? 2 : 1);

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          appBar: AppBar(
            title: const Text('My Crop Sales'),
            leading: widget.onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton.icon(
                  onPressed: widget.onAddNewSale,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Sell Crop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgroColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search & Filter Header
              _buildSearchAndFilters(),

              // Sales List / Grid or Empty State
              Expanded(
                child: _buildBody(gridColumns, isDesktop || isTablet),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            decoration: InputDecoration(
              hintText: 'Search by crop name, variety, or location...',
              prefixIcon: const Icon(Icons.search, color: AgroColors.textMuted, size: 20),
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
              fillColor: AgroColors.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Status Filter Tabs / Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', widget.sales.length),
                const SizedBox(width: 8),
                _buildFilterChip('Active', _activeCount),
                const SizedBox(width: 8),
                _buildFilterChip('Sold', _soldCount),
                const SizedBox(width: 8),
                _buildFilterChip('Cancelled', _cancelledCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedStatusFilter == label;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedStatusFilter = label);
        }
      },
      selectedColor: AgroColors.primary,
      backgroundColor: AgroColors.surfaceVariant,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? Colors.white : AgroColors.textDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? AgroColors.primary : AgroColors.border,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  Widget _buildBody(int columns, bool useGrid) {
    final filtered = _filteredSales;

    if (widget.sales.isEmpty) {
      return EmptyStateWidget(
        title: 'No sales posted yet.',
        description: 'Post your farm harvest to connect with direct retail and wholesale buyers.',
        icon: Icons.storefront_outlined,
        buttonText: '+ Post Crop for Sale',
        onButtonPressed: widget.onAddNewSale,
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_alt_off, size: 54, color: AgroColors.textLight),
              const SizedBox(height: 14),
              const Text(
                'No listings found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 6),
              const Text(
                'Try changing your search keywords or switching filters.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedStatusFilter = 'All';
                  });
                },
                child: const Text('Reset Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final sale = filtered[index];
        return _buildSaleCard(sale);
      },
    );
  }

  Widget _buildSaleCard(CropSale item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: InkWell(
        onTap: () => widget.onViewSaleDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Thumbnail, Title, Variety, and Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.image,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 76,
                        height: 76,
                        color: AgroColors.primaryContainer,
                        child: const Icon(Icons.eco, color: AgroColors.primary, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.cropName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                            ),
                            StatusBadge(status: item.status),
                          ],
                        ),
                        if (item.variety.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.variety,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AgroColors.primaryDark,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.scale, size: 14, color: AgroColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${item.quantity} ${item.unit}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AgroColors.textLight)),
                            const SizedBox(width: 8),
                            Text(
                              '₹${item.price.toStringAsFixed(0)}/${item.unit}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Harvest Date and Location Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AgroColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 13, color: AgroColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.availableDate.isNotEmpty
                                  ? 'Harvest: ${item.availableDate}'
                                  : 'Available Now',
                              style: const TextStyle(fontSize: 12, color: AgroColors.textDark, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AgroColors.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              style: const TextStyle(fontSize: 12, color: AgroColors.textDark, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Description Notes (if any)
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AgroColors.textMuted, height: 1.4),
                ),
              ],

              const Divider(height: 22, color: AgroColors.border),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Est. Value: ₹${item.totalEstimatedValue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AgroColors.primaryDark,
                    ),
                  ),
                  Row(
                    children: [
                      // Cancel Button (for active listings)
                      if (item.isActive) ...[
                        OutlinedButton(
                          onPressed: () => _confirmCancel(context, item),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 34),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Edit Button (for active listings)
                      if (item.isActive) ...[
                        OutlinedButton(
                          onPressed: () => widget.onEditSale(item),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AgroColors.primaryDark,
                            side: const BorderSide(color: AgroColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 34),
                          ),
                          child: const Text('Edit', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // View Details Button
                      ElevatedButton(
                        onPressed: () => widget.onViewSaleDetails(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AgroColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: const Size(0, 34),
                        ),
                        child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
