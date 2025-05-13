import 'package:flutter/material.dart';
import 'package:inventory_desktop/screens/Locations/AddLocation.dart';
import 'package:inventory_desktop/screens/Product/AddProduct.dart';
import 'package:inventory_desktop/screens/movements/AddMovement.dart';
import 'package:provider/provider.dart';

import '../providers/DashboardProvider.dart';
import '../widgets/CategoryPieChart.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';
import '../widgets/LocationBarChart.dart';
import '../widgets/QuickActionDropDown.dart';
import '../widgets/StatsTileCrad.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  void _showAddLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddLocation();
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProduct();
      },
    );
  }

  void _showAddMovementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMovement();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F171A),
      appBar: const CustomAppBar(currentPage: 'dashboard'),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadData(),
                    child: Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A2226),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadData,
            color: Colors.white,
            backgroundColor: Color(0xFF1A2226),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 5),
                        Spacer(),
                        QuickActionDropdown(
                          onAddLocation: () => _showAddLocationDialog(context),
                          onAddProduct: () => _showAddProductDialog(context),
                          onAddMovement: () => _showAddMovementDialog(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Stats Tiles
                    Row(
                      children: [
                        Expanded(
                          child: StatsTileCard(
                            icon: Icons.inventory_2,
                            title: 'TOTAL PRODUCT IN INVENTORY',
                            value: provider
                                .getStatValue(provider.stats.totalInventory),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatsTileCard(
                            icon: Icons.pin_drop,
                            title: "TOTAL LOCATIONS",
                            value: provider
                                .getStatValue(provider.stats.totalLocations),
                            iconBackgroundColor: const Color(0xFF283447),
                            iconColor: Colors.blue.shade300,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatsTileCard(
                            icon: Icons.swap_horiz,
                            title: 'TOTAL TRANSFER MOVEMENTS',
                            value: provider
                                .getStatValue(provider.stats.transferMovements),
                            iconBackgroundColor: const Color(0xFF332828),
                            iconColor: Colors.red.shade300,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatsTileCard(
                            icon: Icons.arrow_upward,
                            title: 'TOTAL OUTGOING MOVEMENTS',
                            value: provider
                                .getStatValue(provider.stats.outMovements),
                            iconBackgroundColor: const Color(0xFF28332F),
                            iconColor: Colors.green.shade300,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatsTileCard(
                            icon: Icons.arrow_downward,
                            title: 'TOTAL INCOMING MOVEMENTS',
                            value: provider
                                .getStatValue(provider.stats.inMovements),
                            iconBackgroundColor: const Color(0xFF33322A),
                            iconColor: Colors.amber.shade300,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // Charts
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CategoryPieChart(
                              distribution: provider.distribution),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: LocationBarChart(
                            locationCounts: provider.locationCounts,
                            title: 'Product Quantity by Location',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
