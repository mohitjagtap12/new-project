import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/mock/mock_farm_waste.dart';
import '../../../models/farm_waste.dart';
import '../../../widgets/primary_button.dart';

class SellFarmWasteScreen extends StatefulWidget {
  final FarmWaste? wasteToEdit;
  final Function(FarmWaste waste) onWasteSaved;
  final VoidCallback? onCancel;
  final VoidCallback? onViewMyListings;

  const SellFarmWasteScreen({
    Key? key,
    this.wasteToEdit,
    required this.onWasteSaved,
    this.onCancel,
    this.onViewMyListings,
  }) : super(key: key);

  @override
  State<SellFarmWasteScreen> createState() => _SellFarmWasteScreenState();
}

class _SellFarmWasteScreenState extends State<SellFarmWasteScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedWasteType;
  late TextEditingController _quantityController;
  late String _quantityUnit;
  late TextEditingController _priceController;
  late String _priceUnit;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late DateTime _availableDate;
  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    final item = widget.wasteToEdit;

    if (item != null) {
      _selectedWasteType = item.wasteType;
      _quantityController = TextEditingController(text: item.quantity);
      _quantityUnit = item.quantityUnit;
      _priceController = TextEditingController(text: item.price.toStringAsFixed(0));
      _priceUnit = item.priceUnit;
      _locationController = TextEditingController(text: item.location);
      _descriptionController = TextEditingController(text: item.description);
      _selectedImage = item.image;
      _availableDate = DateTime.now().add(const Duration(days: 3));
    } else {
      _selectedWasteType = 'Wheat Straw';
      _quantityController = TextEditingController(text: '10');
      _quantityUnit = 'ton';
      _priceController = TextEditingController(text: '3000');
      _priceUnit = '₹/ton';
      _locationController = TextEditingController(text: 'Baramati, Pune');
      _descriptionController = TextEditingController(
        text: 'Sun-dried clean golden wheat straw. Packed into bales, ready for loading at farm gate.',
      );
      _availableDate = DateTime.now().add(const Duration(days: 3));
      _selectedImage = MockFarmWaste.wastePresetImages['Wheat Straw']!;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onWasteTypeChanged(String? val) {
    if (val == null) return;
    setState(() {
      _selectedWasteType = val;
      _selectedImage = MockFarmWaste.getImageForWasteType(val);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _availableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
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
      setState(() => _availableDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  double get _estimatedTotal {
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    if (_priceUnit == 'Total ₹') {
      return price;
    }
    return qty * price;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final isEdit = widget.wasteToEdit != null;
      final quantityText = _quantityController.text.trim();
      final priceVal = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final locationText = _locationController.text.trim();
      final descText = _descriptionController.text.trim();

      final updatedWaste = FarmWaste(
        id: isEdit ? widget.wasteToEdit!.id : 'fw_${DateTime.now().millisecondsSinceEpoch}',
        sellerId: isEdit ? widget.wasteToEdit!.sellerId : 'current_farmer',
        sellerName: isEdit ? widget.wasteToEdit!.sellerName : 'Suresh Patil',
        sellerPhone: isEdit ? widget.wasteToEdit!.sellerPhone : '+91 98220 12345',
        wasteType: _selectedWasteType,
        quantity: quantityText,
        quantityUnit: _quantityUnit,
        price: priceVal,
        priceUnit: _priceUnit,
        location: locationText,
        availableDate: _formatDate(_availableDate),
        description: descText.isNotEmpty ? descText : 'Available agricultural residue, dry and ready for transport.',
        image: _selectedImage,
        status: isEdit ? widget.wasteToEdit!.status : 'Active',
        postedDate: isEdit ? widget.wasteToEdit!.postedDate : _formatDate(DateTime.now()),
        recommendedUses: isEdit
            ? widget.wasteToEdit!.recommendedUses
            : ['Compost', 'Animal Feed', 'Biofuel Briquettes', 'Mulching'],
      );

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: AgroColors.primary, size: 28),
              SizedBox(width: 10),
              Text('Listing Saved!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit
                    ? 'Your waste listing for $_selectedWasteType has been updated successfully.'
                    : 'Your waste listing for $_selectedWasteType has been posted to the marketplace.',
                style: const TextStyle(fontSize: 14, color: AgroColors.textDark),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AgroColors.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Est. Value:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      '₹${_estimatedTotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onWasteSaved(updatedWaste);
              },
              child: const Text('Go to My Listings', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.wasteToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Waste Listing' : 'Sell Farm Waste'),
        leading: widget.onCancel != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onCancel,
              )
            : null,
        actions: [
          if (widget.onViewMyListings != null)
            TextButton.icon(
              onPressed: widget.onViewMyListings,
              icon: const Icon(Icons.list_alt, size: 18),
              label: const Text('My Listings', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown.shade700,
                      Colors.brown.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.recycling, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Update Waste Listing' : 'Sell Farm Waste & Earn Extra',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Turn crop residue into revenue. Zero burning, cleaner air & extra farmer income.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD7CCC8),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Educational Banner: What waste can be sold
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AgroColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.eco, size: 18, color: AgroColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Common Uses & Buyers:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: const [
                        _UseTag(label: 'Dairy Cattle Fodder'),
                        _UseTag(label: 'Biomass Power Plants'),
                        _UseTag(label: 'Mushroom Farming'),
                        _UseTag(label: 'Soil Mulching'),
                        _UseTag(label: 'Compost & Bio-gas'),
                        _UseTag(label: 'Packaging & Paper'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Image Preview & Preset Selection
              const Text(
                'Listing Photo *',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _selectedImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        width: double.infinity,
                        color: Colors.brown.shade50,
                        child: Icon(Icons.recycling, size: 48, color: Colors.brown.shade300),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.photo_library, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Preset Photo',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Waste Type Selection
              const Text(
                'Agricultural Waste Type *',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedWasteType,
                items: const [
                  DropdownMenuItem(value: 'Wheat Straw', child: Text('Wheat Straw (गव्हाचा पेंढा)')),
                  DropdownMenuItem(value: 'Rice Straw', child: Text('Rice Straw (तांदळाचा पेंढा)')),
                  DropdownMenuItem(value: 'Sugarcane Trash', child: Text('Sugarcane Trash (उसाची पाचट)')),
                  DropdownMenuItem(value: 'Maize Stalks', child: Text('Maize Stalks (मक्याचे देठ)')),
                  DropdownMenuItem(value: 'Cotton Stalks', child: Text('Cotton Stalks (कापसाचे देठ)')),
                  DropdownMenuItem(value: 'Coconut Shell/Husk Waste', child: Text('Coconut Shell/Husk Waste (नारळाचे करवंटे/कचरा)')),
                  DropdownMenuItem(value: 'Other', child: Text('Other Agricultural Biomass (इतर)')),
                ],
                onChanged: _onWasteTypeChanged,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.grass, color: AgroColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Quantity & Unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quantity *',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'e.g. 10',
                            prefixIcon: Icon(Icons.scale, size: 20),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter quantity';
                            final parsed = double.tryParse(val.trim());
                            if (parsed == null || parsed <= 0) return 'Must be a positive number';
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
                          'Unit *',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _quantityUnit,
                          items: const [
                            DropdownMenuItem(value: 'ton', child: Text('Ton')),
                            DropdownMenuItem(value: 'quintal', child: Text('Quintal')),
                            DropdownMenuItem(value: 'kg', child: Text('kg')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _quantityUnit = val;
                                if (_priceUnit != 'Total ₹') {
                                  _priceUnit = '₹/$val';
                                }
                              });
                            }
                          },
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price & Price Unit
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
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'e.g. 3000',
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AgroColors.textDark),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter expected price';
                            final parsed = double.tryParse(val.trim());
                            if (parsed == null || parsed <= 0) return 'Must be a positive number';
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
                          'Price Unit *',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _priceUnit,
                          items: [
                            DropdownMenuItem(value: '₹/$_quantityUnit', child: Text('₹/$_quantityUnit')),
                            const DropdownMenuItem(value: '₹/ton', child: Text('₹/ton')),
                            const DropdownMenuItem(value: '₹/quintal', child: Text('₹/quintal')),
                            const DropdownMenuItem(value: '₹/kg', child: Text('₹/kg')),
                            const DropdownMenuItem(value: 'Total ₹', child: Text('Total ₹')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _priceUnit = val);
                          },
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Dynamic Calculation Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AgroColors.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AgroColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calculate_outlined, size: 20, color: AgroColors.primaryDark),
                        SizedBox(width: 8),
                        Text(
                          'Estimated Total Revenue:',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AgroColors.textDark),
                        ),
                      ],
                    ),
                    Text(
                      '₹${_estimatedTotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Available Date
              const Text(
                'Available From Date *',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AgroColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AgroColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_availableDate),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AgroColors.textDark),
                      ),
                      const Spacer(),
                      const Text('Change', style: TextStyle(color: AgroColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Village / Location
              const Text(
                'Village / Farm Location *',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Baramati, Pune',
                  prefixIcon: Icon(Icons.location_on, color: AgroColors.primary, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please specify farm location';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Description / Pickup Notes',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Mention moisture level, packaging (bales / loose), trailer access, labor help...',
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              PrimaryButton(
                label: isEdit ? 'Update Waste Listing' : 'Post Waste for Sale',
                icon: isEdit ? Icons.check : Icons.add_circle_outline,
                color: Colors.brown.shade700,
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

class _UseTag extends StatelessWidget {
  final String label;

  const _UseTag({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEBE9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.brown.shade800),
      ),
    );
  }
}
