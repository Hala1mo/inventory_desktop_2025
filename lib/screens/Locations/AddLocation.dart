import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/LocationController.dart';
import '../../models/Location.dart';
import '../../providers/LocationListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/LocationDropDown.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({
    Key? key,
  }) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final LocationController locationController = LocationController();
  bool _isLoading = false;
  String? errorMessage;
  String? selectedCountry;
  String? selectedState;
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  List<dynamic> countriesData = [];
  List<dynamic> statesData = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> loadCountries() async {
    final String data =
        await rootBundle.loadString('assets/countries+states+cities.json');
    final List<dynamic> jsonData = json.decode(data);
    setState(() {
      countriesData = jsonData;
      countries = jsonData
          .map<String>((country) => country['name'].toString())
          .toList();
    });
  }

  void onCountryChanged(String? value) {
    setState(() {
      selectedCountry = value;
      selectedState = null;

      final countryData = countriesData.firstWhere(
        (country) => country['name'] == value,
        orElse: () => null,
      );

      if (countryData != null && countryData['states'] != null) {
        states = (countryData['states'] as List<dynamic>)
            .map<String>((state) => state['name'].toString())
            .toList();
      } else {
        states = [];
      }
    });
  }

  void onStateChanged(String? value) {
    setState(() {
      selectedState = value;
    });
  }

  Future<void> saveLocation() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        selectedCountry == null ||
        selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Location newLocation = Location(
      name: _nameController.text,
      address: _addressController.text,
      country: selectedCountry!,
      city: selectedState!,
    );

    setState(() {
      _isLoading = true;
      errorMessage=null;
    });

    try {
      final result = await locationController.addLocation(newLocation);

      if (result['success']) {
        Provider.of<LocationListProvider>(context, listen: false)
            .addLocation(newLocation);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, newLocation);
    } else {
        setState(() {
          errorMessage = result['error'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xFF0F171A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Location Name',
                    hint: 'Enter location name',
                    icon: Icons.location_city,
                  ),
                  SizedBox(height: 16),
                  LocationDropdown(
                    items: countries,
                    labelText: 'Country',
                    selectedItem: selectedCountry,
                    onChanged: onCountryChanged,
                    showSearchBox: true,
                    maxHeight: 300,
                    hintText: "Search Country...",
                  ),
                  SizedBox(height: 16),
                  LocationDropdown(
                    items: states,
                    labelText: 'State/City',
                    selectedItem: selectedState,
                    onChanged: onStateChanged,
                    showSearchBox: true,
                    maxHeight: 300,
                    hintText: "Search State/City...",
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _addressController,
                      label: 'Location Address',
                      hint: 'Enter location address',
                      icon: Icons.pin_drop_outlined,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 5),
                    if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Save Location',
                        onPressed: () => saveLocation(),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
