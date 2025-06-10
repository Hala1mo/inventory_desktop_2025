import '../models/Location.dart';

import '../models/ProductStock.dart';
import '../services/LocationService.dart';

class LocationController {
  final LocationService service = LocationService();

  Future<Map<String, dynamic>> addLocation(Location location) async {
    return await service.createLocation(location);
  }

  Future<List<Location>> getLocations() async {
    return await service.getLocations();
  }

  Future<Map<String, dynamic>> updateLocation(Location location) async {
    return await service.updateLocation(location);
  }

  Future<Map<String, dynamic>> deleteLocation(Location location) async {
    return await service.deleteLocation(location);
  }

  Future<List<ProductStock>> getProductsInSpecificLocation(
      Location location) async {
    return await service.getProducts(location);
  }
}
