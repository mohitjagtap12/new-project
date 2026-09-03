import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../widgets/primary_button.dart';

class SellFarmWasteScreen extends StatefulWidget {
  final VoidCallback onWastePosted;

  const SellFarmWasteScreen({
    Key? key,
    required this.onWastePosted,
  }) : super(key: key);

  @override
  State<SellFarmWasteScreen> createState() => _SellFarmWasteScreenState();
}

class _SellFarmWasteScreenState extends State<SellFarmWasteScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedWasteType = 'Wheat Straw';
  final _quantityController = TextEditingController(text: '1000');
  String _unit = 'kg';
  final _priceController = TextEditingController(text: '4');
  final _locationController = TextEditingController(text: 'Pune');
  final _descriptionController = TextEditingController(text: 'Dry clean baled wheat straw ready for pickup.');

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      AppUtils.showSnackBar(context, 'Farm waste posted for sale successfully');
      widget.onWastePosted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Farm Waste'),
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
                  color: const Color(0xFFEFEBE9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.brown.shade700,
                      child: const Icon(Icons.recycling, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sell Farm Waste',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sell farm waste and earn extra money.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF5D4037)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Educational Banner: Farm waste uses
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
                        Icon(Icons.lightbulb_outline, size: 18, color: AgroColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Farm waste can be used for:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _WasteUseChip(label: 'Animal Feed'),
                        _WasteUseChip(label: 'Compost'),
                        _WasteUseChip(label: 'Biogas'),
                        _WasteUseChip(label: 'Fuel'),
                        _WasteUseChip(label: 'Mulching'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Waste Type Selection
              const Text('Waste Type *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedWasteType,
                items: AppConstants.wasteTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => _selectedWasteType = val ?? 'Wheat Straw'),
                decoration: const InputDecoration(),
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
                          decoration: const InputDecoration(hintText: 'e.g. 1000'),
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
                          value: _unit,
                          items: ['kg', 'quintal', 'ton', 'bales'].map((u) {
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
                decoration: const InputDecoration(
                  hintText: 'e.g. 4',
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AgroColors.textDark),
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
                  hintText: 'e.g. Pune, Hadapsar',
                  prefixIcon: Icon(Icons.location_on, size: 20),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter location.' : null,
              ),
              const SizedBox(height: 16),

              // Description
              const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Moisture level, packaging, loader availability...'),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                label: 'Post for Sale',
                icon: Icons.check,
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

class _WasteUseChip extends StatelessWidget {
  final String label;

  const _WasteUseChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AgroColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.primaryDark),
      ),
    );
  }
}
