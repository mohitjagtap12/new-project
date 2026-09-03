import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../widgets/status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  final AgroOrder order;

  const OrderDetailsScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  int get _currentStepIndex {
    switch (order.status.toLowerCase()) {
      case 'placed':
        return 0;
      case 'accepted':
        return 1;
      case 'on the way':
        return 2;
      case 'delivered':
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Placed', 'Accepted', 'On the Way', 'Delivered'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AgroColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.orderNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textMuted)),
                      StatusBadge(status: order.status, fontSize: 13),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order.itemTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Category: ${order.category} • Placed on ${order.date}',
                    style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Progress Stepper Section
            const Text('Order Progress', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AgroColors.border),
              ),
              child: Column(
                children: List.generate(steps.length, (index) {
                  final isDone = index <= _currentStepIndex;
                  final isCurrent = index == _currentStepIndex;
                  final isLast = index == steps.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isDone ? AgroColors.primary : AgroColors.surfaceVariant,
                            child: isDone
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : Text('${index + 1}', style: const TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 34,
                              color: index < _currentStepIndex ? AgroColors.primary : AgroColors.border,
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          steps[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isDone ? AgroColors.textDark : AgroColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Order Financial & Quantity Breakdown
            const Text('Summary', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AgroColors.border),
              ),
              child: Column(
                children: [
                  _row('Quantity', order.quantity),
                  const SizedBox(height: 10),
                  _row(order.isBuying ? 'Seller' : 'Buyer', order.counterParty),
                  const SizedBox(height: 10),
                  _row('Delivery Address', order.address),
                  const Divider(height: 24, color: AgroColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                      Text('₹${order.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AgroColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AgroColors.textLight)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.textDark),
          ),
        ),
      ],
    );
  }
}
