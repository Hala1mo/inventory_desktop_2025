import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import '../AppConstants.dart';
import '../models/LocationStock.dart';
import '../models/Product.dart';

class ProductMovementService {
  final String Url = '${AppConstants.serverUrl}/api/reports/product-balances';



  Future<List<LocationStock>> getBalanceForSpecificProduct(Product product) async {
    final uri = Uri.parse('$Url/${product.id}');
    List<LocationStock> products = [];


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

          products =
              responseBody.map((item) => LocationStock.fromJson(item)).toList();

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
