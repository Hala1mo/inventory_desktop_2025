class ProductBalance {
  final String name;
  final int quantity;

  ProductBalance({
    required this.quantity,
    required this.name,
  });

  factory ProductBalance.fromJson(Map<String, dynamic> json) {
    return ProductBalance(
      quantity: json['balance'],
      name: json['locationName'],
    );
  }
}
