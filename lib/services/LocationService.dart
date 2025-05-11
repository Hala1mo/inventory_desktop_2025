import 'package:http/http.dart' as http;

import 'dart:convert';
import '../AppConstants.dart';

import '../models/Location.dart';

class LocationService {
  final String Url = '${AppConstants.serverUrl}/api/locations';

  Future<bool> createLocation(Location location) async {
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

  Future<bool> updateLocation(Location location) async {
    final String jsonData = json.encode(location);

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

  Future<bool> deleteLocation(Location location) async {
    final uri = Uri.parse('$Url/${location.id}');

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
