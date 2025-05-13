import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/productContorller.dart';
import '../../models/Product.dart';
import '../../providers/ProductsListProvider.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/ProductCard.dart';
import '../../widgets/ProductFilter.dart';
import 'AddProduct.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  ProductController productController = ProductController();
  Map<String, dynamic> currentFilters = {
    'status': 'All',
    'category': 'All',
    'price': 'All',
  };

  Future<void> loadData() async {
    List<Product> products = await productController.getProducts();
    Provider.of<ProductsListProvider>(context, listen: false)
        .setProducts(products);
    print(products);
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
                    SizedBox(
                      width: 5,
                    ),
                    Consumer<ProductsListProvider>(
                      builder: (context, provider, _) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: "${provider.allCount}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "  Total Product",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Spacer(),
                    CustomButton(
                      text: 'Add Product',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddProduct();
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<ProductsListProvider>(
                  builder: (context, provider, child) {
                    final List<Product> displayedProducts =
                        provider.filteredProducts; // or apply filters here

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductFilters(), // your filter widget
                            const SizedBox(width: 16),
                            Expanded(
                              child: Scrollbar(
                                controller: _scrollController,
                                child: displayedProducts.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No products found',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: _scrollController,
                                        itemCount: displayedProducts.length,
                                        itemBuilder: (context, index) {
                                          return ProductCard(
                                              product:
                                                  displayedProducts[index]);
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )));
  }
}
