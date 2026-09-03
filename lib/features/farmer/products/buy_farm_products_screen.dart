import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/search_bar.dart';

class BuyFarmProductsScreen extends StatefulWidget {
  final List<FarmProduct> products;
  final Function(FarmProduct) onViewProduct;
  final VoidCallback onOpenCart;
  final int cartItemCount;

  const BuyFarmProductsScreen({
    Key? key,
    required this.products,
    required this.onViewProduct,
    required this.onOpenCart,
    required this.cartItemCount,
  }) : super(key: key);

  @override
  State<BuyFarmProductsScreen> createState() => _BuyFarmProductsScreenState();
}

class _BuyFarmProductsScreenState extends State<BuyFarmProductsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.seller.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Farm Products'),
        actions: [
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
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AgroColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.cartItemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: AgroSearchBar(
              hintText: 'Search products...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Categories Scroll
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.productCategories.length,
              itemBuilder: (context, index) {
                final cat = AppConstants.productCategories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AgroColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Products Grid
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No farm products found matching your search.', style: TextStyle(color: AgroColors.textMuted)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filtered[index],
                        onView: () => widget.onViewProduct(filtered[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
