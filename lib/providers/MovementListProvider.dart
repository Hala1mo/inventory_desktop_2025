import 'package:flutter/material.dart';
import 'package:inventory_desktop/models/ProductMovement.dart';
import '../models/Location.dart';

class MovementListProvider extends ChangeNotifier {
  List<ProductMovement> movements = [];
  List<ProductMovement> filteredLocations = [];

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

  int get allCount => movements.length;
}
