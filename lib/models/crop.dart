class Crop {
  final String id;
  final String name;
  final String variety;
  final String area;
  final String unit;
  final String plantingDate;
  final String expectedHarvest;
  final String status; // 'Growing', 'Ready for Harvest', 'Harvested'
  final String image;
  final String notes;
  final String location;

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.area,
    this.unit = 'Acres',
    required this.plantingDate,
    required this.expectedHarvest,
    required this.status,
    required this.image,
    this.notes = '',
    this.location = 'Pune, Maharashtra',
  });

  String get displayArea {
    final lower = area.toLowerCase();
    if (lower.contains('acre') || lower.contains('guntha') || lower.contains('hec') || lower.contains('bigha')) {
      return area;
    }
    return '$area $unit';
  }

  Crop copyWith({
    String? id,
    String? name,
    String? variety,
    String? area,
    String? unit,
    String? plantingDate,
    String? expectedHarvest,
    String? status,
    String? image,
    String? notes,
    String? location,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      area: area ?? this.area,
      unit: unit ?? this.unit,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvest: expectedHarvest ?? this.expectedHarvest,
      status: status ?? this.status,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      location: location ?? this.location,
    );
  }
}

class CropSale {
  final String id;
  final String? cropId;
  final String cropName;
  final String variety;
  final String quantity;
  final String unit; // 'kg', 'quintal', 'ton'
  final double price;
  final String priceUnit; // e.g. '₹/kg', '₹/quintal', '₹/ton'
  final String availableDate; // e.g. '15 Sep 2026'
  final String location;
  final String image;
  final String description;
  final String status; // 'Active', 'Sold', 'Cancelled'
  final String postedDate;

  CropSale({
    required this.id,
    this.cropId,
    required this.cropName,
    this.variety = '',
    required this.quantity,
    required this.unit,
    required this.price,
    this.priceUnit = '',
    this.availableDate = '',
    required this.location,
    required this.image,
    this.description = '',
    required this.status,
    required this.postedDate,
  });

  String get effectivePriceUnit =>
      priceUnit.isNotEmpty ? priceUnit : '₹/$unit';

  double get numericQuantity => double.tryParse(quantity) ?? 0.0;
  double get totalEstimatedValue => numericQuantity * price;

  bool get isActive =>
      status.toLowerCase() == 'active' || status.toLowerCase() == 'available';
  bool get isSold => status.toLowerCase() == 'sold';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  CropSale copyWith({
    String? id,
    String? cropId,
    String? cropName,
    String? variety,
    String? quantity,
    String? unit,
    double? price,
    String? priceUnit,
    String? availableDate,
    String? location,
    String? image,
    String? description,
    String? status,
    String? postedDate,
  }) {
    return CropSale(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      cropName: cropName ?? this.cropName,
      variety: variety ?? this.variety,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      availableDate: availableDate ?? this.availableDate,
      location: location ?? this.location,
      image: image ?? this.image,
      description: description ?? this.description,
      status: status ?? this.status,
      postedDate: postedDate ?? this.postedDate,
    );
  }
}
