class ProductBalanceReport {
  final String productName;
  final String locationName;
  final int quantity;

  ProductBalanceReport({
    required this.quantity,
    required this.locationName,
    required this.productName,
  });

  factory ProductBalanceReport.fromJson(Map<String, dynamic> json) {
    return ProductBalanceReport(
        quantity: json['balance'],
        locationName: json['locationName'],
        productName: json['productName']);
  }
}
