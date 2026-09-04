import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/labour.dart';
import '../../../widgets/primary_button.dart';

class SendLabourRequestScreen extends StatefulWidget {
  final LabourWorker worker;
  final VoidCallback onBack;
  final Function(LabourRequest) onSubmitRequest;

  const SendLabourRequestScreen({
    Key? key,
    required this.worker,
    required this.onBack,
    required this.onSubmitRequest,
  }) : super(key: key);

  @override
  State<SendLabourRequestScreen> createState() => _SendLabourRequestScreenState();
}

class _SendLabourRequestScreenState extends State<SendLabourRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedWork;
  late TextEditingController _cropDescController;
  late TextEditingController _dateController;
  late TextEditingController _workersNeededController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;

  String _selectedDuration = 'Full Day (8 hrs)';
  final List<String> _durationOptions = [
    'Full Day (8 hrs)',
    'Half Day (4 hrs)',
    '2 Days',
    '3 Days',
    '1 Week (7 Days)',
  ];

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _selectedWork = widget.worker.work;
    if (!AppConstants.labourWorkTypes.contains(_selectedWork)) {
      _selectedWork = AppConstants.labourWorkTypes.first;
    }

    _cropDescController = TextEditingController(
      text: '${widget.worker.work} for seasonal crop on farm plot',
    );
    _dateController = TextEditingController(
      text: _formatDate(_selectedDate),
    );
    _workersNeededController = TextEditingController(text: '2');
    _locationController = TextEditingController(
      text: widget.worker.location.isNotEmpty ? widget.worker.location : 'Baramati, Pune',
    );
    _notesController = TextEditingController(
      text: 'Please bring required protective gear. Water and shade available on farm.',
    );
  }

  @override
  void dispose() {
    _cropDescController.dispose();
    _dateController.dispose();
    _workersNeededController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    return '$day $month $year';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  int get _workersCount {
    return int.tryParse(_workersNeededController.text.trim()) ?? 1;
  }

  double get _durationMultiplier {
    switch (_selectedDuration) {
      case 'Half Day (4 hrs)':
        return 0.5;
      case 'Full Day (8 hrs)':
        return 1.0;
      case '2 Days':
        return 2.0;
      case '3 Days':
        return 3.0;
      case '1 Week (7 Days)':
        return 7.0;
      default:
        return 1.0;
    }
  }

  double get _estimatedTotal {
    final count = _workersCount <= 0 ? 1 : _workersCount;
    return widget.worker.dailyWage * count * _durationMultiplier;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final workersCount = int.tryParse(_workersNeededController.text.trim());
    if (workersCount == null || workersCount <= 0) {
      AppUtils.showSnackBar(context, 'Please enter a valid number of workers (at least 1)');
      return;
    }

    final newRequest = LabourRequest(
      id: 'lr_${DateTime.now().millisecondsSinceEpoch}',
      workerId: widget.worker.id,
      workerName: widget.worker.name,
      workerPhone: widget.worker.phone,
      workerImage: widget.worker.image,
      work: _selectedWork,
      cropDescription: _cropDescController.text.trim(),
      date: _dateController.text.trim(),
      duration: _selectedDuration,
      workersNeeded: workersCount,
      dailyWage: widget.worker.dailyWage,
      totalAmount: _estimatedTotal,
      status: 'Pending',
      location: _locationController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: _formatDate(DateTime.now()),
    );

    widget.onSubmitRequest(newRequest);
    AppUtils.showSnackBar(
      context,
      'Labour request sent to ${widget.worker.name} successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            title: const Text('Send Labour Request'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? constraints.maxWidth * 0.18 : 16,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Worker Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(widget.worker.image),
                          backgroundColor: AgroColors.primaryContainer,
                          onBackgroundImageError: (_, __) {},
                          child: Text(
                            widget.worker.name.isNotEmpty ? widget.worker.name[0].toUpperCase() : 'W',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.worker.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Primary Skill: ${widget.worker.work} • ${widget.worker.location}',
                                style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rate: ₹${widget.worker.dailyWage.toStringAsFixed(0)}/day per worker',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Request Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                  ),
                  const SizedBox(height: 14),

                  // Required Work Type Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedWork,
                    items: AppConstants.labourWorkTypes.map((w) {
                      return DropdownMenuItem(value: w, child: Text(w));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedWork = val);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Required Work *',
                      prefixIcon: Icon(Icons.work_outline, color: AgroColors.textLight),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please select required work' : null,
                  ),
                  const SizedBox(height: 16),

                  // Crop / Work Description
                  TextFormField(
                    controller: _cropDescController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Crop / Work Description *',
                      hintText: 'e.g. Tomato harvesting, onion weeding, wheat sowing...',
                      prefixIcon: Icon(Icons.eco_outlined, color: AgroColors.textLight),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please provide a short description of the work needed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Required Date Field
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      labelText: 'Required Date *',
                      prefixIcon: const Icon(Icons.calendar_today, color: AgroColors.textLight),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit_calendar, color: AgroColors.primary),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please select the required date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Workers Needed and Duration in Row
                  Row(
                    children: [
                      // Number of workers
                      Expanded(
                        child: TextFormField(
                          controller: _workersNeededController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Workers Needed *',
                            prefixIcon: Icon(Icons.group_outlined, color: AgroColors.textLight),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter worker count';
                            }
                            final count = int.tryParse(val.trim());
                            if (count == null || count <= 0) {
                              return 'Must be at least 1';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Duration dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedDuration,
                          items: _durationOptions.map((d) {
                            return DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedDuration = val);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Duration *',
                            prefixIcon: Icon(Icons.schedule, color: AgroColors.textLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Farm Location
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Farm Location / Village *',
                      hintText: 'e.g. Near Canal, Indapur, Pune',
                      prefixIcon: Icon(Icons.location_on_outlined, color: AgroColors.textLight),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter farm location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes / Instructions
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Special Notes / Instructions (Optional)',
                      hintText: 'e.g. Reporting time, tools provided, transport note...',
                      prefixIcon: Icon(Icons.notes, color: AgroColors.textLight),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cost Estimate Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AgroColors.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AgroColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Total Wage',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${_estimatedTotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AgroColors.primary,
                              ),
                            ),
                            Text(
                              '(${widget.worker.dailyWage.toStringAsFixed(0)} × $_workersCount worker${_workersCount > 1 ? 's' : ''})',
                              style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Payment will be made directly to workers on completion of work.',
                          style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Submit Button
                  PrimaryButton(
                    label: 'Send Labour Request',
                    icon: Icons.send,
                    onPressed: _handleSubmit,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.onBack,
                      child: const Text('Cancel', style: TextStyle(color: AgroColors.textMuted)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
