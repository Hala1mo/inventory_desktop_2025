import 'package:http/http.dart' as http;
import 'package:inventory_desktop/models/ProductMovement.dart';
import 'dart:convert';
import '../AppConstants.dart';


class ProductMovementService {
  final String Url = '${AppConstants.serverUrl}/api/productMovement';

  Future<Map<String, dynamic>> createProductMovement(
      ProductMovement movement) async {
    try {
      final String jsonData = json.encode(movement);

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
        Map<String, dynamic> responseData = {};
          final Map<String, dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');
        
         final addedMovement = ProductMovement.fromJson(responseBody);
    
        return {'success': true, 'data': addedMovement};
      } else {
        String errorMessage = 'Failed to create movement';
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseBody =
                json.decode(response.body);
            if (responseBody.containsKey('message')) {
              errorMessage = responseBody['message'];
            }
            print('Creation failed: ${response.body}');
          } catch (e) {
            print('Error parsing response body: $e');
          }
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } catch (e) {
      print('Exception during product delete: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<ProductMovement>> getProductMovements() async {
    List<ProductMovement> products = [];
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

          products = responseBody
              .where((item) => item != null && item is Map<String, dynamic>)
              .map((item) =>
                  ProductMovement.fromJson(item as Map<String, dynamic>))
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

  Future<Map<String, dynamic>> updateProductMovement(
      ProductMovement product) async {
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
       
          final Map<String, dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');
        
         final updatedMovement = ProductMovement.fromJson(responseBody);
    
        return {'success': true, 'data': updatedMovement};
        
      } else {
        String errorMessage = 'Failed to update movement';

        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseBody =
                json.decode(response.body);
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
    } catch (e) {
      print('Error during response parsing: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteProductMovement(
      ProductMovement movement) async {
    try {
      final uri = Uri.parse('$Url/${movement.id}');

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
            final Map<String, dynamic> responseBody =
                json.decode(response.body);
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
    } catch (e) {
      print('Exception during product delete: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

}
