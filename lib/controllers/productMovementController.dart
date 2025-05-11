
import '../models/Product.dart';
import '../models/ProductBalance.dart';
import '../services/ProductMovementServices.dart';

class ProductMovementController {
  final ProductMovementService service = ProductMovementService();

  Future<List<ProductBalance>> fetchStockData(Product product) async {
    return await service.getBalanceForSpecificProduct(product);
  }




}