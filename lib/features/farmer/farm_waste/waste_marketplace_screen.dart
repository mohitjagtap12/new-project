import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/farm_waste.dart';
import '../../../widgets/agro_search_bar.dart';

class WasteMarketplaceScreen extends StatefulWidget {
  final List<FarmWaste> listings;
  final Function(FarmWaste) onSelectListing;
  final VoidCallback onSellWaste;
  final VoidCallback onViewMyListings;
  final VoidCallback? onBack;

  const WasteMarketplaceScreen({
    Key? key,
    required this.listings,
    required this.onSelectListing,
    required this.onSellWaste,
    required this.onViewMyListings,
    this.onBack,
  }) : super(key: key);

  @override
  State<WasteMarketplaceScreen> createState() => _WasteMarketplaceScreenState();
}

class _WasteMarketplaceScreenState extends State<WasteMarketplaceScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Locations';
  String _sortBy = 'Newest'; // 'Newest', 'Price: Low to High', 'Price: High to Low', 'Quantity'

  final List<String> _categories = [
    'All',
    'Wheat Straw',
    'Rice Straw',
    'Sugarcane Trash',
    'Maize Stalks',
    'Cotton Stalks',
    'Coconut Shell/Husk Waste',
  ];

  @override
  Widget build(BuildContext context) {
    // Only show active listings in marketplace by default (or all with status indicator)
    var items = widget.listings.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.wasteType.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesLocation = _selectedLocation == 'All Locations' ||
          item.location.toLowerCase().contains(_selectedLocation.toLowerCase());
      final matchesQuery = _searchQuery.isEmpty ||
          item.wasteType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.sellerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesLocation && matchesQuery;
    }).toList();

    // Sort
    if (_sortBy == 'Price: Low to High') {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      items.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Quantity') {
      items.sort((a, b) => b.numericQuantity.compareTo(a.numericQuantity));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agri Waste Marketplace'),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        actions: [
          TextButton.icon(
            onPressed: widget.onViewMyListings,
            icon: const Icon(Icons.inventory_2_outlined, size: 18),
            label: const Text('My Listings', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onSellWaste,
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Sell Farm Waste', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: AgroSearchBar(
              hintText: 'Search straw, trash, stalks, location...',
              showFilter: true,
              onChanged: (val) => setState(() => _searchQuery = val),
              onFilterTap: _showFilterModal,
            ),
          ),

          // Categories Horizontal Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.brown.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.brown.shade900 : AgroColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat);
                  },
                );
              },
            ),
          ),

          // Sort & Active Filter Indicators Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${items.length} listings available',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) => setState(() => _sortBy = val),
                  child: Row(
                    children: [
                      const Icon(Icons.sort, size: 16, color: AgroColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        _sortBy,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primary),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 18, color: AgroColors.primary),
                    ],
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Newest', child: Text('Newest')),
                    const PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                    const PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                    const PopupMenuItem(value: 'Quantity', child: Text('Quantity: High to Low')),
                  ],
                ),
              ],
            ),
          ),

          // Waste Cards List
          Expanded(
            child: items.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final waste = items[index];
                      return _buildMarketplaceCard(waste);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceCard(FarmWaste waste) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AgroColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onSelectListing(waste),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Overlays
            Stack(
              children: [
                Image.network(
                  waste.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.brown.shade100,
                    child: Icon(Icons.recycling, size: 48, color: Colors.brown.shade400),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      waste.wasteType,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: waste.isActive ? AgroColors.primary : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      waste.status,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          waste.wasteType,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                      ),
                      Text(
                        '${waste.formattedPrice}/${waste.quantityUnit}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Quantity & Available Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.brown.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.scale, size: 14, color: Colors.brown),
                            const SizedBox(width: 4),
                            Text(
                              waste.formattedQuantity,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown.shade900),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: AgroColors.primaryDark),
                            const SizedBox(width: 4),
                            Text(
                              'Ready: ${waste.availableDate}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location & Seller
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AgroColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          waste.location,
                          style: const TextStyle(fontSize: 13, color: AgroColors.textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'By ${waste.sellerName}',
                        style: const TextStyle(fontSize: 12, color: AgroColors.textMuted, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => widget.onSelectListing(waste),
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text('View Details'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => widget.onSelectListing(waste),
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Contact / Buy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter Agricultural Waste', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedLocation = 'All Locations';
                        _sortBy = 'Newest';
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Reset All'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All Locations', 'Baramati', 'Pune', 'Indapur', 'Jalna', 'Ratnagiri', 'Shirur'].map((loc) {
                  final isSel = _selectedLocation == loc;
                  return ChoiceChip(
                    label: Text(loc),
                    selected: isSel,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedLocation = loc);
                        Navigator.of(ctx).pop();
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Newest', 'Price: Low to High', 'Price: High to Low', 'Quantity'].map((sort) {
                  final isSel = _sortBy == sort;
                  return ChoiceChip(
                    label: Text(sort),
                    selected: isSel,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _sortBy = sort);
                        Navigator.of(ctx).pop();
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
              child: Icon(Icons.filter_alt_off, size: 56, color: Colors.brown.shade400),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Waste Listings Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'No listings matched your active filters or search terms.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AgroColors.textMuted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                  _selectedLocation = 'All Locations';
                  _sortBy = 'Newest';
                });
              },
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
