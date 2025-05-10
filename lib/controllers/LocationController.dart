import '../models/Location.dart';

import '../services/LocationService.dart';

class LocationController {
  final LocationService service = LocationService();

  Future<bool> addLocation(Location location) async {
    return await service.createLocation(location);
  }

  Future<List<Location>> getLocations() async {
    return await service.getLocations();
  }

  Future<bool> updateLocation(Location location) async {
    return await service.updateLocation(location);
  }

  Future<bool> deleteLocation(Location location) async {
    return await service.deleteLocation(location);
  }
}
