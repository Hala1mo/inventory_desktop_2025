import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory_desktop/models/LocationProductCount.dart';

import '../AppConstants.dart';
import '../models/DashboardStats.dart';

class ReportsService {
  final String Url = '${AppConstants.serverUrl}/api/reports';

  Future<Map<String, int>> getProcuctsDistribution() async {
    final uri = Uri.parse('$Url/productDistribution');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      print(jsonBody);
      return jsonBody.map((key, value) => MapEntry(key, value as int));
    } else {
      print("Failed to load stock distribution: ${response.body}");
      throw Exception("Failed to fetch stock distribution");
    }
  }

  Future<List<LocationProductCount>> getProductsCount() async {
    final String getProductsURL = '$Url/product-counts-per-location';
    List<LocationProductCount> counts = [];
    final uri = Uri.parse(getProductsURL);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          final List<dynamic> responseBody = json.decode(response.body);
          print('Full Response Body: $responseBody');

          counts = responseBody
              .map((item) => LocationProductCount.fromJson(item))
              .toList();
      
          return counts;
        }
        return [];
      } catch (e) {
        print('Error during response parsing: $e');
        return [];
      }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return [];
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return [];
    }
  }

Future<DashboardStats> getDashboardStats() async {
  final String getProductsURL = '$Url/dashboard-stats';
  final uri = Uri.parse(getProductsURL);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    try {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print('Full Response Body: $responseBody');
      return DashboardStats.fromJson(responseBody);
    } catch (e) {
      throw Exception('Failed to parse dashboard stats: $e');
    }
  } else {
    throw Exception('Failed to fetch dashboard stats. Status: ${response.statusCode}');
  }
}


  
}
