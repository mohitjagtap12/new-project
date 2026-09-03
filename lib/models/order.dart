class AgroOrder {
  final String orderNumber;
  final String itemTitle;
  final String category; // 'Crop', 'Farm Product', 'Farm Waste'
  final String quantity;
  final double price;
  final String counterParty; // Buyer or Seller name
  final String address;
  final String date;
  final String status; // 'Placed', 'Accepted', 'On the Way', 'Delivered', 'Completed'
  final bool isBuying; // true = farmer bought, false = farmer sold

  AgroOrder({
    required this.orderNumber,
    required this.itemTitle,
    required this.category,
    required this.quantity,
    required this.price,
    required this.counterParty,
    required this.address,
    required this.date,
    required this.status,
    required this.isBuying,
  });
}
