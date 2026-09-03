import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/labour.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

class MyRequestsScreen extends StatelessWidget {
  final List<LabourRequest> requests;
  final VoidCallback onFindLabour;

  const MyRequestsScreen({
    Key? key,
    required this.requests,
    required this.onFindLabour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: requests.isEmpty
          ? EmptyStateWidget(
              title: 'No labour requests yet.',
              description: 'Hire skilled farm workers for planting, spraying, harvesting, and weeding.',
              icon: Icons.people_outline,
              buttonText: 'Find Labour',
              onButtonPressed: onFindLabour,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              req.workerName,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                            StatusBadge(status: req.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Work: ${req.work}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AgroColors.textLight),
                            const SizedBox(width: 4),
                            Text('Date: ${req.date}', style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                            const Spacer(),
                            const Icon(Icons.groups, size: 16, color: AgroColors.textLight),
                            const SizedBox(width: 4),
                            Text('Workers: ${req.workersNeeded}', style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                          ],
                        ),
                        const Divider(height: 20, color: AgroColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wage: ₹${req.dailyWage.toStringAsFixed(0)} / day',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            ),
                            Text(
                              'Total: ₹${(req.dailyWage * req.workersNeeded).toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AgroColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
