import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/labour.dart';
import 'status_badge.dart';

class LabourCard extends StatelessWidget {
  final LabourWorker worker;
  final VoidCallback onRequest;

  const LabourCard({
    Key? key,
    required this.worker,
    required this.onRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(worker.image),
                  backgroundColor: AgroColors.primaryContainer,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            worker.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AgroColors.textDark,
                            ),
                          ),
                          StatusBadge(status: worker.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Work: ${worker.work}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AgroColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.history, size: 14, color: AgroColors.textMuted),
                          const SizedBox(width: 4),
                          Text('${worker.experience} experience', style: const TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.near_me, size: 14, color: AgroColors.textMuted),
                          const SizedBox(width: 4),
                          Text(worker.distance, style: const TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AgroColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Wage', style: TextStyle(fontSize: 12, color: AgroColors.textLight)),
                    Text(
                      '₹${worker.dailyWage.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgroColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Request', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
