import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/order.dart';
import 'status_badge.dart';

class OrderCard extends StatelessWidget {
  final AgroOrder order;
  final VoidCallback onTap;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.textMuted),
                  ),
                  StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                order.itemTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.isBuying ? "Seller" : "Buyer"}: ${order.counterParty}',
                style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${order.quantity}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                  ),
                  Text(
                    '₹${order.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.primary),
                  ),
                ],
              ),
              const Divider(height: 20, color: AgroColors.border),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 13, color: AgroColors.textLight),
                      const SizedBox(width: 4),
                      Text(order.date, style: const TextStyle(fontSize: 12, color: AgroColors.textLight)),
                    ],
                  ),
                  Row(
                    children: const [
                      Text('View Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primary)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16, color: AgroColors.primary),
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
