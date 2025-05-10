
import '../models/Product.dart';
import '../services/productServices.dart';

class ProductController {
  final ProductService service = ProductService();

  Future<bool> addProduct(Product product) async {
    return await service.createProduct(product);
  }

  Future <List<Product>> getProducts() async {
    return await service.getProducts();
  }

  Future <bool> updateProduct(Product product) async {
    return await service.updateProduct(product);
  }

  Future <bool> deleteProduct(Product product) async {
    return await service.deleteProduct(product);
  }
}