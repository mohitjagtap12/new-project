import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final AgroOrder order;
  final Function(AgroOrder) onViewOrder;
  final VoidCallback onViewMyOrders;
  final VoidCallback onContinueShopping;
  final VoidCallback onReturnDashboard;

  const OrderConfirmationScreen({
    Key? key,
    required this.order,
    required this.onViewOrder,
    required this.onViewMyOrders,
    required this.onContinueShopping,
    required this.onReturnDashboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: onReturnDashboard,
            tooltip: 'Return to Dashboard',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Celebration Icon and Title
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AgroColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.shade300, width: 2),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Order Placed Successfully!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AgroColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Thank you for your order, ${order.customerName ?? 'Farmer'}. Your order is registered.',
                        style: const TextStyle(fontSize: 14, color: AgroColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AgroColors.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Order ID: ',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                            ),
                            Text(
                              order.orderNumber,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AgroColors.primaryDark),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(status: order.status, fontSize: 11),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order Highlights Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 14),

                        _buildInfoRow('Order Date', order.date),
                        _buildInfoRow('Total Amount', '₹${order.price.toStringAsFixed(0)}'),
                        _buildInfoRow('Payment Method', order.paymentMethod),
                        _buildInfoRow('Status', order.status),

                        const Divider(height: 24, color: AgroColors.border),

                        const Text(
                          'Delivery Address',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: AgroColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                [
                                  if (order.customerName != null) order.customerName,
                                  if (order.mobileNumber != null) 'Phone: ${order.mobileNumber}',
                                  order.address,
                                  if (order.village != null && !order.address.contains(order.village!)) 'Village: ${order.village}',
                                  if (order.district != null && !order.address.contains(order.district!)) 'District: ${order.district}',
                                  if (order.state != null && !order.address.contains(order.state!)) order.state,
                                  if (order.pincode != null && !order.address.contains(order.pincode!)) 'PIN: ${order.pincode}',
                                ].where((e) => e != null && e.toString().trim().isNotEmpty).join('\n'),
                                style: const TextStyle(fontSize: 13, color: AgroColors.textDark, height: 1.4),
                              ),
                            ),
                          ],
                        ),

                        if (order.deliveryNotes != null && order.deliveryNotes!.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AgroColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.note_alt_outlined, size: 16, color: AgroColors.textMuted),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Delivery Note: "${order.deliveryNotes}"',
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AgroColors.textMuted),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Ordered Items Breakdown
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ordered Items (${order.items.length})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        if (order.items.isEmpty)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(order.itemTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Qty: ${order.quantity}'),
                            trailing: Text('₹${order.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            separatorBuilder: (context, index) => const Divider(height: 16, color: AgroColors.border),
                            itemBuilder: (context, index) {
                              final item = order.items[index];
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item.image.isNotEmpty
                                        ? Image.network(
                                            item.image,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 48,
                                              height: 48,
                                              color: AgroColors.primaryContainer,
                                              child: const Icon(Icons.shopping_bag, size: 24, color: AgroColors.primary),
                                            ),
                                          )
                                        : Container(
                                            width: 48,
                                            height: 48,
                                            color: AgroColors.primaryContainer,
                                            child: const Icon(Icons.shopping_bag, size: 24, color: AgroColors.primary),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Qty: ${item.quantity} ${item.quantityUnit} × ₹${item.price.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.total.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.primary),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Primary & Secondary Actions
                PrimaryButton(
                  label: 'View Order Details',
                  icon: Icons.receipt_long,
                  onPressed: () => onViewOrder(order),
                ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: onViewMyOrders,
                  icon: const Icon(Icons.list_alt, color: AgroColors.primary),
                  label: const Text(
                    'View My Orders',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AgroColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onContinueShopping,
                        icon: const Icon(Icons.storefront, size: 18),
                        label: const Text('Continue Shopping'),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onReturnDashboard,
                        icon: const Icon(Icons.dashboard_outlined, size: 18),
                        label: const Text('Dashboard'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
        ],
      ),
    );
  }
}
