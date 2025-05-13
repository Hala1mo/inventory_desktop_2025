import 'package:flutter/material.dart';
import '../models/Location.dart';


class LocationListProvider extends ChangeNotifier {
  List<Location> _locations = [];
  List<Location> filteredLocations = [];



  void setLocations(List<Location> locations) {
    _locations = locations;
    filteredLocations = List.from(locations);
    notifyListeners();
  }

  void removeLocations(Location location) {
    _locations.removeWhere((l) => l.id == location.id);
  }

  void addLocation(Location location) {
    _locations.add(location);
  }

    void updateLocation(Location updatedlocation) {
    final locationIndex = _locations.indexWhere((p) => p.id == updatedlocation.id);
    final filteredIndex = filteredLocations.indexWhere((p) => p.id == updatedlocation.id);
    
    if (locationIndex != -1) {
      _locations[locationIndex] = updatedlocation;
    }
    
    if (filteredIndex != -1) {
      filteredLocations[filteredIndex] = updatedlocation;
    }
    
    notifyListeners();
  }

  int get allCount => _locations.length;
}
