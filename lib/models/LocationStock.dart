

class LocationStock {
  final String name;
  final int quantity;

  LocationStock({
    required this.quantity,
    required this.name,
  });

  factory LocationStock.fromJson(Map<String, dynamic> json) {
    return LocationStock(
      quantity: json['balance'],
      name: json['locationName'],
    );
  }

}
