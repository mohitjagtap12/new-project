import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/primary_button.dart';

class SellCropScreen extends StatefulWidget {
  final Crop? initialCrop;
  final CropSale? saleToEdit;
  final List<Crop> availableCrops;
  final Function(CropSale) onPostSale;
  final Function(CropSale)? onUpdateSale;
  final VoidCallback onViewMySales;
  final VoidCallback? onBack;

  const SellCropScreen({
    Key? key,
    this.initialCrop,
    this.saleToEdit,
    this.availableCrops = const [],
    required this.onPostSale,
    this.onUpdateSale,
    required this.onViewMySales,
    this.onBack,
  }) : super(key: key);

  @override
  State<SellCropScreen> createState() => _SellCropScreenState();
}

class _SellCropScreenState extends State<SellCropScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCropId;
  late TextEditingController _cropNameController;
  late TextEditingController _varietyController;
  late TextEditingController _quantityController;
  late String _quantityUnit;
  late TextEditingController _priceController;
  late String _priceUnit;
  late TextEditingController _harvestDateController;
  late TextEditingController _locationController;
  late TextEditingController _descController;
  late String _selectedImageUrl;

  final List<Map<String, String>> _sampleImages = [
    {
      'name': 'Tomato',
      'url': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Wheat',
      'url': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Onion',
      'url': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Sugarcane',
      'url': 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Maize',
      'url': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Cotton',
      'url': 'https://images.unsplash.com/photo-1606041008023-472dfb5e530f?w=600&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Soybean',
      'url': 'https://images.unsplash.com/photo-1599940824399-b87987ceb72a?w=600&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();

    final edit = widget.saleToEdit;
    final initCrop = widget.initialCrop;

    if (edit != null) {
      _selectedCropId = edit.cropId;
      _cropNameController = TextEditingController(text: edit.cropName);
      _varietyController = TextEditingController(text: edit.variety);
      _quantityController = TextEditingController(text: edit.quantity);
      _quantityUnit = edit.unit.isNotEmpty ? edit.unit : 'kg';
      _priceController = TextEditingController(
        text: edit.price > 0 ? edit.price.toStringAsFixed(0) : '',
      );
      _priceUnit = edit.priceUnit.isNotEmpty ? edit.priceUnit : '₹/$_quantityUnit';
      _harvestDateController = TextEditingController(text: edit.availableDate);
      _locationController = TextEditingController(text: edit.location);
      _descController = TextEditingController(text: edit.description);
      _selectedImageUrl = edit.image.isNotEmpty
          ? edit.image
          : _sampleImages[0]['url']!;
    } else if (initCrop != null) {
      _selectedCropId = initCrop.id;
      _cropNameController = TextEditingController(text: initCrop.name);
      _varietyController = TextEditingController(text: initCrop.variety);
      _quantityController = TextEditingController(text: '');
      _quantityUnit = 'quintal';
      _priceController = TextEditingController(text: '');
      _priceUnit = '₹/quintal';
      _harvestDateController = TextEditingController(text: initCrop.expectedHarvest);
      _locationController = TextEditingController(text: initCrop.location);
      _descController = TextEditingController(
        text: 'Farm-fresh harvest of ${initCrop.name} (${initCrop.variety}). Good quality.',
      );
      _selectedImageUrl = initCrop.image.isNotEmpty
          ? initCrop.image
          : _sampleImages[0]['url']!;
    } else {
      _selectedCropId = null;
      _cropNameController = TextEditingController();
      _varietyController = TextEditingController();
      _quantityController = TextEditingController();
      _quantityUnit = 'quintal';
      _priceController = TextEditingController();
      _priceUnit = '₹/quintal';
      _harvestDateController = TextEditingController(text: '15 Sep 2026');
      _locationController = TextEditingController(text: 'Baramati, Pune');
      _descController = TextEditingController();
      _selectedImageUrl = _sampleImages[0]['url']!;
    }
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _varietyController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _harvestDateController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onCropSelected(String? cropId) {
    setState(() {
      _selectedCropId = cropId;
      if (cropId != null && cropId != 'custom') {
        final crop = widget.availableCrops.firstWhere(
          (c) => c.id == cropId,
          orElse: () => widget.availableCrops.first,
        );
        _cropNameController.text = crop.name;
        _varietyController.text = crop.variety;
        if (crop.expectedHarvest.isNotEmpty) {
          _harvestDateController.text = crop.expectedHarvest;
        }
        if (crop.location.isNotEmpty) {
          _locationController.text = crop.location;
        }
        if (crop.image.isNotEmpty) {
          _selectedImageUrl = crop.image;
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AgroColors.primary,
              onPrimary: Colors.white,
              onSurface: AgroColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final formatted = '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]} ${picked.year}';
      setState(() {
        _harvestDateController.text = formatted;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final isEditing = widget.saleToEdit != null;

      final sale = CropSale(
        id: isEditing
            ? widget.saleToEdit!.id
            : 'cs_${DateTime.now().millisecondsSinceEpoch}',
        cropId: _selectedCropId != 'custom' ? _selectedCropId : null,
        cropName: _cropNameController.text.trim(),
        variety: _varietyController.text.trim(),
        quantity: _quantityController.text.trim(),
        unit: _quantityUnit,
        price: parsedPrice,
        priceUnit: _priceUnit,
        availableDate: _harvestDateController.text.trim(),
        location: _locationController.text.trim(),
        image: _selectedImageUrl,
        description: _descController.text.trim(),
        status: isEditing ? widget.saleToEdit!.status : 'Active',
        postedDate: isEditing ? widget.saleToEdit!.postedDate : 'Today',
      );

      if (isEditing && widget.onUpdateSale != null) {
        widget.onUpdateSale!(sale);
        AppUtils.showSnackBar(context, 'Crop sale listing updated successfully');
      } else {
        widget.onPostSale(sale);
        AppUtils.showSnackBar(context, 'Crop sale listing created successfully');
      }

      widget.onViewMySales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.saleToEdit != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Crop Sale' : 'Sell Crop'),
            leading: widget.onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  )
                : null,
            actions: [
              TextButton.icon(
                onPressed: widget.onViewMySales,
                icon: const Icon(Icons.list_alt, color: AgroColors.primary),
                label: const Text(
                  'My Sales',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
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
                      // Header Banner
                      _buildHeaderBanner(isEditing),
                      const SizedBox(height: 20),

                      // Card: Crop Selection & Details
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AgroColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Crop Information',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Select from your registered crops or enter details manually.',
                                style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
                              ),
                              const SizedBox(height: 16),

                              // Select Crop Dropdown (if crops available)
                              if (widget.availableCrops.isNotEmpty) ...[
                                const Text(
                                  'Select Registered Crop',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedCropId,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.eco, color: AgroColors.primary),
                                    hintText: 'Select a crop from your farm',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: 'custom',
                                      child: Text('Custom / Other Crop (manual entry)'),
                                    ),
                                    ...widget.availableCrops.map((c) => DropdownMenuItem<String>(
                                          value: c.id,
                                          child: Text('${c.name} (${c.variety}) - ${c.displayArea}'),
                                        )),
                                  ],
                                  onChanged: _onCropSelected,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Crop Name & Variety Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Crop Name *',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _cropNameController,
                                          decoration: InputDecoration(
                                            hintText: 'e.g. Tomato, Wheat, Onion',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          validator: (val) {
                                            if (val == null || val.trim().isEmpty) {
                                              return 'Please enter crop name.';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Crop Variety',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _varietyController,
                                          decoration: InputDecoration(
                                            hintText: 'e.g. Abhinav F1, Sharbati',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card: Quantity & Price
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AgroColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quantity & Pricing',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Available Quantity and Quantity Unit
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Available Quantity *',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _quantityController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            hintText: 'e.g. 500',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          validator: (val) {
                                            if (val == null || val.trim().isEmpty) {
                                              return 'Please enter quantity.';
                                            }
                                            final num = double.tryParse(val.trim());
                                            if (num == null || num <= 0) {
                                              return 'Quantity must be positive.';
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
                                        const Text(
                                          'Quantity Unit *',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          value: _quantityUnit,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: 'kg', child: Text('kg')),
                                            DropdownMenuItem(value: 'quintal', child: Text('quintal')),
                                            DropdownMenuItem(value: 'ton', child: Text('ton')),
                                          ],
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                _quantityUnit = val;
                                                _priceUnit = '₹/$val';
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Expected Price and Price Unit
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Expected Price *',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _priceController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            hintText: 'e.g. 25 or 2500',
                                            prefixText: '₹ ',
                                            prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          validator: (val) {
                                            if (val == null || val.trim().isEmpty) {
                                              return 'Please enter price.';
                                            }
                                            final num = double.tryParse(val.trim());
                                            if (num == null || num <= 0) {
                                              return 'Price must be positive.';
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
                                        const Text(
                                          'Price Unit',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                        ),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          value: _priceUnit,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: '₹/kg', child: Text('₹ / kg')),
                                            DropdownMenuItem(value: '₹/quintal', child: Text('₹ / quintal')),
                                            DropdownMenuItem(value: '₹/ton', child: Text('₹ / ton')),
                                          ],
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() => _priceUnit = val);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card: Harvest Date & Location
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AgroColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Harvest Schedule & Location',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Expected / Available Harvest Date
                              const Text(
                                'Expected / Available Harvest Date *',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _harvestDateController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 15 Sep 2026',
                                  prefixIcon: const Icon(Icons.calendar_today, color: AgroColors.primary),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.edit_calendar, color: AgroColors.primary),
                                    onPressed: () => _selectDate(context),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Please enter or select harvest date.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Village / Location
                              const Text(
                                'Village / Location *',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. Baramati, Pune, Maharashtra',
                                  prefixIcon: const Icon(Icons.location_on, color: AgroColors.primary),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Please enter village or market location.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Description / Notes
                              const Text(
                                'Description / Quality Notes',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _descController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Mention crop condition, sorting grade, packaging, moisture levels...',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card: Crop Photo Selection
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AgroColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Crop Image',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Select a photo representative of your harvest quality.',
                                style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
                              ),
                              const SizedBox(height: 16),

                              // Active Image Preview
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _selectedImageUrl,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 160,
                                    color: AgroColors.primaryContainer,
                                    child: const Center(
                                      child: Icon(Icons.eco, size: 48, color: AgroColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              const Text(
                                'Choose from harvest presets:',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _sampleImages.map((sample) {
                                    final isSelected = _selectedImageUrl == sample['url'];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedImageUrl = sample['url']!);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected ? AgroColors.primary : Colors.transparent,
                                            width: 2.5,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(7),
                                              child: Image.network(
                                                sample['url']!,
                                                width: 60,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              sample['name']!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected ? AgroColors.primaryDark : AgroColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      PrimaryButton(
                        label: isEditing ? 'Update Sale Listing' : 'Post for Sale',
                        icon: isEditing ? Icons.save : Icons.check_circle,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: widget.onBack ?? widget.onViewMySales,
                          child: const Text('Cancel and Return', style: TextStyle(color: AgroColors.textMuted)),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildHeaderBanner(bool isEditing) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AgroColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isEditing ? Icons.edit_note : Icons.storefront,
              color: AgroColors.primaryDark,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Update Farm Sale Listing' : 'Direct Farm-to-Buyer Listing',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AgroColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEditing
                      ? 'Make changes to quantity, price, or delivery details.'
                      : 'Reach registered regional mandis, retail buyers, and food processors with zero middleman commissions.',
                  style: const TextStyle(fontSize: 12, color: AgroColors.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
