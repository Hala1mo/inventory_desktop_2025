enum ProductStatus { ACTIVE, INACTIVE, DRAFT }

enum ProductCategory {
  ELECTRONICS,
  FURNITURE;

  String get label {
    switch (this) {
      case ProductCategory.ELECTRONICS:
        return 'Electronics';
      case ProductCategory.FURNITURE:
        return 'Furniture';
    }
  }
}


class Product {
  int? id;
  final String name;
  final String code;
  final double price;
  final String description;
  final ProductCategory category;
  final String imageUrl;
  final ProductStatus status;
   DateTime? createdAt;

  Product({
    required this.code,
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.status,
     this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: ProductCategory.values.firstWhere(
          (e) => e.name.toLowerCase() == json['category'].toLowerCase()),
      imageUrl: json['imageUrl'],
      status: ProductStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == json['status'].toLowerCase()),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'code': code,
        'description': description,
        'category': category.name,
        'imageUrl': imageUrl,
        'status': status.name,
      };
}
