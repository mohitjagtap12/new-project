class FarmProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final String seller;
  final String location;
  final String description;
  final String availableQuantity;
  final String image;
  final double rating;

  FarmProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.seller,
    required this.location,
    required this.description,
    required this.availableQuantity,
    required this.image,
    this.rating = 4.5,
  });
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
