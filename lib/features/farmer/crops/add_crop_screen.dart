import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/primary_button.dart';

class AddCropScreen extends StatefulWidget {
  final Crop? cropToEdit;
  final Function(Crop) onSave;
  final VoidCallback? onCancel;

  const AddCropScreen({
    Key? key,
    this.cropToEdit,
    required this.onSave,
    this.onCancel,
  }) : super(key: key);

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _varietyController;
  late TextEditingController _areaController;
  late TextEditingController _locationController;
  late TextEditingController _plantingDateController;
  late TextEditingController _expectedHarvestController;
  late TextEditingController _notesController;

  String _selectedUnit = 'Acres';
  String _selectedStatus = 'Growing';
  String _photoUrl = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';

  DateTime? _selectedPlantingDate;
  DateTime? _selectedHarvestDate;

  // Preset sample crops with curated agricultural images
  final List<Map<String, String>> _presetCrops = [
    {
      'name': 'Tomato',
      'variety': 'Abhinav F1 Hybrid',
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Wheat',
      'variety': 'Sharbati HD-2967',
      'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Onion',
      'variety': 'Nasik Red (Fursungi)',
      'image': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Sugarcane',
      'variety': 'Co-86032 (Nira)',
      'image': 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Cotton',
      'variety': 'Bt Cotton RCH-2',
      'image': 'https://images.unsplash.com/photo-1594897030560-69296561f36a?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Soybean',
      'variety': 'JS-335 Yellow',
      'image': 'https://images.unsplash.com/photo-1599420186946-7b6fb4e297f0?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Maize',
      'variety': 'Pioneer P3396',
      'image': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Rice',
      'variety': 'Basmati 1121',
      'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80',
    },
  ];

  final List<String> _unitOptions = ['Acres', 'Guntha', 'Hectares', 'Bigha'];
  final List<String> _statusOptions = ['Growing', 'Ready for Harvest', 'Harvested'];

  @override
  void initState() {
    super.initState();
    final c = widget.cropToEdit;
    _nameController = TextEditingController(text: c?.name ?? '');
    _varietyController = TextEditingController(text: c?.variety ?? '');
    
    // Extract numeric part if area was formatted like "2 acres"
    String initialArea = c?.area ?? '';
    if (c != null) {
      final parts = c.area.split(' ');
      if (parts.isNotEmpty) {
        initialArea = parts[0];
      }
    }
    _areaController = TextEditingController(text: initialArea);
    _selectedUnit = c?.unit ?? 'Acres';
    _locationController = TextEditingController(text: c?.location ?? 'Baramati, Pune');
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
    _locationController.dispose();
    _plantingDateController.dispose();
    _expectedHarvestController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickPlantingDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedPlantingDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AgroColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AgroColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedPlantingDate = picked;
        _plantingDateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _pickHarvestDate() async {
    final now = DateTime.now();
    final initialDate = _selectedHarvestDate ?? (_selectedPlantingDate != null ? _selectedPlantingDate!.add(const Duration(days: 90)) : now.add(const Duration(days: 90)));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _selectedPlantingDate ?? DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AgroColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AgroColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedHarvestDate = picked;
        _expectedHarvestController.text = _formatDate(picked);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final areaStr = _areaController.text.trim();
      final isEditing = widget.cropToEdit != null;

      final crop = Crop(
        id: widget.cropToEdit?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        variety: _varietyController.text.trim().isEmpty ? 'Local Standard' : _varietyController.text.trim(),
        area: '$areaStr $_selectedUnit',
        unit: _selectedUnit,
        location: _locationController.text.trim().isEmpty ? 'Pune, Maharashtra' : _locationController.text.trim(),
        plantingDate: _plantingDateController.text.trim(),
        expectedHarvest: _expectedHarvestController.text.trim(),
        status: _selectedStatus,
        image: _photoUrl,
        notes: _notesController.text.trim(),
      );

      widget.onSave(crop);
      AppUtils.showSnackBar(
        context,
        isEditing ? 'Crop details updated successfully' : 'Crop "${crop.name}" registered successfully',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cropToEdit != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: isDesktop ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AgroColors.primaryContainer,
                              child: Icon(
                                isEditing ? Icons.edit_note : Icons.add_circle_outline,
                                color: AgroColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEditing ? 'Edit Crop Details' : 'Record New Crop',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AgroColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isEditing
                                        ? 'Update variety, acreage, timelines or status'
                                        : 'Add your crop to track growth stages and yields',
                                    style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.onCancel != null)
                              IconButton(
                                icon: const Icon(Icons.close, color: AgroColors.textMuted),
                                tooltip: 'Cancel and return',
                                onPressed: widget.onCancel,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 1: Photo & Image Selection
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Crop Photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Select a crop preset or photo preview',
                              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _photoUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) => Container(
                                      width: 90,
                                      height: 90,
                                      color: AgroColors.primaryContainer,
                                      child: const Icon(Icons.agriculture, size: 40, color: AgroColors.primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _nameController.text.isEmpty ? 'Selected Crop Photo' : _nameController.text,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AgroColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Tap a crop icon below to quickly set photo & default variety',
                                        style: TextStyle(fontSize: 12, color: AgroColors.textLight),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Preset Crop Chips
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _presetCrops.map((preset) {
                                  final isPresetSelected = _photoUrl == preset['image'];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _photoUrl = preset['image']!;
                                          if (_nameController.text.isEmpty) {
                                            _nameController.text = preset['name']!;
                                          }
                                          if (_varietyController.text.isEmpty) {
                                            _varietyController.text = preset['variety']!;
                                          }
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isPresetSelected ? AgroColors.primaryContainer : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isPresetSelected ? AgroColors.primary : Colors.grey.shade300,
                                            width: isPresetSelected ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                preset['image']!,
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              preset['name']!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: isPresetSelected ? FontWeight.bold : FontWeight.w500,
                                                color: isPresetSelected ? AgroColors.primaryDark : AgroColors.textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Crop Details Form
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'General Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Crop Name
                            const Text('Crop Name *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Tomato, Wheat, Onion, Sugarcane',
                                prefixIcon: Icon(Icons.eco_outlined, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter crop name.';
                                }
                                if (val.trim().length < 2) {
                                  return 'Crop name must be at least 2 characters.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Crop Variety
                            const Text('Crop Variety *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _varietyController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Abhinav F1, Sharbati HD-2967, Nasik Red',
                                prefixIcon: Icon(Icons.grain_outlined, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter crop variety.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Land Area & Unit Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Land / Area *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _areaController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(
                                          hintText: 'e.g. 2.5',
                                          prefixIcon: Icon(Icons.square_foot, size: 20),
                                        ),
                                        validator: (val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return 'Enter land size.';
                                          }
                                          final numVal = double.tryParse(val.trim());
                                          if (numVal == null || numVal <= 0) {
                                            return 'Enter a valid positive number.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Unit *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        initialValue: _selectedUnit,
                                        items: _unitOptions.map((unit) {
                                          return DropdownMenuItem(value: unit, child: Text(unit));
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) setState(() => _selectedUnit = val);
                                        },
                                        decoration: const InputDecoration(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Location / Village
                            const Text('Location / Village *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Baramati, Pune / Sangli',
                                prefixIcon: Icon(Icons.place_outlined, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter location or village name.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Timeline & Dates
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dates & Timeline',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Planting Date
                            const Text('Planting Date *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _plantingDateController,
                              readOnly: true,
                              onTap: _pickPlantingDate,
                              decoration: InputDecoration(
                                hintText: 'Select planting date',
                                prefixIcon: const Icon(Icons.calendar_today, size: 20),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.event, color: AgroColors.primary),
                                  onPressed: _pickPlantingDate,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please choose planting date.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Expected Harvest Date
                            const Text('Expected Harvest Date *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _expectedHarvestController,
                              readOnly: true,
                              onTap: _pickHarvestDate,
                              decoration: InputDecoration(
                                hintText: 'Select expected harvest date',
                                prefixIcon: const Icon(Icons.event_available, size: 20),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.event, color: AgroColors.primary),
                                  onPressed: _pickHarvestDate,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please choose expected harvest date.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Status Dropdown
                            const Text('Crop Status *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(value: status, child: Text(status));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedStatus = val);
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.timelapse, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 4: Notes
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgroColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Additional Notes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Record irrigation method, soil treatment, or fertilizer schedule',
                              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Drip irrigation installed; Applied bio-fertilizer and vermicompost.',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons
                      Row(
                        children: [
                          if (widget.onCancel != null) ...[
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: widget.onCancel,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: const BorderSide(color: AgroColors.border),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              label: isEditing ? 'Save Changes' : 'Save Crop',
                              icon: Icons.check_circle_outline,
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
