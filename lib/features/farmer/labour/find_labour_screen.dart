import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/labour.dart';
import '../../../widgets/labour_card.dart';
import '../../../widgets/primary_button.dart';

class FindLabourScreen extends StatefulWidget {
  final List<LabourWorker> workers;
  final Function(LabourWorker, LabourRequest) onRequestWorker;
  final VoidCallback onViewMyRequests;

  const FindLabourScreen({
    Key? key,
    required this.workers,
    required this.onRequestWorker,
    required this.onViewMyRequests,
  }) : super(key: key);

  @override
  State<FindLabourScreen> createState() => _FindLabourScreenState();
}

class _FindLabourScreenState extends State<FindLabourScreen> {
  String _selectedWorkFilter = 'All';
  String _selectedWork = 'Harvesting';
  final _workersNeededController = TextEditingController(text: '3');
  final _dateController = TextEditingController(text: '08 Sep 2026');
  final _dailyWageController = TextEditingController(text: '500');
  final _locationController = TextEditingController(text: 'Pune');

  @override
  void dispose() {
    _workersNeededController.dispose();
    _dateController.dispose();
    _dailyWageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showRequestDialog(LabourWorker worker) {
    setState(() {
      _selectedWork = worker.work;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request ${worker.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Daily Wage: ₹${worker.dailyWage.toStringAsFixed(0)}'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedWork,
              items: AppConstants.labourWorkTypes.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
              onChanged: (val) {
                if (val != null) {
                  _selectedWork = val;
                }
              },
              decoration: const InputDecoration(labelText: 'Work Type', prefixIcon: Icon(Icons.work_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _workersNeededController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Workers Needed'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date Needed', prefixIcon: Icon(Icons.calendar_today)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Farm Location', prefixIcon: Icon(Icons.location_on)),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Send Labour Request',
              onPressed: () {
                final req = LabourRequest(
                  id: 'lr_${DateTime.now().millisecondsSinceEpoch}',
                  workerName: worker.name,
                  work: _selectedWork,
                  date: _dateController.text.trim(),
                  workersNeeded: int.tryParse(_workersNeededController.text.trim()) ?? 1,
                  dailyWage: worker.dailyWage,
                  status: 'Requested',
                  location: _locationController.text.trim(),
                );
                widget.onRequestWorker(worker, req);
                Navigator.of(ctx).pop();
                AppUtils.showSnackBar(context, 'Labour request sent to ${worker.name}');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkers = _selectedWorkFilter == 'All'
        ? widget.workers
        : widget.workers.where((w) => w.work.toLowerCase() == _selectedWorkFilter.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Labour'),
        actions: [
          TextButton.icon(
            onPressed: widget.onViewMyRequests,
            icon: const Icon(Icons.history, color: AgroColors.primary),
            label: const Text('My Requests', style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    child: const Icon(Icons.people, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Find Labour',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Find people for your farm work.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF1565C0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Work Types Filter Chips
            const Text(
              'Select Work Needed',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ...AppConstants.labourWorkTypes].map((work) {
                  final isSelected = _selectedWorkFilter == work;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(work),
                      selected: isSelected,
                      selectedColor: AgroColors.primaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) => setState(() => _selectedWorkFilter = work),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Available Labour List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Workers (${filteredWorkers.length})',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                const Text('Nearby verified', style: TextStyle(fontSize: 12, color: AgroColors.textMuted)),
              ],
            ),
            const SizedBox(height: 12),

            ...filteredWorkers.map((worker) => LabourCard(
                  worker: worker,
                  onRequest: () => _showRequestDialog(worker),
                )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
