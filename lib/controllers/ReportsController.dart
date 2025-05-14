import 'package:inventory_desktop/models/DashboardStats.dart';
import 'package:inventory_desktop/models/LocationProductCount.dart';
import '../models/ProductBalanceReport.dart';
import '../services/ReportsService.dart';

class ReportsController {
  final ReportsService service = ReportsService();

 
  Future<Map<String, int>> getProductsDistribution() async {
    return await service.getProcuctsDistribution();
  }

  Future<List<LocationProductCount>> getProductsCountPerLocation() async {
    return await service.getProductsCount();
  }

  Future<DashboardStats> getDashboardStats() async {
    return await service.getDashboardStats();
  }

Future<List<ProductBalanceReport>> getBalanceForAllProducts() async{
    return await service.getBalanceForAllProducts();
}


}
