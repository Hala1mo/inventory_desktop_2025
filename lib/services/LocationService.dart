import 'package:http/http.dart' as http;

import 'dart:convert';
import '../AppConstants.dart';

import '../models/Location.dart';
import '../models/ProductStock.dart';

class LocationService {
  final String Url = '${AppConstants.serverUrl}/api/locations';

 Future<Map<String, dynamic>> createLocation(Location location) async {
  try{
    final String jsonData = json.encode(location);

    print(jsonData);
    final uri = Uri.parse(Url);
    print(jsonData);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    print(response.statusCode);
    if (response.statusCode == 201 || response.statusCode == 200) {
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
  

  Future<List<Location>> getLocations() async {
    List<Location> locations = [];
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

          locations =
              responseBody.map((item) => Location.fromJson(item)).toList();

          return locations;
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

  Future<Map<String, dynamic>> updateLocation(Location location) async {
    print("halalalalalalalla");
    try {
      final String jsonData = json.encode(location);
      final uri = Uri.parse('$Url/${location.id}');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      print('Status Code: ${response.statusCode}');
     print('Status Code: ${response.body}');
   
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {};

        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseBody =
                json.decode(response.body);
            print('Full Response Body: $responseBody');
            responseData = responseBody;
          } catch (e) {
            print('Error parsing success response: $e');
          }
        }

        return {'success': true, 'data': responseData};
      } else {
        // Error case
        String errorMessage = 'Failed to update location';

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
      print('Exception during update: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteLocation(Location location) async {
    try {
      final uri = Uri.parse('$Url/${location.id}');

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
        String errorMessage = 'Failed to delete location';

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
      print('Exception during delete: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<ProductStock>> getProducts(Location location) async {
    final String getProductsURL = '$Url/${location.id}/inventory';
    List<ProductStock> products = [];
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

          products =
              responseBody.map((item) => ProductStock.fromJson(item)).toList();

          return products;
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
}
