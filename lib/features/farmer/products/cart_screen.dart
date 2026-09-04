import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/product.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onRemoveItem;
  final Function(CartItem, int) onUpdateQuantity;
  final VoidCallback onCheckout;
  final VoidCallback onContinueShopping;
  final VoidCallback? onClearCart;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onUpdateQuantity,
    required this.onCheckout,
    required this.onContinueShopping,
    this.onClearCart,
  }) : super(key: key);

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get delivery => cartItems.isEmpty ? 0 : (subtotal >= 2000 ? 0.0 : 50.0);
  double get discount => subtotal >= 3000 ? 100.0 : 0.0;
  double get total => (subtotal + delivery - discount).clamp(0.0, double.infinity);

  void _handleIncrease(BuildContext context, CartItem item) {
    final maxAvailable = item.product.availableQuantity;
    if (item.quantity >= maxAvailable) {
      AppUtils.showSnackBar(
        context,
        'Stock limit reached! Only $maxAvailable ${item.product.quantityUnit} available for ${item.product.name}.',
      );
      return;
    }
    onUpdateQuantity(item, item.quantity + 1);
  }

  void _handleDecrease(BuildContext context, CartItem item) {
    if (item.quantity > 1) {
      onUpdateQuantity(item, item.quantity - 1);
    } else {
      _showRemoveConfirmation(context, item);
    }
  }

  void _showRemoveConfirmation(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Product?'),
        content: Text('Do you want to remove "${item.product.name}" from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep in Cart'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              onRemoveItem(item);
              AppUtils.showSnackBar(context, '${item.product.name} removed from cart.');
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Entire Cart?'),
        content: const Text('Are you sure you want to remove all products from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              if (onClearCart != null) {
                onClearCart!();
              } else {
                for (final it in List<CartItem>.from(cartItems)) {
                  onRemoveItem(it);
                }
              }
              AppUtils.showSnackBar(context, 'Cart has been cleared.');
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cartItems.fold(0, (sum, i) => sum + i.quantity)} items)'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton.icon(
              onPressed: () => _showClearCartConfirmation(context),
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red, size: 20),
              label: const Text('Clear', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? EmptyStateWidget(
              title: 'Your cart is empty.',
              description: 'Explore certified seeds, bio-fertilizers, farm tools, and irrigation equipment in the store.',
              icon: Icons.shopping_cart_outlined,
              buttonText: 'Buy Farm Products',
              onButtonPressed: onContinueShopping,
            )
          : isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
    );
  }

  // Desktop 2-Column Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items List (65% width)
          Expanded(
            flex: 65,
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) => _buildCartItemCard(context, cartItems[index]),
            ),
          ),
          const SizedBox(width: 24),
          // Cart Order Summary (35% width)
          Expanded(
            flex: 35,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _buildSummaryContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Single-Column Layout with Bottom Summary
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildCartItemCard(context, cartItems[index]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
            border: const Border(top: BorderSide(color: AgroColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: _buildSummaryContent(context),
          ),
        ),
      ],
    );
  }

  // Individual Cart Item Card
  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final prod = item.product;
    final isMaxReached = item.quantity >= prod.availableQuantity;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                prod.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: AgroColors.primaryContainer,
                  child: const Icon(Icons.shopping_bag, color: AgroColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Details and Quantity Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Delete
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          prod.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AgroColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AgroColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _showRemoveConfirmation(context, item),
                        tooltip: 'Remove from cart',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Seller Name
                  Row(
                    children: [
                      const Icon(Icons.storefront_outlined, size: 13, color: AgroColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          prod.seller,
                          style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price per Unit
                  Text(
                    '₹${prod.price.toStringAsFixed(0)} / ${prod.priceUnit}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.primary),
                  ),

                  if (isMaxReached) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Max available stock reached (${prod.availableQuantity} ${prod.quantityUnit})',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Stepper & Item Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Stepper
                      Container(
                        decoration: BoxDecoration(
                          color: AgroColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _handleDecrease(context, item),
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Icon(
                                  item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                                  size: 16,
                                  color: item.quantity == 1 ? Colors.red : AgroColors.textDark,
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 32),
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: isMaxReached ? () => _handleIncrease(context, item) : () => _handleIncrease(context, item),
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                  color: isMaxReached ? AgroColors.textLight : AgroColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Item Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Item Total',
                            style: TextStyle(fontSize: 10, color: AgroColors.textMuted),
                          ),
                          Text(
                            '₹${item.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AgroColors.primaryDark,
                            ),
                          ),
                        ],
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

  // Summary Card Content
  Widget _buildSummaryContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
        ),
        const SizedBox(height: 14),

        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(color: AgroColors.textMuted, fontSize: 14)),
            Text('₹${subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),

        // Delivery Charge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('Delivery Charge', style: TextStyle(color: AgroColors.textMuted, fontSize: 14)),
                if (delivery == 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: const Text('FREE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ],
              ],
            ),
            Text(
              delivery == 0 ? '₹0' : '₹${delivery.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: delivery == 0 ? Colors.green : AgroColors.textDark,
              ),
            ),
          ],
        ),

        // Discount if applicable
        if (discount > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Volume Discount', style: TextStyle(color: Colors.green, fontSize: 14)),
              Text('-₹${discount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
            ],
          ),
        ],

        if (subtotal < 2000 && subtotal > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              'Add ₹${(2000 - subtotal).toStringAsFixed(0)} more for FREE farm delivery.',
              style: TextStyle(fontSize: 11, color: Colors.amber.shade900, fontWeight: FontWeight.w600),
            ),
          ),
        ],

        const Divider(height: 24, color: AgroColors.border),

        // Final Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Final Total',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AgroColors.textDark),
            ),
            Text(
              '₹${total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AgroColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Checkout Button
        PrimaryButton(
          label: 'Proceed to Checkout',
          icon: Icons.arrow_forward,
          onPressed: onCheckout,
        ),
      ],
    );
  }
}
