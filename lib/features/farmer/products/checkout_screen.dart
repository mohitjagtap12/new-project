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

  final _addressController = TextEditingController(text: 'Gat No. 234, Near Canal, Baramati Road, Pune, Maharashtra - 413102');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get subtotal => widget.cartItems.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + (widget.cartItems.isEmpty ? 0 : 50.0);

  void _submitOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        final firstItem = widget.cartItems.isNotEmpty ? widget.cartItems.first.product.name : 'Farm Inputs';
        final totalQty = '${widget.cartItems.length} items';

        final newOrder = AgroOrder(
          orderNumber: 'ORD-BUY-${1000 + DateTime.now().millisecond}',
          itemTitle: firstItem,
          category: 'Farm Product',
          quantity: totalQty,
          price: total,
          counterParty: widget.cartItems.isNotEmpty ? widget.cartItems.first.product.seller : 'Agro Store',
          address: _addressController.text.trim(),
          date: 'Today',
          status: 'Placed',
          isBuying: true,
        );

        widget.onOrderPlaced(newOrder);
        AppUtils.showSnackBar(context, 'Order placed successfully');
        Navigator.of(context).pop(); // pop checkout
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Section
              const Text('Delivery Address *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter complete farm or village delivery address',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.home_outlined),
                  ),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter delivery address.' : null,
              ),
              const SizedBox(height: 20),

              // Phone Number Section
              const Text('Phone Number *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'e.g. +91 98765 43210',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a valid phone number.' : null,
              ),
              const SizedBox(height: 24),

              // Items Ordered
              const Text('Items in Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AgroColors.border),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItems.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AgroColors.border),
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return ListTile(
                      title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Qty: ${item.quantity} × ₹${item.product.price.toStringAsFixed(0)}'),
                      trailing: Text('₹${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Payment method notice (Cash on Delivery / Direct Bank Settlement)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AgroColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.payment, color: AgroColors.primaryDark),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Payment Mode: Pay on Delivery (Cash or UPI at Farm Delivery)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Total Amount Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AgroColors.textDark)),
                  Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AgroColors.primary)),
                ],
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                label: 'Place Order',
                icon: Icons.check_circle,
                isLoading: _isSubmitting,
                onPressed: _submitOrder,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
