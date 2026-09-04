import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/product.dart';
import '../../../widgets/product_card.dart';

class BuyFarmProductsScreen extends StatefulWidget {
  final List<FarmProduct> products;
  final Function(FarmProduct) onViewProduct;
  final VoidCallback onOpenCart;
  final int cartItemCount;
  final Function(FarmProduct, int)? onQuickAddToCart;

  const BuyFarmProductsScreen({
    Key? key,
    required this.products,
    required this.onViewProduct,
    required this.onOpenCart,
    required this.cartItemCount,
    this.onQuickAddToCart,
  }) : super(key: key);

  @override
  State<BuyFarmProductsScreen> createState() => _BuyFarmProductsScreenState();
}

class _BuyFarmProductsScreenState extends State<BuyFarmProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Locations';
  String _sortBy = 'Featured';
  bool _onlyInStock = false;
  String _searchQuery = '';

  final List<String> _sortOptions = [
    'Featured',
    'Price: Low to High',
    'Price: High to Low',
    'Top Rated',
    'Name: A-Z',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedLocation = 'All Locations';
      _sortBy = 'Featured';
      _onlyInStock = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  bool get _hasActiveFilters =>
      _selectedCategory != 'All' ||
      _selectedLocation != 'All Locations' ||
      _sortBy != 'Featured' ||
      _onlyInStock ||
      _searchQuery.isNotEmpty;

  List<String> get _availableLocations {
    final locs = widget.products.map((p) => p.sellerLocation).toSet().toList();
    locs.sort();
    return ['All Locations', ...locs];
  }

  List<FarmProduct> get _filteredAndSortedProducts {
    var list = widget.products.where((p) {
      // Category filter
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;

      // Location filter
      final matchesLocation = _selectedLocation == 'All Locations' ||
          p.sellerLocation.toLowerCase() == _selectedLocation.toLowerCase();

      // In stock filter
      final matchesStock = !_onlyInStock || p.isInStock;

      // Search query
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.sellerName.toLowerCase().contains(q) ||
          p.sellerLocation.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);

      return matchesCategory && matchesLocation && matchesStock && matchesQuery;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Top Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name: A-Z':
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'Featured':
      default:
        // Default order
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAndSortedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Farm Products'),
        actions: [
          if (_hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              tooltip: 'Reset Filters',
              onPressed: _resetFilters,
            ),
          // Cart Button with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 26),
                onPressed: widget.onOpenCart,
                tooltip: 'Cart',
              ),
              if (widget.cartItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AgroColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      widget.cartItemCount > 99 ? '99+' : widget.cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search seeds, fertilizers, tools, sellers...',
                prefixIcon: const Icon(Icons.search, color: AgroColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AgroColors.surfaceVariant.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AgroColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AgroColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AgroColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Horizontal Category Filter Chips
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.productCategories.length,
              itemBuilder: (context, index) {
                final cat = AppConstants.productCategories[index];
                final isSelected = _selectedCategory == cat;
                final count = cat == 'All'
                    ? widget.products.length
                    : widget.products.where((p) => p.category == cat).length;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat == 'All' ? 'All ($count)' : '$cat ($count)'),
                    selected: isSelected,
                    selectedColor: AgroColors.primaryContainer,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AgroColors.primary : AgroColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12.5,
                    ),
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),

          // Secondary Filters (Location, Sort, In-stock Toggle)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                // Location Filter Dropdown
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLocation,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 20, color: AgroColors.textMuted),
                        style: const TextStyle(fontSize: 12, color: AgroColors.textDark),
                        items: _availableLocations.map((loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(
                              loc,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedLocation = val);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Sort Dropdown
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        icon: const Icon(Icons.sort, size: 18, color: AgroColors.textMuted),
                        style: const TextStyle(fontSize: 12, color: AgroColors.textDark),
                        items: _sortOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(
                              opt,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _sortBy = val);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // In-Stock Only Chip
                InkWell(
                  onTap: () => setState(() => _onlyInStock = !_onlyInStock),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _onlyInStock ? AgroColors.primaryContainer : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _onlyInStock ? AgroColors.primary : AgroColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _onlyInStock ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 16,
                          color: _onlyInStock ? AgroColors.primaryDark : AgroColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _onlyInStock ? FontWeight.bold : FontWeight.normal,
                            color: _onlyInStock ? AgroColors.primaryDark : AgroColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Count bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filtered.length} products',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AgroColors.textMuted,
                  ),
                ),
                if (_hasActiveFilters)
                  GestureDetector(
                    onTap: _resetFilters,
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AgroColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Products Responsive Grid
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AgroColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off,
                              size: 48,
                              color: AgroColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No agricultural products found',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AgroColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try clearing search keywords or choosing another category or location.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Reset All Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AgroColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 2;
                      double childAspectRatio = 0.58;

                      if (width >= 1100) {
                        crossAxisCount = 4;
                        childAspectRatio = 0.70;
                      } else if (width >= 750) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.65;
                      } else {
                        crossAxisCount = 2;
                        childAspectRatio = 0.58;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return ProductCard(
                            product: product,
                            onView: () => widget.onViewProduct(product),
                            onAddToCart: widget.onQuickAddToCart != null && product.isInStock
                                ? () {
                                    widget.onQuickAddToCart!(product, 1);
                                    AppUtils.showSnackBar(
                                      context,
                                      'Added 1 x ${product.name} to cart',
                                    );
                                  }
                                : null,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
