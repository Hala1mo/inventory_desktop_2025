
import '../models/ProductMovement.dart';
import '../services/ProductMovementServices.dart';

class ProductMovementController {
  final ProductMovementService service = ProductMovementService();

Future<Map<String, dynamic>> addMovement(ProductMovement movement) async {
    return await service.createProductMovement(movement);
  }

  Future <List<ProductMovement>> getMovements() async {
    return await service.getProductMovements();
  }
Future<Map<String, dynamic>> updateMovement(ProductMovement movement) async {
    return await service.updateProductMovement(movement);
  }

Future<Map<String, dynamic>> deleteMovement(ProductMovement movement) async {
    return await service.deleteProductMovement(movement);
  }





}