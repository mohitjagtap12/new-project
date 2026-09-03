import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onRemoveItem;
  final Function(CartItem, int) onUpdateQuantity;
  final VoidCallback onCheckout;
  final VoidCallback onContinueShopping;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onUpdateQuantity,
    required this.onCheckout,
    required this.onContinueShopping,
  }) : super(key: key);

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get delivery => cartItems.isEmpty ? 0 : 50.0;
  double get total => subtotal + delivery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? EmptyStateWidget(
              title: 'Your cart is empty.',
              description: 'Explore seeds, fertilizers, farm medicines and equipment in the store.',
              icon: Icons.shopping_cart_outlined,
              buttonText: 'Buy Farm Products',
              onButtonPressed: onContinueShopping,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.image,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 70,
                                    height: 70,
                                    color: AgroColors.primaryContainer,
                                    child: const Icon(Icons.shopping_bag, color: AgroColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${item.product.price.toStringAsFixed(0)} each',
                                      style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹${item.total.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AgroColors.primary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => onRemoveItem(item),
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Order Price Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AgroColors.border)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: AgroColors.textMuted, fontSize: 15)),
                          Text('₹${subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery', style: TextStyle(color: AgroColors.textMuted, fontSize: 15)),
                          Text('₹${delivery.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const Divider(height: 20, color: AgroColors.border),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.textDark)),
                          Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AgroColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Checkout',
                        icon: Icons.lock_outline,
                        onPressed: onCheckout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
