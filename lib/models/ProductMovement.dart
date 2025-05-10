import 'Location.dart';
import 'Product.dart';

enum MovementType { inMovement, out, transfer }
enum ShipmentStatus { pending, shipped, delivered, cancelled }

class ProductMovement {
  final int id;
  final MovementType movementType;
  final ShipmentStatus shipmentStatus;
  final int quantity;
  final String notes;
  final Product product;
  final Location? fromLocation;
  final Location? toLocation;
  final DateTime timestamp;

  ProductMovement({
    required this.id,
    required this.movementType,
    required this.shipmentStatus,
    required this.quantity,
    required this.notes,
    required this.product,
    this.fromLocation,
    this.toLocation,
    required this.timestamp,
  });

  factory ProductMovement.fromJson(Map<String, dynamic> json) {
    return ProductMovement(
      id: json['id'],
      movementType: MovementType.values.firstWhere(
              (e) => e.name.toLowerCase() == json['movementType'].toLowerCase()),
      shipmentStatus: ShipmentStatus.values.firstWhere(
              (e) => e.name.toLowerCase() == json['shipmentStatus'].toLowerCase()),
      quantity: json['quantity'],
      notes: json['notes'],
      product: Product.fromJson(json['product']),
      fromLocation: json['fromLocation'] != null
          ? Location.fromJson(json['fromLocation'])
          : null,
      toLocation: json['toLocation'] != null
          ? Location.fromJson(json['toLocation'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'movementType': movementType.name,
    'shipmentStatus': shipmentStatus.name,
    'quantity': quantity,
    'notes': notes,
    'product': product.toJson(),
    'fromLocation': fromLocation?.toJson(),
    'toLocation': toLocation?.toJson(),
    'timestamp': timestamp.toIso8601String(),
  };
}
