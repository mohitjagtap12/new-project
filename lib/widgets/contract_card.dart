import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/contract.dart';
import 'status_badge.dart';

class ContractCard extends StatelessWidget {
  final FarmContract contract;
  final VoidCallback onView;

  const ContractCard({
    Key? key,
    required this.contract,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    contract.company,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                  ),
                ),
                StatusBadge(status: contract.status),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AgroColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoCol('Crop', contract.crop),
                  _divider(),
                  _infoCol('Quantity', contract.quantity),
                  _divider(),
                  _infoCol('Price', '₹${contract.price.toStringAsFixed(0)}/kg'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: AgroColors.textLight),
                const SizedBox(width: 4),
                Text(contract.location, style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 14, color: AgroColors.textLight),
                const SizedBox(width: 4),
                Text('Last Date: ${contract.lastDate}', style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AgroColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('View Contract', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCol(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AgroColors.textLight)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 24, color: AgroColors.border);
  }
}
