import 'package:flutter/material.dart';
import 'package:inventory_desktop/controllers/ReportsController.dart';
import '../controllers/LocationController.dart';
import '../controllers/productContorller.dart';
import '../models/Location.dart';
import '../models/Product.dart';
import '../models/ProductBalanceReport.dart';
import '../widgets/CustomAppBar.dart';

class ReportsPageStockBalance extends StatefulWidget {
  const ReportsPageStockBalance({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPageStockBalance> {
  ReportsController controller = ReportsController();
  ProductController productController = ProductController();
  LocationController locationController = LocationController();

  List<ProductBalanceReport> balances = [];
  List<Product> products = [];
  List<Location> locations = [];

  Map<String, Map<String, int>> crossTabData = {};
  List<String> uniqueProductNames = [];
  List<String> uniqueLocationNames = [];

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  Future<void> loadStockData() async {
    List<ProductBalanceReport> result =
        await controller.getBalanceForAllProducts();
    List<Product> productsData = await productController.getProducts();
    List<Location> locationsData = await locationController.getLocations();

    setState(() {
      balances = result;
      products = productsData;
      locations = locationsData;

      _createCrossTabData();
    });
  }

  void _createCrossTabData() {
    crossTabData = {};
    Set<String> productNamesSet = {};
    Set<String> locationNamesSet = {};

    for (var product in products) {
      productNamesSet.add(product.name);
    }

    for (var location in locations) {
      locationNamesSet.add(location.name);
    }

    for (var productName in productNamesSet) {
      crossTabData[productName] = {};
      for (var locationName in locationNamesSet) {
        crossTabData[productName]![locationName] = 0;
      }
    }

    for (var balance in balances) {
      if (crossTabData.containsKey(balance.productName)) {
        crossTabData[balance.productName]![balance.locationName] =
            balance.quantity;
      }
    }

    uniqueProductNames = productNamesSet.toList()..sort();
    uniqueLocationNames = locationNamesSet.toList()..sort();
  }

  @override
  void initState() {
    super.initState();
    loadStockData();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F171A),
      appBar: const CustomAppBar(currentPage: 'report2'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Balance Matrix",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A2327),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: balances.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : _buildSynchronizedTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSynchronizedTable() {
    final cellWidth = 250.0;
    final productColumnWidth = 250.0;
    final rowHeight = 46.0;
    
    final totalLocationsWidth = cellWidth * uniqueLocationNames.length;
    
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: productColumnWidth,
              height: rowHeight,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A30),
                border: Border(
                  right: BorderSide(color: Colors.grey[800]!, width: 1),
                  bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
      
            Expanded(
              child: SizedBox(
                width: productColumnWidth,
                child: ListView.builder(
                  controller: _verticalScrollController,
                  itemCount: uniqueProductNames.length,
                  itemBuilder: (context, index) {
                    final product = uniqueProductNames[index];
                    return Container(
                      height: rowHeight,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey[800]!, width: 1),
                          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalLocationsWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: rowHeight,
                    child: Row(
                      children: uniqueLocationNames.map((location) {
                        return Container(
                          width: cellWidth,
                          height: rowHeight,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E2A30),
                            border: Border(
                              right: BorderSide(color: Colors.grey[800]!, width: 1),
                              bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  Expanded(
                    child: ListView.builder(
                      controller: _verticalScrollController,
                      itemCount: uniqueProductNames.length,
                      itemBuilder: (context, productIndex) {
                        final product = uniqueProductNames[productIndex];
                        return SizedBox(
                          height: rowHeight,
                          child: Row(
                            children: uniqueLocationNames.map((location) {
                              final quantity = crossTabData[product]?[location] ?? 0;
                              return Container(
                                width: cellWidth,
                                height: rowHeight,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey[800]!, width: 1),
                                    bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: quantity > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}