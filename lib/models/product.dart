class FarmProduct {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String priceUnit;
  final int availableQuantity;
  final String quantityUnit;
  final String sellerName;
  final String sellerLocation;
  final String image;
  final String status;
  final double rating;
  final int reviewsCount;
  final Map<String, String> specifications;
  final List<String> features;

  FarmProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.priceUnit = 'unit',
    this.availableQuantity = 50,
    this.quantityUnit = 'units',
    String? seller,
    String? sellerName,
    String? location,
    String? sellerLocation,
    required this.image,
    this.status = 'In Stock',
    this.rating = 4.5,
    this.reviewsCount = 24,
    this.specifications = const {},
    this.features = const [],
  })  : sellerName = sellerName ?? seller ?? 'Agro Store',
        sellerLocation = sellerLocation ?? location ?? 'Pune';

  // Convenient Aliases & Helper Getters
  String get seller => sellerName;
  String get location => sellerLocation;
  String get availableQuantityText => '$availableQuantity $quantityUnit';
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  bool get isInStock => status.toLowerCase() != 'out of stock' && availableQuantity > 0;
  bool get isLimitedStock =>
      status.toLowerCase() == 'limited stock' || (availableQuantity > 0 && availableQuantity <= 15);
}

class CartItem {
  final FarmProduct product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}
