
import 'package:flutter/material.dart';
import 'package:inventory_desktop/screens/Product/EditProduct.dart';

import '../../controllers/productContorller.dart';

import '../../models/Product.dart';
import '../../models/ProductBalance.dart';
import '../../widgets/CustomButton.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductDetails> {
  List<ProductBalance> balances = [];
  final ScrollController _scrollController = ScrollController();
  ProductController productController =
      ProductController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();

    loadStockData(widget.product);
  }

  double counter = 0;

  Future<void> loadStockData(Product product) async {
    List<ProductBalance> result =
        await productController.fetchStockData(product);
    setState(() {
      balances = result;
    });
    load();
  }

  void load() {
    for (ProductBalance balance in balances) {
      counter += balance.quantity;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xFF0F171A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomButton(
                      text: 'Edit',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditProduct(product: widget.product);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 470,
                        height: 350,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: widget.product.imageUrl != null
                            ? widget.product.imageUrl!.startsWith('http')
                                ? Image.network(
                                    widget.product.imageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          size: 40),
                                    ),
                                  )
                                : Image.asset(
                                    widget.product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          size: 40),
                                    ),
                                  )
                            : const Icon(
                                Icons.image_not_supported,
                                size: 30,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Basic Information",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    _buildBasicInfo("CATEGORY", widget.product.category.name),
                    SizedBox(height: 10),
                    _buildBasicInfo("CODE", widget.product.code),
                    SizedBox(height: 10),
                    _buildBasicInfo("DESCRIPTION", widget.product.description),
                    SizedBox(height: 10),
                    _buildBasicInfo("PRICE", widget.product.price.toString()),
                  ],
                ),
                Container(
                    width: 280,
                    height: 350,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A3B44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.white),
                        ),
                        SizedBox(height: 25),
                        Expanded(
                          child: Container(
                            width: 280,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF0F171A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "QUANTITY AT HAND",
                                  style: const TextStyle(
                                    color: Color(0xFF8A8A8A),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "$counter",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: balances.length,
                                      itemBuilder: (context, index) {
                                        return _buildStock(balances[index]);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
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

Widget _buildStock(ProductBalance productBalance) {
  return Padding(
    padding: EdgeInsets.only(top: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              productBalance.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 10),
            Text(
              productBalance.quantity.toString(),
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
