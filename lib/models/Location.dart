class Location {
  int? id;
  final String name;
  final String country;
  final String city;
  final String address;
  DateTime? createdAt;

  Location({
    this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.address,
    this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      city: json['city'],
      address:json['address'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'country': country, 'city': city, 'address': address};
}
