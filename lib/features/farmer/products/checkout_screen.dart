import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../widgets/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(AgroOrder) onOrderPlaced;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.onOrderPlaced,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _villageController;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _notesController;

  String _paymentMethod = 'Cash on Delivery';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Suresh Patil');
    _phoneController = TextEditingController(text: '9876543210');
    _addressController = TextEditingController(text: 'Gat No. 234, Near Canal, Baramati Road');
    _villageController = TextEditingController(text: 'Malegaon Khurd');
    _districtController = TextEditingController(text: 'Pune');
    _stateController = TextEditingController(text: 'Maharashtra');
    _pincodeController = TextEditingController(text: '413102');
    _notesController = TextEditingController(text: 'Deliver at farm gate, call on arrival.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get subtotal => widget.cartItems.fold(0, (sum, item) => sum + item.total);
  double get delivery => widget.cartItems.isEmpty ? 0 : (subtotal >= 2000 ? 0.0 : 50.0);
  double get discount => subtotal >= 3000 ? 100.0 : 0.0;
  double get total => (subtotal + delivery - discount).clamp(0.0, double.infinity);

  void _submitOrder() {
    if (widget.cartItems.isEmpty) {
      AppUtils.showSnackBar(context, 'Your cart is empty. Add products before checkout.');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      // Simulate order processing
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        final firstItem = widget.cartItems.isNotEmpty ? widget.cartItems.first.product.name : 'Farm Inputs';
        final totalUnits = widget.cartItems.fold(0, (sum, i) => sum + i.quantity);
        final fullAddress = '${_addressController.text.trim()}, ${_villageController.text.trim()}, ${_districtController.text.trim()}, ${_stateController.text.trim()} - ${_pincodeController.text.trim()}';

        final orderItems = widget.cartItems
            .map((c) => OrderItem(
                  productName: c.product.name,
                  quantity: c.quantity,
                  price: c.product.price,
                  image: c.product.image,
                  priceUnit: c.product.priceUnit,
                  quantityUnit: c.product.quantityUnit,
                  sellerName: c.product.seller,
                ))
            .toList();

        final newOrder = AgroOrder(
          orderNumber: 'ORD-BUY-${1000 + DateTime.now().millisecond}',
          itemTitle: firstItem,
          category: 'Farm Product',
          quantity: '${widget.cartItems.length} items ($totalUnits units)',
          price: total,
          subtotal: subtotal,
          deliveryCharge: delivery,
          discount: discount,
          counterParty: widget.cartItems.isNotEmpty ? widget.cartItems.first.product.seller : 'Agro Store',
          address: fullAddress,
          customerName: _nameController.text.trim(),
          mobileNumber: _phoneController.text.trim(),
          village: _villageController.text.trim(),
          district: _districtController.text.trim(),
          state: _stateController.text.trim(),
          pincode: _pincodeController.text.trim(),
          deliveryNotes: _notesController.text.trim(),
          paymentMethod: _paymentMethod,
          date: 'Today',
          status: 'Placed',
          isBuying: true,
          items: orderItems,
        );

        widget.onOrderPlaced(newOrder);
      });
    } else {
      AppUtils.showSnackBar(context, 'Please complete all required fields correctly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Form(
              key: _formKey,
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            ),
    );
  }

  // Desktop 2-Column Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Form & Payment (60%)
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressCard(),
                const SizedBox(height: 20),
                _buildPaymentCard(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right: Items & Order Summary (40%)
          Expanded(
            flex: 40,
            child: Column(
              children: [
                _buildItemsSummaryCard(),
                const SizedBox(height: 20),
                _buildPriceSummaryCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Single-Column Layout
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressCard(),
          const SizedBox(height: 18),
          _buildItemsSummaryCard(),
          const SizedBox(height: 18),
          _buildPaymentCard(),
          const SizedBox(height: 18),
          _buildPriceSummaryCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Address and Contact Information Card
  Widget _buildAddressCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_shipping_outlined, color: AgroColors.primary),
                SizedBox(width: 10),
                Text(
                  'Delivery Information',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name & Mobile Number
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Farmer / Customer Name *',
                hintText: 'e.g. Suresh Patil',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter farmer name.' : null,
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number *',
                hintText: '10-digit mobile number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter mobile number.';
                final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                if (clean.length < 10) return 'Please enter a valid 10-digit mobile number.';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Street / Farm Address
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Delivery Address / Farm Gate *',
                hintText: 'Plot/Gat No, Landmark, Road name',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Icon(Icons.home_outlined),
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter delivery address.' : null,
            ),
            const SizedBox(height: 14),

            // Village & District Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _villageController,
                    decoration: const InputDecoration(
                      labelText: 'Village *',
                      hintText: 'e.g. Malegaon Khurd',
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(
                      labelText: 'District *',
                      hintText: 'e.g. Pune',
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // State & PIN Code Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State *',
                      hintText: 'e.g. Maharashtra',
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'PIN Code *',
                      hintText: '6-digit PIN',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Required';
                      final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.length != 6) return 'Enter 6 digits';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Delivery Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Delivery Notes (Optional)',
                hintText: 'e.g. Call before delivery, drop at barn gate',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Payment Selection Card (Mock / Demo Only)
  Widget _buildPaymentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.payment_outlined, color: AgroColors.primary),
                SizedBox(width: 10),
                Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Select preferred payment mode. No real money will be charged.',
              style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
            ),
            const SizedBox(height: 14),

            // Cash on Delivery Option
            _buildPaymentOption(
              title: 'Cash on Delivery',
              subtitle: 'Pay with cash or UPI at the time of delivery at your farm.',
              icon: Icons.payments_outlined,
              value: 'Cash on Delivery',
            ),
            const SizedBox(height: 10),

            // Demo Online Payment Option
            _buildPaymentOption(
              title: 'Demo / Mock Online Payment',
              subtitle: 'Simulate instant UPI / Card payment (Test sandbox mode).',
              icon: Icons.qr_code_2_outlined,
              value: 'Demo Online Payment',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _paymentMethod == value;

    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AgroColors.primaryContainer.withOpacity(0.4) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AgroColors.primary : AgroColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AgroColors.primary : AgroColors.textMuted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _paymentMethod,
              activeColor: AgroColors.primary,
              onChanged: (val) {
                if (val != null) setState(() => _paymentMethod = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Ordered Items Summary Card
  Widget _buildItemsSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                Text(
                  '${widget.cartItems.length} products',
                  style: const TextStyle(fontSize: 12, color: AgroColors.textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.cartItems.length,
              separatorBuilder: (context, index) => const Divider(height: 16, color: AgroColors.border),
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.product.image,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 44,
                          height: 44,
                          color: AgroColors.primaryContainer,
                          child: const Icon(Icons.shopping_bag, size: 20, color: AgroColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Qty: ${item.quantity} × ₹${item.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item.total.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.primary),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Price Summary and Place Order Action
  Widget _buildPriceSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 14),

            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal', style: TextStyle(color: AgroColors.textMuted, fontSize: 14)),
                Text('₹${subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),

            // Delivery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Charge', style: TextStyle(color: AgroColors.textMuted, fontSize: 14)),
                Text(
                  delivery == 0 ? 'FREE' : '₹${delivery.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: delivery == 0 ? Colors.green : AgroColors.textDark,
                  ),
                ),
              ],
            ),

            // Discount
            if (discount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Volume Discount', style: TextStyle(color: Colors.green, fontSize: 14)),
                  Text('-₹${discount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
                ],
              ),
            ],

            const Divider(height: 24, color: AgroColors.border),

            // Final Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payable',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                ),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AgroColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            PrimaryButton(
              label: _paymentMethod == 'Cash on Delivery' ? 'Confirm & Place Order' : 'Simulate Payment & Order',
              icon: Icons.verified,
              isLoading: _isSubmitting,
              onPressed: _submitOrder,
            ),
          ],
        ),
      ),
    );
  }
}
