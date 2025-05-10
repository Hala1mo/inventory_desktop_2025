import 'package:flutter/material.dart';
import '../models/Location.dart';


class LocationListProvider extends ChangeNotifier {
  List<Location> _locations = [];
  List<Location> filteredLocations = [];



  void setLocations(List<Location> products) {
    _locations = products;
    filteredLocations = List.from(products);
    notifyListeners();
  }

  void removeLocations(Location product) {
    _locations.removeWhere((p) => p.id == product.id);
  }

  void addLocation(Location product) {
    _locations.add(product);
  }

  int get allCount => _locations.length;
}
