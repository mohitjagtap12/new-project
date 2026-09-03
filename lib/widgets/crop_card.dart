import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/crop.dart';
import 'status_badge.dart';

class CropCard extends StatelessWidget {
  final Crop crop;
  final VoidCallback onView;
  final VoidCallback onEdit;

  const CropCard({
    Key? key,
    required this.crop,
    required this.onView,
    required this.onEdit,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    crop.image,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 75,
                      height: 75,
                      color: AgroColors.primaryContainer,
                      child: const Icon(Icons.agriculture, color: AgroColors.primary, size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              crop.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                          ),
                          StatusBadge(status: crop.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop.variety} • ${crop.area}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AgroColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AgroColors.border),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Planted:',
                        style: TextStyle(fontSize: 12, color: AgroColors.textLight),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crop.plantingDate,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harvest:',
                        style: TextStyle(fontSize: 12, color: AgroColors.textLight),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crop.expectedHarvest,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(0, 40),
                      side: const BorderSide(color: AgroColors.border),
                    ),
                    child: const Text('Edit', style: TextStyle(color: AgroColors.textDark)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(0, 40),
                      backgroundColor: AgroColors.primary,
                    ),
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
