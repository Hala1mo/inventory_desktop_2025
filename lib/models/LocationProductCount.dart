class LocationProductCount {
  final String name;
  final int quantity;

  LocationProductCount({
    required this.name,
    required this.quantity,
  });

  factory LocationProductCount.fromJson(Map<String, dynamic> json) {
    return LocationProductCount(
        name: json['locationName'], quantity: json['quantity']);
  }
}
