class FarmContract {
  final String id;
  final String company;
  final String crop;
  final String quantity;
  final double price;
  final String location;
  final String lastDate;
  final String quality;
  final String contractPeriod;
  final String companyDetails;
  final String status; // 'Available', 'Applied', 'Under Review', 'Accepted', 'Rejected', 'Completed'

  FarmContract({
    required this.id,
    required this.company,
    required this.crop,
    required this.quantity,
    required this.price,
    required this.location,
    required this.lastDate,
    required this.quality,
    required this.contractPeriod,
    required this.companyDetails,
    this.status = 'Available',
  });

  FarmContract copyWith({
    String? status,
  }) {
    return FarmContract(
      id: id,
      company: company,
      crop: crop,
      quantity: quantity,
      price: price,
      location: location,
      lastDate: lastDate,
      quality: quality,
      contractPeriod: contractPeriod,
      companyDetails: companyDetails,
      status: status ?? this.status,
    );
  }
}
