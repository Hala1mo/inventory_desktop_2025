import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_desktop/models/ProductMovement.dart';
import 'package:inventory_desktop/widgets/MovementCard.dart';
import 'package:provider/provider.dart';
import '../controllers/productMovementController.dart';
import '../providers/MovementListProvider.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';
import 'movements/AddMovement.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();
  ProductMovementController movementController = ProductMovementController();
 

  Future<void> loadData() async {
    List<ProductMovement> movements = await movementController.getMovements();
    Provider.of<MovementListProvider>(context, listen: false)
        .setMovements(movements);
    print(movements);
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
        appBar: const CustomAppBar(currentPage: 'order'),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Movements",
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
                    Consumer<MovementListProvider>(
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
                                  text: "  Total Movements",
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
                      text: 'Add Movement',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddMovement();
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<MovementListProvider>(
                  builder: (context, provider, child) {
                    final List<ProductMovement> displayedProducts =
                        provider.filteredLocations;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           // ProductFilters(),
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
                                          return MovementCard(
                                              movement:
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