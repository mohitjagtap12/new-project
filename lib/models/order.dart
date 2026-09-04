class OrderItem {
  final String? productId;
  final String productName;
  final int quantity;
  final double price;
  final String image;
  final String priceUnit;
  final String quantityUnit;
  final String sellerName;

  OrderItem({
    this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.image = '',
    this.priceUnit = 'unit',
    this.quantityUnit = 'units',
    this.sellerName = 'Agro Store',
  });

  double get total => price * quantity;
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedTotal => '₹${total.toStringAsFixed(0)}';
}

class AgroOrder {
  final String orderNumber;
  final String itemTitle;
  final String category; // 'Crop', 'Farm Product', 'Farm Waste'
  final String quantity;
  final double price;
  final String counterParty; // Buyer or Seller name
  final String address;
  final String date;
  final String status; // 'Placed', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Completed'
  final bool isBuying; // true = farmer bought, false = farmer sold

  // Phase 10 Extended Fields
  final String? customerName;
  final String? mobileNumber;
  final String? village;
  final String? district;
  final String? state;
  final String? pincode;
  final String? deliveryNotes;
  final String paymentMethod;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final List<OrderItem> items;

  AgroOrder({
    String? orderNumber,
    String? id,
    String? itemTitle,
    this.category = 'Farm Product',
    String? quantity,
    double? price,
    double? totalAmount,
    String? counterParty,
    String? address,
    String? deliveryAddress,
    String? date,
    String? orderDate,
    this.status = 'Placed',
    this.isBuying = true,
    this.customerName,
    this.mobileNumber,
    this.village,
    this.district,
    this.state,
    this.pincode,
    this.deliveryNotes,
    this.paymentMethod = 'Cash on Delivery',
    double? subtotal,
    double? deliveryCharge,
    double? discount,
    List<OrderItem>? items,
  })  : orderNumber = orderNumber ?? id ?? 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        itemTitle = itemTitle ?? (items != null && items.isNotEmpty ? items.first.productName : 'Farm Product'),
        quantity = quantity ?? (items != null && items.isNotEmpty ? '${items.length} items' : '1 unit'),
        price = price ?? totalAmount ?? (items != null ? items.fold<double>(0.0, (sum, it) => sum + it.total) : 0.0),
        counterParty = counterParty ?? (items != null && items.isNotEmpty ? items.first.sellerName : 'Agro Store'),
        address = address ?? deliveryAddress ?? 'Farm Delivery Address',
        date = date ?? orderDate ?? 'Today',
        subtotal = subtotal ?? (items != null ? items.fold<double>(0.0, (sum, it) => sum + it.total) : (price ?? totalAmount ?? 0.0)),
        deliveryCharge = deliveryCharge ?? 50.0,
        discount = discount ?? 0.0,
        items = items ?? [];

  // Backward compatible & ergonomic getters
  String get id => orderNumber;
  double get totalAmount => price;
  String get deliveryAddress => address;
  String get orderDate => date;
  String get formattedTotal => '₹${price.toStringAsFixed(0)}';
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
  String get formattedDelivery => '₹${deliveryCharge.toStringAsFixed(0)}';

  String get paymentStatus {
    if (status == 'Cancelled') return 'Cancelled / No Charge';
    if (paymentMethod == 'Cash on Delivery') {
      return status == 'Delivered' || status == 'Completed'
          ? 'Paid on Delivery'
          : 'Pending on Delivery';
    }
    return 'Paid Online (Demo)';
  }

  bool get canBeCancelled {
    final s = status.toLowerCase();
    return s == 'placed' || s == 'confirmed' || s == 'processing' || s == 'requested';
  }

  AgroOrder copyWith({
    String? orderNumber,
    String? itemTitle,
    String? category,
    String? quantity,
    double? price,
    String? counterParty,
    String? address,
    String? date,
    String? status,
    bool? isBuying,
    String? customerName,
    String? mobileNumber,
    String? village,
    String? district,
    String? state,
    String? pincode,
    String? deliveryNotes,
    String? paymentMethod,
    double? subtotal,
    double? deliveryCharge,
    double? discount,
    List<OrderItem>? items,
  }) {
    return AgroOrder(
      orderNumber: orderNumber ?? this.orderNumber,
      itemTitle: itemTitle ?? this.itemTitle,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      counterParty: counterParty ?? this.counterParty,
      address: address ?? this.address,
      date: date ?? this.date,
      status: status ?? this.status,
      isBuying: isBuying ?? this.isBuying,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      village: village ?? this.village,
      district: district ?? this.district,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      discount: discount ?? this.discount,
      items: items ?? this.items,
    );
  }
}
