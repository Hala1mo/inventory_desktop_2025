import 'package:flutter/material.dart';
import 'package:inventory_desktop/controllers/ReportsController.dart';
import '../models/ProductBalanceReport.dart';
import '../widgets/CustomAppBar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  ReportsController controller = ReportsController();
  List<ProductBalanceReport> balances = [];
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  
  // Sorting state
  String _sortColumn = 'quantity';
  bool _sortAscending = false;

  Future<void> loadStockData() async {
    List<ProductBalanceReport> result = await controller.getBalanceForAllProducts();
    setState(() {
      balances = result;
      _sortData();
    });
  }

  void _sortData() {
    balances.sort((a, b) {
      var aValue;
      var bValue;
      
      switch (_sortColumn) {
        case 'quantity':
          aValue = a.quantity;
          bValue = b.quantity;
          break;
        case 'product':
          aValue = a.productName;
          bValue = b.productName;
          break;
        case 'location':
          aValue = a.locationName;
          bValue = b.locationName;
          break;
        default:
          aValue = a.quantity;
          bValue = b.quantity;
      }
      
      if (aValue is String && bValue is String) {
        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else if (aValue is num && bValue is num) {
        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }
      return 0;
    });
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      _sortData();
    });
  }

  @override
  void initState() {
    super.initState();
    loadStockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F171A),
      appBar: const CustomAppBar(currentPage: 'report'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Product Balances",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(width: 5),
              ],
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
                    : LayoutBuilder(
                        builder: (context, constraints) {
                    
                          double totalWidth = constraints.maxWidth;
                          double quantityWidth = totalWidth * 0.15; 
                          double remainingWidth = totalWidth - quantityWidth;
                          double productWidth = remainingWidth * 0.5; 
                          double locationWidth = remainingWidth * 0.5; 
                          
                          // Ensure minimum widths
                          quantityWidth = quantityWidth < 100 ? 100 : quantityWidth;
                          productWidth = productWidth < 150 ? 150 : productWidth;
                          locationWidth = locationWidth < 150 ? 150 : locationWidth;
                          
                          return Column(
                            children: [
                              // Table header
                              Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[800]!, width: 1),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: _horizontalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      // Quantity column header
                                      _buildHeaderCell('Quantity', 'quantity', quantityWidth, TextAlign.right),
                                      
                                      // Product column header
                                      _buildHeaderCell('Product', 'product', productWidth, TextAlign.left),
                                      
                                      // Location column header
                                      _buildHeaderCell('Location', 'location', locationWidth, TextAlign.left),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Table body
                              Expanded(
                                child: Scrollbar(
                                  controller: _verticalScrollController,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _verticalScrollController,
                                    child: NotificationListener<ScrollNotification>(
                                      onNotification: (ScrollNotification scrollInfo) {
                                        if (scrollInfo is ScrollStartNotification) {
                                          // Sync horizontal scroll of header and body
                                          _horizontalScrollController.jumpTo(_horizontalScrollController.offset);
                                        }
                                        return false;
                                      },
                                      child: SingleChildScrollView(
                                        controller: _horizontalScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          children: balances.map((item) => _buildDataRow(
                                            item, 
                                            quantityWidth, 
                                            productWidth, 
                                            locationWidth,
                                          )).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeaderCell(String title, String column, double width, TextAlign align) {
    return InkWell(
      onTap: () => _onSort(column),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey[800]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Always left-align headers
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            if (_sortColumn == column)
              Icon(
                _sortAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: Colors.white70,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDataRow(ProductBalanceReport item, double qWidth, double pWidth, double lWidth) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Quantity cell
          Container(
            width: qWidth,
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft, // Left-align quantity values
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
            ),
            child: Text(
              item.quantity.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Product cell
          Container(
            width: pWidth,
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
            ),
            child: Text(
              item.productName,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Location cell
          Container(
            width: lWidth,
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              item.locationName,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}