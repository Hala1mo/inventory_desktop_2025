import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/LocationController.dart';
import '../../models/Location.dart';
import '../../models/ProductStock.dart';
import '../../widgets/CustomButton.dart';
import 'EditLocation.dart';

class LocationDetails extends StatefulWidget {
  final Location location;

  const LocationDetails({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  List<ProductStock> products = [];
  final ScrollController _scrollController = ScrollController();
  LocationController locationController = LocationController();
  double counter = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadStockData(widget.location);
  }

  Future<void> loadStockData(Location location) async {
    List<ProductStock> result =
        await locationController.getProductsInSpecificLocation(location);
    setState(() {
      products = result;
    });
    calculateTotalQuantity();
  }

  void calculateTotalQuantity() {
    counter = 0;
    for (ProductStock product in products) {
      counter += product.quantity;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xFF0F171A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with location name and edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.location.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.white),
                ),
                CustomButton(
                  text: 'Edit',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditLocation(location: widget.location);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 25),
            
            // Main content - split into two columns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Location information
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 440,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A3B44),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location Information",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          _buildBasicInfo("NAME", widget.location.name),
                          SizedBox(height: 10),
                          _buildBasicInfo("ADDRESS", widget.location.address),
                          SizedBox(height: 10),
                          _buildBasicInfo("COUNTRY", widget.location.country),
                          SizedBox(height: 10),
                          _buildBasicInfo("CITY", widget.location.city),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 440,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A3B44),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location Status",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          _buildBasicInfo("TYPE", "Warehouse"),
                          SizedBox(height: 10),
                          _buildBasicInfo("TOTAL PRODUCTS", products.length.toString()),
                          SizedBox(height: 10),
                          _buildBasicInfo("TOTAL ITEMS", counter.toInt().toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Right column - Product Stock
                Container(
                  width: 280,
                  height: 350,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A3B44),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: Colors.white),
                      ),
                      SizedBox(height: 25),
                      Expanded(
                        child: Container(
                          width: 240,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF0F171A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL PRODUCT QUANTITY",
                                style: const TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${counter.toInt()}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    color: Colors.white),
                              ),
                              Expanded(
                                child: products.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No products at this location",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12),
                                        ),
                                      )
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        controller: _scrollController,
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            return _buildProductStock(products[index]);
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductStock(ProductStock productStock) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  productStock.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10),
              Text(
                productStock.quantity.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              )
            ],
          ),
          Divider(thickness: 0.5, color: Color(0xFF6C6B6B)),
        ],
      ),
    );
  }
}

Widget _buildBasicInfo(String title, String value) {
  return Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8A8A8A),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      SizedBox(width: 10),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      )
    ],
  );
}