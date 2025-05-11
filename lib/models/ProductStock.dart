class ProductStock {
  final String name;
  final int quantity;

  ProductStock({
    required this.quantity,
    required this.name,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      name: json['productName'],
      quantity: json['quantity'],
    );
  }

}
