import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/primary_button.dart';

class AddCropScreen extends StatefulWidget {
  final Crop? cropToEdit;
  final Function(Crop) onSave;

  const AddCropScreen({
    Key? key,
    this.cropToEdit,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _varietyController;
  late TextEditingController _areaController;
  late TextEditingController _plantingDateController;
  late TextEditingController _expectedHarvestController;
  late TextEditingController _notesController;
  String _selectedStatus = 'Growing';
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    final c = widget.cropToEdit;
    _nameController = TextEditingController(text: c?.name ?? '');
    _varietyController = TextEditingController(text: c?.variety ?? '');
    _areaController = TextEditingController(text: c?.area ?? '');
    _plantingDateController = TextEditingController(text: c?.plantingDate ?? '10 June 2026');
    _expectedHarvestController = TextEditingController(text: c?.expectedHarvest ?? '15 September 2026');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _selectedStatus = c?.status ?? 'Growing';
    _photoUrl = c?.image ?? 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _areaController.dispose();
    _plantingDateController.dispose();
    _expectedHarvestController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final crop = Crop(
        id: widget.cropToEdit?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        variety: _varietyController.text.trim(),
        area: _areaController.text.trim(),
        plantingDate: _plantingDateController.text.trim(),
        expectedHarvest: _expectedHarvestController.text.trim(),
        status: _selectedStatus,
        image: _photoUrl,
        notes: _notesController.text.trim(),
      );

      widget.onSave(crop);
      AppUtils.showSnackBar(context, 'Crop added successfully');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cropToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Crop' : 'Add Crop'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Photo Preview / Selection
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _photoUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 120,
                          height: 120,
                          color: AgroColors.primaryContainer,
                          child: const Icon(Icons.agriculture, size: 50, color: AgroColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          // Toggle sample agricultural crop photos
                          _photoUrl = _photoUrl.contains('tomato')
                              ? 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80'
                              : 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';
                        });
                      },
                      icon: const Icon(Icons.photo_camera, size: 18),
                      label: const Text('Change Crop Photo'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Crop Name
              const Text('Crop Name *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'e.g. Tomato, Wheat, Onion'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter crop name.' : null,
              ),
              const SizedBox(height: 16),

              // Variety
              const Text('Variety', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _varietyController,
                decoration: const InputDecoration(hintText: 'e.g. Abhinav F1, Sharbati HD-2967'),
              ),
              const SizedBox(height: 16),

              // Farm Area
              const Text('Farm Area *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(hintText: 'e.g. 2 acres, 1.5 hectares'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter farm area.' : null,
              ),
              const SizedBox(height: 16),

              // Planting Date
              const Text('Planting Date *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _plantingDateController,
                decoration: const InputDecoration(
                  hintText: 'e.g. 10 June 2026',
                  prefixIcon: Icon(Icons.calendar_today, size: 20),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please select a date.' : null,
              ),
              const SizedBox(height: 16),

              // Expected Harvest
              const Text('Expected Harvest *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _expectedHarvestController,
                decoration: const InputDecoration(
                  hintText: 'e.g. 15 September 2026',
                  prefixIcon: Icon(Icons.event_available, size: 20),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please select a date.' : null,
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              const Text('Current Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: ['Growing', 'Ready for Harvest', 'Harvested'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (val) => setState(() => _selectedStatus = val ?? 'Growing'),
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),

              // Notes
              const Text('Notes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Irrigation method, fertilizers used, general notes...'),
              ),
              const SizedBox(height: 28),

              // Save Crop Button
              PrimaryButton(
                label: 'Save Crop',
                icon: Icons.check_circle_outline,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
