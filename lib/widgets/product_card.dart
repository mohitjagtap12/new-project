import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final FarmProduct product;
  final VoidCallback onView;
  final VoidCallback? onAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onView,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLimited = product.isLimitedStock;
    final isOutOfStock = !product.isInStock;

    final statusColor = isOutOfStock
        ? Colors.red.shade700
        : isLimited
            ? Colors.orange.shade800
            : AgroColors.primaryDark;

    final statusBg = isOutOfStock
        ? Colors.red.shade50
        : isLimited
            ? Colors.orange.shade50
            : AgroColors.primaryContainer;

    return Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AgroColors.border.withOpacity(0.6), width: 1),
      ),
      child: InkWell(
        onTap: onView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 125,
                  width: double.infinity,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AgroColors.primaryContainer,
                      child: const Center(
                        child: Icon(Icons.inventory_2_outlined, color: AgroColors.primary, size: 36),
                      ),
                    ),
                  ),
                ),
                // Category Chip (Top-left)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Stock Status Badge (Top-right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withOpacity(0.3), width: 0.8),
                    ),
                    child: Text(
                      product.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AgroColors.textDark,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Price & Price Unit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AgroColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '/ ${product.priceUnit}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AgroColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Available Quantity
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: isOutOfStock ? Colors.red : AgroColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Stock: ${product.availableQuantityText}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isOutOfStock ? Colors.red : AgroColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Seller & Location
                  Row(
                    children: [
                      const Icon(Icons.storefront_outlined, size: 13, color: AgroColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${product.sellerName} • ${product.sellerLocation}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AgroColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Action Buttons: View Details & Optional Add to Cart
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: onView,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AgroColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      if (onAddToCart != null && product.isInStock) ...[
                        const SizedBox(width: 6),
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: IconButton(
                            icon: const Icon(Icons.add_shopping_cart, size: 16),
                            onPressed: onAddToCart,
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              backgroundColor: AgroColors.primaryContainer,
                              foregroundColor: AgroColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            tooltip: 'Add to Cart',
                          ),
                        ),
                      ],
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
}
