import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/LocationListProvider.dart';

class LocationFilters extends StatefulWidget {
  const LocationFilters({Key? key}) : super(key: key);

  @override
  State<LocationFilters> createState() => _LocationFiltersState();
}

class _LocationFiltersState extends State<LocationFilters> {
  String selectedSort = 'A-Z';
  String? selectedCountry;
  String? selectedCity;
  bool isLoading = true;

  // Data for dropdowns
  List<String> countries = [];
  List<String> cities = [];
  List<dynamic> countriesData = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load countries from JSON file
      final String data = await rootBundle.loadString('assets/countries+states+cities.json');
      final List<dynamic> jsonData = json.decode(data);

      // Extract countries list
      setState(() {
        countriesData = jsonData;
        countries = ['All', ...jsonData.map<String>((country) => country['name'].toString())];
        isLoading = false;
      });
    } catch (e) {
      print("Error loading countries data: $e");
      
      // Fallback to provider data if JSON fails
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          final provider = Provider.of<LocationListProvider>(context, listen: false);
          setState(() {
            countries = provider.uniqueCountries;
            cities = provider.uniqueCities;
            isLoading = false;
          });
        }
      });
    }
  }

  // Update cities when country changes
  void updateCitiesForCountry(String? countryName) {
    if (countryName == null || countryName == 'All') {
      // If 'All' is selected, get all cities from provider
      final provider = Provider.of<LocationListProvider>(context, listen: false);
      setState(() {
        cities = provider.uniqueCities;
      });
      return;
    }

    // Find the selected country in country data
    final countryData = countriesData.firstWhere(
      (country) => country['name'] == countryName,
      orElse: () => null,
    );

    if (countryData != null && countryData['states'] != null) {
      // Collect all cities from all states
      List<String> allCities = ['All'];
      
      for (var state in countryData['states']) {
        if (state['cities'] != null) {
          allCities.addAll((state['cities'] as List).map<String>((city) => city['name'].toString()));
        }
      }

      setState(() {
        cities = allCities;
        selectedCity = 'All'; // Reset city selection when country changes
      });
    } else {
      setState(() {
        cities = ['All'];
        selectedCity = 'All';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1A262D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('SORT'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedSort,
              items: ['A-Z', 'Z-A'],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSort = value;
                  });
                  Provider.of<LocationListProvider>(context, listen: false)
                      .filterLocations(sortAlpha: value);
                }
              },
              icon: Icons.sort,
              hintText: 'Sort Alphabetically',
            ),
            
            const SizedBox(height: 20),
            _buildSectionTitle('COUNTRY'),
            const SizedBox(height: 8),
            isLoading 
              ? _buildLoadingDropdown('Loading countries...')
              : _buildDropdown(
                  value: selectedCountry,
                  items: countries,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                    
                    // Update cities list based on selected country
                    updateCitiesForCountry(value);
                    
                    // Apply filtering
                    Provider.of<LocationListProvider>(context, listen: false)
                        .filterLocations(country: value);
                  },
                  icon: Icons.flag_outlined,
                  hintText: 'Select Country',
                ),
            
            const SizedBox(height: 20),
            _buildSectionTitle('CITY'),
            const SizedBox(height: 8),
            isLoading 
              ? _buildLoadingDropdown('Loading cities...')
              : _buildDropdown(
                  value: selectedCity,
                  items: cities,
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                    Provider.of<LocationListProvider>(context, listen: false)
                        .filterLocations(city: value);
                  },
                  icon: Icons.location_city_outlined,
                  hintText: 'Select City',
                ),
            
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedSort = 'A-Z';
                  selectedCountry = 'All';
                  selectedCity = 'All';
                  
              
                  final provider = Provider.of<LocationListProvider>(context, listen: false);
                  cities = provider.uniqueCities;
                });
                Provider.of<LocationListProvider>(context, listen: false).clearFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A3B44),
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                minimumSize: const Size(280, 60),
              ),
              child: Text(
                "Clear Filters",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF8A8A8A),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A3B44),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String hintText,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2A3B44),
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 18,
          iconEnabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 260,
          decoration: BoxDecoration(
            color: Color(0xFF1A262D),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        style: const TextStyle(color: Colors.white),
        hint: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              hintText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}