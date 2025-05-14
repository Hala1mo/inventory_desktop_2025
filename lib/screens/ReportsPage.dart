import 'dart:math' as Math;
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
  List<ProductBalanceReport> filteredBalances = [];
  List<ProductBalanceReport> paginatedBalances = []; // For pagination
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  
  // Search controllers
  final TextEditingController _productSearchController = TextEditingController();
  final TextEditingController _locationSearchController = TextEditingController();
  
  // Sorting state
  String _sortColumn = 'quantity';
  bool _sortAscending = false;
  
  // Pagination state
  int _currentPage = 0;
  final int _pageSize = 15; // Fixed to exactly 15 items per page
  int _totalPages = 0;

  Future<void> loadStockData() async {
    List<ProductBalanceReport> result = await controller.getBalanceForAllProducts();
    setState(() {
      balances = result;
      _applyFilters();
    });
  }

  void _sortData() {
    filteredBalances.sort((a, b) {
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
    
    _updatePagination();
  }

  void _applyFilters() {
    setState(() {
      String productSearch = _productSearchController.text.toLowerCase();
      String locationSearch = _locationSearchController.text.toLowerCase();
      
      filteredBalances = balances.where((item) {
        bool matchesProduct = productSearch.isEmpty || 
                             item.productName.toLowerCase().contains(productSearch);
        bool matchesLocation = locationSearch.isEmpty || 
                              item.locationName.toLowerCase().contains(locationSearch);
        return matchesProduct && matchesLocation;
      }).toList();
      
      _sortData();
      _currentPage = 0; // Reset to first page when filters change
      _updatePagination();
    });
  }
  
  void _updatePagination() {
    // Calculate total pages
    _totalPages = (filteredBalances.length / _pageSize).ceil();
    if (_totalPages == 0) _totalPages = 1; // At least one page even if empty
    
    // Ensure current page is valid
    if (_currentPage >= _totalPages) _currentPage = _totalPages - 1;
    if (_currentPage < 0) _currentPage = 0;
    
    // Get paginated data - ALWAYS use exactly 15 items per page
    int startIndex = _currentPage * _pageSize;
    int endIndex = startIndex + _pageSize;
    if (endIndex > filteredBalances.length) endIndex = filteredBalances.length;
    
    if (filteredBalances.isEmpty) {
      paginatedBalances = [];
    } else {
      paginatedBalances = filteredBalances.sublist(startIndex, endIndex);
    }
    
    print('Page size: $_pageSize, showing ${paginatedBalances.length} items');
  }
  
  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      _updatePagination();
      // Scroll back to top when page changes
      _verticalScrollController.jumpTo(0);
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
    // Add listeners to search controllers
    _productSearchController.addListener(_applyFilters);
    _locationSearchController.addListener(_applyFilters);
    loadStockData();
    
    // Ensure we're using 15 items per page
    print('Initialized with page size: $_pageSize');
  }

  @override
  void dispose() {
    _productSearchController.dispose();
    _locationSearchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
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
            // Title row with search fields
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
                const Spacer(flex: 1),
                // Product search field
                Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A2327),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _productSearchController,
                          decoration: InputDecoration(
                            hintText: 'Search Product',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (_productSearchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _productSearchController.clear();
                          },
                          child: Icon(Icons.close, color: Colors.grey[400], size: 16),
                        ),
                    ],
                  ),
                ),
                // Location search field
                Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A2327),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[400], size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _locationSearchController,
                          decoration: InputDecoration(
                            hintText: 'Search Location',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (_locationSearchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _locationSearchController.clear();
                          },
                          child: Icon(Icons.close, color: Colors.grey[400], size: 16),
                        ),
                    ],
                  ),
                ),
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
                                child: filteredBalances.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No matching products found",
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      )
                                    : Scrollbar(
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
                                                children: paginatedBalances.map((item) => _buildDataRow(
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
                              
                              // Pagination controls
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[800]!, width: 1),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Info text
                                    Text(
                                      'Showing ${_currentPage * _pageSize + 1} to ${Math.min((_currentPage * _pageSize) + paginatedBalances.length, filteredBalances.length)} of ${filteredBalances.length} entries',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    
                                    // Page navigation
                                    Row(
                                      children: [
                                        // First page button
                                        IconButton(
                                          icon: Icon(Icons.first_page),
                                          onPressed: _currentPage == 0 ? null : () => _changePage(0),
                                          color: Colors.white70,
                                          disabledColor: Colors.grey[700],
                                        ),
                                        
                                        // Previous page button
                                        IconButton(
                                          icon: Icon(Icons.navigate_before),
                                          onPressed: _currentPage == 0 ? null : () => _changePage(_currentPage - 1),
                                          color: Colors.white70,
                                          disabledColor: Colors.grey[700],
                                        ),
                                        
                                        // Current page indicator
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[800],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${_currentPage + 1}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        
                                        // Next page button
                                        IconButton(
                                          icon: Icon(Icons.navigate_next),
                                          onPressed: _currentPage >= _totalPages - 1 ? null : () => _changePage(_currentPage + 1),
                                          color: Colors.white70,
                                          disabledColor: Colors.grey[700],
                                        ),
                                        
                                        // Last page button
                                        IconButton(
                                          icon: Icon(Icons.last_page),
                                          onPressed: _currentPage >= _totalPages - 1 ? null : () => _changePage(_totalPages - 1),
                                          color: Colors.white70,
                                          disabledColor: Colors.grey[700],
                                        ),
                                      ],
                                    ),
                                  ],
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