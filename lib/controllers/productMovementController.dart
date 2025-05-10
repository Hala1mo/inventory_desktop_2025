import '../models/LocationStock.dart';
import '../models/Product.dart';
import '../services/ProductMovementServices.dart';

class ProductMovementController {
  final ProductMovementService service = ProductMovementService();

  Future<List<LocationStock>> fetchStockData(Product product) async {
    return await service.getBalanceForSpecificProduct(product);
  }




}