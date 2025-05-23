
import '../models/Product.dart';
import '../models/ProductBalance.dart';
import '../services/productServices.dart';

class ProductController {
  final ProductService service = ProductService();

Future<Map<String, dynamic>> addProduct(Product product) async {
    return await service.createProduct(product);
  }

  Future <List<Product>> getProducts() async {
    return await service.getProducts();
  }

Future<Map<String, dynamic>> updateProduct(Product product) async {
    return await service.updateProduct(product);
  }

Future<Map<String, dynamic>> deleteProduct(Product product) async {
    return await service.deleteProduct(product);
  }

  
     Future<List<ProductBalance>> fetchStockData(Product product) async {
    return await service.getBalanceForSpecificProduct(product);
  }
}