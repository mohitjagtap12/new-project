class FarmWaste {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String wasteType;
  final String quantity;
  final String quantityUnit; // 'kg', 'quintal', 'ton'
  final double price;
  final String priceUnit; // '₹/ton', '₹/quintal', '₹/kg'
  final String location;
  final String availableDate;
  final String description;
  final String image;
  final String status; // 'Active', 'Sold', 'Cancelled'
  final String postedDate;
  final List<String> recommendedUses;

  FarmWaste({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.wasteType,
    required this.quantity,
    this.quantityUnit = 'ton',
    required this.price,
    this.priceUnit = '₹/ton',
    required this.location,
    required this.availableDate,
    this.description = '',
    required this.image,
    this.status = 'Active',
    required this.postedDate,
    this.recommendedUses = const [],
  });

  double get numericQuantity => double.tryParse(quantity) ?? 0.0;

  double get totalEstimatedValue => numericQuantity * price;

  bool get isActive => status.toLowerCase() == 'active' || status.toLowerCase() == 'available';
  bool get isSold => status.toLowerCase() == 'sold';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  String get formattedPrice => '₹${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';
  String get formattedQuantity => '$quantity $quantityUnit';

  FarmWaste copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    String? wasteType,
    String? quantity,
    String? quantityUnit,
    double? price,
    String? priceUnit,
    String? location,
    String? availableDate,
    String? description,
    String? image,
    String? status,
    String? postedDate,
    List<String>? recommendedUses,
  }) {
    return FarmWaste(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      wasteType: wasteType ?? this.wasteType,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      location: location ?? this.location,
      availableDate: availableDate ?? this.availableDate,
      description: description ?? this.description,
      image: image ?? this.image,
      status: status ?? this.status,
      postedDate: postedDate ?? this.postedDate,
      recommendedUses: recommendedUses ?? this.recommendedUses,
    );
  }
}
