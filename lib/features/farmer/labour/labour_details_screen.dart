import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/labour.dart';
import '../../../widgets/status_badge.dart';

class LabourDetailsScreen extends StatelessWidget {
  final LabourWorker worker;
  final VoidCallback onBack;
  final VoidCallback onHireWorker;

  const LabourDetailsScreen({
    Key? key,
    required this.worker,
    required this.onBack,
    required this.onHireWorker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            title: const Text('Worker Details'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? constraints.maxWidth * 0.15 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AgroColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(worker.image),
                                  backgroundColor: AgroColors.primaryContainer,
                                  onBackgroundImageError: (_, __) {},
                                  child: Text(
                                    worker.name.isNotEmpty ? worker.name[0].toUpperCase() : 'W',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AgroColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: AgroColors.textDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      StatusBadge(status: worker.status),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AgroColors.primaryContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          worker.work,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AgroColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.star, size: 16, color: Colors.amber),
                                      const SizedBox(width: 3),
                                      Text(
                                        worker.rating.toStringAsFixed(1),
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                      ),
                                      Text(
                                        ' (${worker.reviewsCount} reviews)',
                                        style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 15, color: AgroColors.textLight),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${worker.location} (${worker.distance})',
                                          style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30, color: AgroColors.border),
                        // Quick Stats Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statColumn('Daily Rate', '₹${worker.dailyWage.toStringAsFixed(0)}', AgroColors.primary),
                            _dividerVertical(),
                            _statColumn('Hourly Rate', '₹${worker.hourlyRate.toStringAsFixed(0)}', AgroColors.textDark),
                            _dividerVertical(),
                            _statColumn('Experience', worker.experience, AgroColors.textDark),
                            _dividerVertical(),
                            _statColumn('Jobs Done', '${worker.completedJobs}', Colors.blue.shade700),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Availability & Contact Info Card
                Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AgroColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              worker.isAvailable ? Icons.check_circle_outline : Icons.schedule,
                              color: worker.isAvailable ? const Color(0xFF2E7D32) : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              worker.isAvailable ? 'Currently Available for Work' : 'Currently Booked on Assignment',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: worker.isAvailable ? const Color(0xFF2E7D32) : Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          worker.isAvailable
                              ? 'This worker can be booked immediately for your upcoming farm tasks.'
                              : 'This worker is currently on a job. You can still send a request for future dates.',
                          style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Skills Section
                const Text(
                  'Agricultural Skills & Operations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (worker.skills.isNotEmpty
                          ? worker.skills
                          : [worker.work, 'General Farm Work', 'Crop Harvesting'])
                      .map((skill) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFC8E6C9)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check, size: 14, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 6),
                                Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1B5E20),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),

                // About / Description
                const Text(
                  'About Worker',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AgroColors.border),
                  ),
                  child: Text(
                    worker.about.isNotEmpty
                        ? worker.about
                        : 'Experienced agricultural farm worker with proven skills in field preparation, weeding, pest control, and harvesting.',
                    style: const TextStyle(fontSize: 14, height: 1.5, color: AgroColors.textDark),
                  ),
                ),
                const SizedBox(height: 24),

                // Direct Guarantee Note
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.verified_user_outlined, color: Color(0xFFF57F17)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Direct Farmer Connection: Zero middleman commission. Agree on wages and details directly with the worker upon request acceptance.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF5D4037)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Hire / Send Request Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onHireWorker,
                    icon: const Icon(Icons.send, size: 20),
                    label: Text(
                      'Hire / Send Labour Request (₹${worker.dailyWage.toStringAsFixed(0)}/day)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AgroColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AgroColors.textLight)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
        ),
      ],
    );
  }

  Widget _dividerVertical() {
    return Container(
      height: 28,
      width: 1,
      color: AgroColors.border,
    );
  }
}
