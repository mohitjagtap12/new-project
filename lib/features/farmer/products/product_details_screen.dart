import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/product.dart';
import '../../../widgets/primary_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final FarmProduct product;
  final Function(FarmProduct, int) onAddToCart;
  final Function(FarmProduct, int) onBuyNow;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              p.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: AgroColors.primaryContainer,
                child: const Icon(Icons.shopping_bag, size: 80, color: AgroColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AgroColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.category,
                      style: const TextStyle(color: AgroColors.primaryDark, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '₹${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AgroColors.primary),
                      ),
                      const SizedBox(width: 8),
                      const Text('(Inclusive of all taxes)', style: TextStyle(fontSize: 12, color: AgroColors.textLight)),
                    ],
                  ),
                  const Divider(height: 28, color: AgroColors.border),

                  // Store and Location
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AgroColors.surfaceVariant,
                        child: const Icon(Icons.store, color: AgroColors.primaryDark),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.seller, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                          Text(p.location, style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock Availability
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AgroColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 20, color: AgroColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          'Available Stock: ${p.availableQuantity}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: const TextStyle(fontSize: 14, color: AgroColors.textMuted, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    children: [
                      const Text('Quantity:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AgroColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text(
                              _quantity.toString(),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Add to Cart',
                          icon: Icons.add_shopping_cart,
                          isOutlined: true,
                          onPressed: () {
                            widget.onAddToCart(p, _quantity);
                            AppUtils.showSnackBar(context, 'Added to cart');
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Buy Now',
                          icon: Icons.flash_on,
                          onPressed: () => widget.onBuyNow(p, _quantity),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
