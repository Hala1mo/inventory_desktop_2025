import 'package:http/http.dart' as http;

import 'dart:convert';
import '../AppConstants.dart';

import '../models/Product.dart';
import '../models/ProductBalance.dart';

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

  Future<Map<String, dynamic>> updateProduct(Product product) async {
    try {
    final String jsonData = json.encode(product);

    print(jsonData);
   final uri = Uri.parse('$Url/${product.id}'); 

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {};
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');
        }
         return {
        'success': true,
        'data': responseData
      };
    }
      else {
      String errorMessage = 'Failed to update product';
      
      if (response.body.isNotEmpty) {
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          if (responseBody.containsKey('message')) {
            errorMessage = responseBody['message'];
          }
          print('Update failed: ${response.body}');
        } catch (e) {
          print('Error parsing error response: $e');
        }
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }  catch (e) {
        print('Error during response parsing: $e');
        return {
      'success': false,
      'error': e.toString(),
    };
      }
    } 
  

  Future<Map<String, dynamic>> deleteProduct(Product product) async {
    try{
    final uri = Uri.parse('$Url/${product.id}'); 
  

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return {'success': true};
          } else {
      String errorMessage = 'Failed to delete product';
      if (response.body.isNotEmpty) {
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          if (responseBody.containsKey('message')) {
            errorMessage = responseBody['message'];
          }
          print('Delete failed: ${response.body}');
        } catch (e) {
          print('Error parsing response body: $e');
        }
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
          }
  } 
catch (e) {
    print('Exception during product delete: $e');
    return {
      'success': false,
      'error': e.toString(),
    };
  }
  }

   Future<List<ProductBalance>> getBalanceForSpecificProduct(
      Product product) async {
    final uri = Uri.parse('$Url/product-balances/${product.id}');
    List<ProductBalance> products = [];

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(uri);

    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          final List<dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');

          products = responseBody
              .map((item) => ProductBalance.fromJson(item))
              .toList();

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

}
