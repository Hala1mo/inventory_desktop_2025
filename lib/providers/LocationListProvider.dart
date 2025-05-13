import 'package:flutter/material.dart';
import '../models/Location.dart';

class LocationListProvider extends ChangeNotifier {
  List<Location> _locations = [];
  List<Location> filteredLocations = [];
  
  // Filter state
  String selectedCountry = 'All';
  String selectedCity = 'All';
  String sortAlphabetically = 'A-Z';
  String lastSortType = 'none';
  

  List<String> get uniqueCountries {
    Set<String> countries = _locations.map((loc) => loc.country).toSet();
    return ['All', ...countries];
  }
  
  List<String> get uniqueCities {
    Set<String> cities = _locations.map((loc) => loc.city).toSet();
    return ['All', ...cities];
  }
  
  void setLocations(List<Location> locations) {
    _locations = locations;
    filteredLocations = List.from(locations);
    notifyListeners();
  }
  
  void removeLocations(Location location) {
    _locations.removeWhere((l) => l.id == location.id);
    filterLocations(); // Apply filters after removal
  }
  
  void addLocation(Location location) {
    _locations.add(location);
    filterLocations(); // Apply filters after addition
  }
  
  void updateLocation(Location updatedLocation) {
    final locationIndex = _locations.indexWhere((p) => p.id == updatedLocation.id);
    final filteredIndex = filteredLocations.indexWhere((p) => p.id == updatedLocation.id);
    
    if (locationIndex != -1) {
      _locations[locationIndex] = updatedLocation;
    }
    
    if (filteredIndex != -1) {
      filteredLocations[filteredIndex] = updatedLocation;
    }
    
    notifyListeners();
  }
  
  // Filter and sort locations
  void filterLocations({
    String? country,
    String? city,
    String? sortAlpha,
  }) {
    // Update filter criteria if provided
    if (country != null) selectedCountry = country;
    if (city != null) selectedCity = city;
    
    // Track which sort was changed
    if (sortAlpha != null) {
      sortAlphabetically = sortAlpha;
      lastSortType = 'alpha';
    }
    
    // Apply filters
    filteredLocations = _locations.where((location) {
      bool matchesCountry = selectedCountry == 'All' || 
                           location.country.toLowerCase() == selectedCountry.toLowerCase();
      bool matchesCity = selectedCity == 'All' || 
                        location.city.toLowerCase() == selectedCity.toLowerCase();
      
      return matchesCountry && matchesCity;
    }).toList();
    
    // Apply sorting
    if (lastSortType == 'alpha') {
      if (sortAlphabetically == 'A-Z') {
        filteredLocations.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else if (sortAlphabetically == 'Z-A') {
        filteredLocations.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      }
    }
    
    notifyListeners();
  }
  
  // Clear all filters
  void clearFilters() {
    selectedCountry = 'All';
    selectedCity = 'All';
    sortAlphabetically = 'A-Z';
    lastSortType = 'none';
    filteredLocations = List.from(_locations);
    notifyListeners();
  }
  
  int get allCount => _locations.length;
  
  int get filteredCount => filteredLocations.length;
}