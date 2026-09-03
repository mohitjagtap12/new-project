class Crop {
  final String id;
  final String name;
  final String variety;
  final String area;
  final String plantingDate;
  final String expectedHarvest;
  final String status; // 'Growing', 'Ready for Harvest', 'Harvested'
  final String image;
  final String notes;

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.area,
    required this.plantingDate,
    required this.expectedHarvest,
    required this.status,
    required this.image,
    this.notes = '',
  });

  Crop copyWith({
    String? id,
    String? name,
    String? variety,
    String? area,
    String? plantingDate,
    String? expectedHarvest,
    String? status,
    String? image,
    String? notes,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      area: area ?? this.area,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvest: expectedHarvest ?? this.expectedHarvest,
      status: status ?? this.status,
      image: image ?? this.image,
      notes: notes ?? this.notes,
    );
  }
}

class CropSale {
  final String id;
  final String cropName;
  final String quantity;
  final String unit;
  final double price;
  final String location;
  final String image;
  final String description;
  final String status; // 'Available', 'Sold', 'Waiting'
  final String postedDate;

  CropSale({
    required this.id,
    required this.cropName,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.location,
    required this.image,
    this.description = '',
    required this.status,
    required this.postedDate,
  });
}
