import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/labour.dart';
import 'status_badge.dart';

class LabourCard extends StatelessWidget {
  final LabourWorker worker;
  final VoidCallback onRequest;
  final VoidCallback? onTap;

  const LabourCard({
    Key? key,
    required this.worker,
    required this.onRequest,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border, width: 0.8),
      ),
      child: InkWell(
        onTap: onTap ?? onRequest,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(worker.image),
                        backgroundColor: AgroColors.primaryContainer,
                        onBackgroundImageError: (_, __) {},
                        child: Text(
                          worker.name.isNotEmpty ? worker.name[0].toUpperCase() : 'W',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: worker.isAvailable ? const Color(0xFF2E7D32) : Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
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
                                worker.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            StatusBadge(status: worker.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AgroColors.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                worker.work,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.primaryDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              worker.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                            Text(
                              ' (${worker.reviewsCount})',
                              style: const TextStyle(fontSize: 11, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AgroColors.textLight),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '${worker.location} • ${worker.distance}',
                                style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.work_history_outlined, size: 14, color: AgroColors.textLight),
                            const SizedBox(width: 3),
                            Text(
                              '${worker.experience} exp • ${worker.completedJobs} jobs done',
                              style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AgroColors.border),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Daily Rate', style: TextStyle(fontSize: 11, color: AgroColors.textLight)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹${worker.dailyWage.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                          ),
                          const SizedBox(width: 2),
                          const Text('/ day', style: TextStyle(fontSize: 11, color: AgroColors.textMuted)),
                          const SizedBox(width: 8),
                          Text('(₹${worker.hourlyRate.toStringAsFixed(0)}/hr)', style: const TextStyle(fontSize: 11, color: AgroColors.textLight)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: onTap ?? onRequest,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(color: AgroColors.primary),
                        ),
                        child: const Text('Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primaryDark)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AgroColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Hire / Request', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
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
