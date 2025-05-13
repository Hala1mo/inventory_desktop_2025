import 'package:flutter/material.dart';
import '../models/DashboardStats.dart';
import '../models/LocationProductCount.dart';
import '../controllers/ReportsController.dart';

class DashboardProvider extends ChangeNotifier {
  final ReportsController _controller = ReportsController();
  
 
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  
 
  DashboardStats stats = DashboardStats(
    totalInventory: 0,
    totalLocations: 0,
    transferMovements: 0,
    inMovements: 0,
    outMovements: 0,
  );
  Map<String, int> distribution = {};
  List<LocationProductCount> locationCounts = [];
  
  // Constructor to load data immediately
  DashboardProvider() {
    loadData();
  }
  
  // Reload data
  Future<void> loadData() async {
    isLoading = true;
    hasError = false;
    notifyListeners();
    
    try {
   
      final futures = await Future.wait([
        _controller.getProductsDistribution(),
        _controller.getProductsCountPerLocation(),
        _controller.getDashboardStats(),
      ]);
      
      distribution = futures[0] as Map<String, int>;
      locationCounts = futures[1] as List<LocationProductCount>;
      stats = futures[2] as DashboardStats;
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to load dashboard data: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      print('Dashboard loading error: $e');
    }
  }
  

  String getStatValue(int? value) {
    return value?.toString() ?? '0';
  }
}