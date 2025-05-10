import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';
import '../widgets/ProductFilter.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsPage> {


  Map<String, dynamic> currentFilters = {
    'status': 'All',
    'category': 'All',
    'price': 'All',
  };

  void _handleFiltersChange(Map<String, dynamic> filters) {
    setState(() {
      currentFilters = filters;
    });

    // Apply filters to your product list
    print('Applied filters: $filters');
    // Example: fetchFilteredProducts(filters);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Color(0xFF0F171A),
        appBar: const CustomAppBar(currentPage: 'inventory'),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "500",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "  total product",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            Spacer(),
                    CustomButton(text: 'Add Product', onPressed: () { },),

                  ],
                ),
                const SizedBox(height: 16),

                ProductFilters(


        ),
              ],
            )));
  }
}
