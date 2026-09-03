import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/primary_button.dart';

class SellCropScreen extends StatefulWidget {
  final Function(CropSale) onPostSale;
  final VoidCallback onViewMySales;

  const SellCropScreen({
    Key? key,
    required this.onPostSale,
    required this.onViewMySales,
  }) : super(key: key);

  @override
  State<SellCropScreen> createState() => _SellCropScreenState();
}

class _SellCropScreenState extends State<SellCropScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cropNameController = TextEditingController(text: 'Tomato');
  final _quantityController = TextEditingController(text: '500');
  String _unit = 'kg';
  final _priceController = TextEditingController(text: '25');
  final _locationController = TextEditingController(text: 'Pune');
  final _descController = TextEditingController(text: 'Fresh harvest, grade-A ripe tomatoes.');
  String _photoUrl = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final sale = CropSale(
        id: 'cs_${DateTime.now().millisecondsSinceEpoch}',
        cropName: _cropNameController.text.trim(),
        quantity: _quantityController.text.trim(),
        unit: _unit,
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        location: _locationController.text.trim(),
        image: _photoUrl,
        description: _descController.text.trim(),
        status: 'Available',
        postedDate: 'Today',
      );

      widget.onPostSale(sale);
      AppUtils.showSnackBar(context, 'Crop posted for sale successfully');
      widget.onViewMySales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Crop'),
        actions: [
          TextButton.icon(
            onPressed: widget.onViewMySales,
            icon: const Icon(Icons.list_alt, color: AgroColors.primary),
            label: const Text('My Sales', style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
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
              // Intro Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AgroColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.storefront, color: AgroColors.primary, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sell your crop directly to buyers and food processing companies.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Crop Name
              const Text('Crop Name *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _cropNameController,
                decoration: const InputDecoration(hintText: 'e.g. Tomato, Wheat, Onion'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter crop name.' : null,
              ),
              const SizedBox(height: 16),

              // Quantity & Unit
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quantity *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'e.g. 500'),
                          validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter quantity.' : null,
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
                        const Text('Unit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _unit,
                          items: ['kg', 'quintal', 'ton', 'crate'].map((u) {
                            return DropdownMenuItem(value: u, child: Text(u));
                          }).toList(),
                          onChanged: (val) => setState(() => _unit = val ?? 'kg'),
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              const Text('Price (₹ per unit) *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 25',
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AgroColors.textDark),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter price.' : null,
              ),
              const SizedBox(height: 16),

              // Location
              const Text('Location *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Pune, Baramati',
                  prefixIcon: Icon(Icons.location_on, size: 20),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter location.' : null,
              ),
              const SizedBox(height: 16),

              // Description
              const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Condition of crop, harvest date, packaging details...'),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                label: 'Post for Sale',
                icon: Icons.check,
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
