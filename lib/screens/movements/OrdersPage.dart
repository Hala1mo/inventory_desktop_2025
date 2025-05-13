import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_desktop/models/ProductMovement.dart';
import 'package:inventory_desktop/widgets/MovementCard.dart';
import 'package:provider/provider.dart';
import '../../controllers/productMovementController.dart';
import '../../providers/MovementListProvider.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/MovementsFilter.dart';
import 'AddMovement.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();
  ProductMovementController movementController = ProductMovementController();
  bool isLoading = true;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<ProductMovement> movements = await movementController.getMovements();
      Provider.of<MovementListProvider>(context, listen: false)
          .setMovements(movements);
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading movements: $e");
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      SizedBox(width: 5),
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
                                text: "${provider.filteredCount}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: " of ${provider.allCount} Movements",
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
                      final List<ProductMovement> displayedMovements =
                          provider.filteredLocations;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MovementFilters(),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Scrollbar(
                                  controller: _scrollController,
                                  child: displayedMovements.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No movements found',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.builder(
                                          controller: _scrollController,
                                          itemCount: displayedMovements.length,
                                          itemBuilder: (context, index) {
                                            return MovementCard(
                                                movement:
                                                    displayedMovements[index]);
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
              ),
            ),
    );
  }
}