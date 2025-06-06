import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_desktop/controllers/LocationController.dart';
import 'package:provider/provider.dart';

import '../../models/Location.dart';
import '../../providers/LocationListProvider.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/LocationCard.dart';
import '../../widgets/LocationFilters.dart'; // Import the new LocationFilters widget
import 'AddLocation.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final ScrollController _scrollController = ScrollController();
  LocationController locationController = LocationController();
  bool isLoading = true;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      List<Location> locations = await locationController.getLocations();
      Provider.of<LocationListProvider>(context, listen: false)
          .setLocations(locations);
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading locations: $e");
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
      appBar: const CustomAppBar(currentPage: 'location'),
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
                        "Locations",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 5),
                      Consumer<LocationListProvider>(
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
                                    text: " of ${provider.allCount} Locations",
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
                        text: 'Add Location',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddLocation();
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Consumer<LocationListProvider>(
                    builder: (context, provider, child) {
                      final List<Location> displayedLocations =
                          provider.filteredLocations;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add the location filters component
                              LocationFilters(),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Scrollbar(
                                  controller: _scrollController,
                                  child: displayedLocations.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No Locations found',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.builder(
                                          controller: _scrollController,
                                          itemCount: displayedLocations.length,
                                          itemBuilder: (context, index) {
                                            return LocationCard(
                                                location: displayedLocations[index]);
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