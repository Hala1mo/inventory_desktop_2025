import 'package:http/http.dart' as http;

import 'dart:convert';
import '../AppConstants.dart';

import '../models/Product.dart';

class ProductService {
  final String Url = '${AppConstants.serverUrl}/api/products';

  Future<bool> createProduct(Product product) async {
    final String jsonData = json.encode(product);

    print(jsonData);
    final uri = Uri.parse(Url);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    print(response.statusCode);
    if (response.statusCode == 201) {
      try {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');
        }
        return true;
      } catch (e) {
        print('Error during response parsing: $e');
        return false;
      }
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return false;
    }
  }

  Future<List<Product>> getProducts() async {
    List<Product> products = [];
    final uri = Uri.parse(Url);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          final List<dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');

          products =
              responseBody.map((item) => Product.fromJson(item)).toList();

          return products;
        }
        return [];
      } catch (e) {
        print('Error during response parsing: $e');
        return [];
      }
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return [];
    }
  }

  Future<bool> updateProduct(Product product) async {
    final String jsonData = json.encode(product);

    print(jsonData);
    final uri = Uri.parse(Url);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    print(response.statusCode);
    if (response.statusCode == 201) {
      try {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');
        }
        return true;
      } catch (e) {
        print('Error during response parsing: $e');
        return false;
      }
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return false;
    }
  }

  Future<bool> deleteProduct(Product product) async {
    final uri = Uri.parse('$Url/${product.id}'); // Append the product ID

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Delete failed: ${response.body}');
      return false;
    }
  }

}
