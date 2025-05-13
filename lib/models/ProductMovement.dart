import 'Location.dart';
import 'Product.dart';

enum MovementType {
  IN,
  OUT,
  TRANSFER;

  String get label {
    switch (this) {
      case MovementType.IN:
        return 'Incoming';
      case MovementType.OUT:
        return 'Outgoing';
      case MovementType.TRANSFER:
        return 'TRANSFER';
    }
  }
}

class ProductMovement {
  int? id;
  final MovementType movementType;
  final int quantity;
  String? notes;
  final Product product;
  final Location? fromLocation;
  final Location? toLocation;
  DateTime? timestamp;

  ProductMovement({
    this.id,
    required this.movementType,
    required this.quantity,
    required this.notes,
    required this.product,
    this.fromLocation,
    this.toLocation,
    this.timestamp,
  });

  factory ProductMovement.fromJson(Map<String, dynamic> json) {
    return ProductMovement(
      id: json['id'],
      movementType: MovementType.values.firstWhere(
          (e) => e.name.toLowerCase() == json['movementType'].toLowerCase()),
      quantity: json['quantity'],
      notes: json['notes'],
      product: Product.fromJson(json['product']),
      fromLocation: json['fromLocation'] != null
          ? Location.fromJson(json['fromLocation'])
          : null,
      toLocation: json['toLocation'] != null
          ? Location.fromJson(json['toLocation'])
          : null,
     timestamp: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'movementType': movementType.name,
        'quantity': quantity,
        'notes': notes,
        'product': product.toJson(),
        'fromLocation': fromLocation?.toJson(),
        'toLocation': toLocation?.toJson(),
      };
}
