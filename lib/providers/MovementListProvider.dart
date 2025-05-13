import 'package:flutter/material.dart';
import 'package:inventory_desktop/models/ProductMovement.dart';
import '../models/Location.dart';
import '../models/Product.dart';

class MovementListProvider extends ChangeNotifier {
  List<ProductMovement> movements = [];
  List<ProductMovement> filteredLocations = [];
  

  String? selectedProduct;
  String? selectedToLocation;
  String? selectedFromLocation;
  String sortDate = 'Newest';
  

  List<String> get uniqueProducts {
    Set<String> products = Set<String>();
    products.add('All');
    for (var movement in movements) {
      if (movement.product.name.isNotEmpty) {
        products.add(movement.product.name);
      }
    }
    return products.toList();
  }
  
  List<String> get uniqueToLocations {
    Set<String> locations = Set<String>();
    locations.add('All');
    for (var movement in movements) {
      if (movement.toLocation != null && movement.toLocation!.name.isNotEmpty) {
        locations.add(movement.toLocation!.name);
      }
    }
    return locations.toList();
  }
  
  List<String> get uniqueFromLocations {
    Set<String> locations = Set<String>();
    locations.add('All');
    for (var movement in movements) {
      if (movement.fromLocation != null && movement.fromLocation!.name.isNotEmpty) {
        locations.add(movement.fromLocation!.name);
      }
    }
    return locations.toList();
  }
  
  void setMovements(List<ProductMovement> products) {
    movements = products;
    filteredLocations = List.from(products);
    notifyListeners();
  }
  
  void removeMovements(ProductMovement product) {
    movements.removeWhere((p) => p.id == product.id);
    filteredLocations.remove(product);
    notifyListeners();
  }
  
  void addMovements(ProductMovement product) {
    movements.add(product);
    filteredLocations.add(product);
    notifyListeners();
  }
  
  void updateMovement(ProductMovement updatedMovement) {
    final movementIndex = movements.indexWhere((p) => p.id == updatedMovement.id);
    final filteredIndex = filteredLocations.indexWhere((p) => p.id == updatedMovement.id);
    
    if (movementIndex != -1) {
      movements[movementIndex] = updatedMovement;
    }
    
    if (filteredIndex != -1) {
      filteredLocations[filteredIndex] = updatedMovement;
    }
    
    notifyListeners();
  }

  void filterMovements({
    String? product,
    String? toLocation,
    String? fromLocation,
    String? sort,
  }) {
 

    if (product != null) selectedProduct = product;
    if (toLocation != null) selectedToLocation = toLocation;
    if (fromLocation != null) selectedFromLocation = fromLocation;
    if (sort != null) sortDate = sort;
    

    filteredLocations = movements.where((movement) {
  
      bool matchesProduct = selectedProduct == null || 
                           selectedProduct == 'All' || 
                           movement.product.name == selectedProduct;
      

      bool matchesToLocation = selectedToLocation == null || 
                               selectedToLocation == 'All' || 
                               (movement.toLocation != null && 
                                movement.toLocation!.name == selectedToLocation);
      
   
      bool matchesFromLocation = selectedFromLocation == null || 
                                 selectedFromLocation == 'All' || 
                                 (movement.fromLocation != null && 
                                  movement.fromLocation!.name == selectedFromLocation);
      
      return matchesProduct && matchesToLocation && matchesFromLocation;
    }).toList();
    
    
    if (sortDate == 'Newest') {
      filteredLocations.sort((a, b) => 
        (b.timestamp ?? DateTime(1900)).compareTo(a.timestamp ?? DateTime(1900))
      );
    } else if (sortDate == 'Oldest') {
      filteredLocations.sort((a, b) => 
        (a.timestamp ?? DateTime(1900)).compareTo(b.timestamp ?? DateTime(1900))
      );
    }
    
    notifyListeners();
  }

  void clearFilters() {
    selectedProduct = null;
    selectedToLocation = null;
    selectedFromLocation = null;
    sortDate = 'Newest';
    filteredLocations = List.from(movements);

    if (movements.isNotEmpty) {
      filteredLocations.sort((a, b) => 
        (b.timestamp ?? DateTime(1900)).compareTo(a.timestamp ?? DateTime(1900))
      );
    }
    
    notifyListeners();
  }
  
  int get allCount => movements.length;
  
  int get filteredCount => filteredLocations.length;
}