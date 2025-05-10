class Location {
  final int id;
  final String name;
  final String country;
  final String city;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Location({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      city: json['city'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'createdAt': createdAt.toIso8601String(),
  };
}
