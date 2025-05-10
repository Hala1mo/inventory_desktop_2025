import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/LocationController.dart';
import '../../controllers/productContorller.dart';
import '../../models/Location.dart';
import '../../models/Product.dart';
import '../../providers/LocationListProvider.dart';
import '../../providers/ProductsListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomButton2.dart';
import '../../widgets/DropDown.dart';
import '../../widgets/LocationDropDown.dart';


class AddLocation extends StatefulWidget {
  const AddLocation({
    Key? key,
  }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddLocation> {
  final TextEditingController _nameController = TextEditingController();

  final LocationController locationController = LocationController();
  bool _isLoading = false;

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
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

  Future<void> saveProduct({bool isDraft = false}) async {
    if (_nameController.text.isEmpty) {
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
      country: selectedCity!,
      city: selectedState!,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      bool success= await locationController.addLocation(newLocation);

      if (success) {
        Provider.of<LocationListProvider>(context, listen: false)
            .addLocation(newLocation);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft ? 'Product saved as draft' : 'Product saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, newLocation);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        height: MediaQuery.of(context).size.height * 0.55,
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
            SizedBox(height: 12),
            Expanded(
              child: _buildTextField(
                controller: _nameController,
                label: 'Location Name',
                hint: 'Enter location name',
                icon: Icons.shopping_bag,
              ),
            ),
            LocationDropdown(
              items: countries,
              labelText:  'Country',
              selectedItem: selectedCountry,
              onChanged: onCountryChanged,
              showSearchBox: true,
              maxHeight: 300,
              hintText: "Search Country...",

            ),
            SizedBox(height: 12),
            LocationDropdown(
              items: states,
              labelText:  'City',
              selectedItem: selectedState,
              onChanged: onStateChanged,
              showSearchBox: true,
              maxHeight: 300,
              hintText: "Search City...",
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: _buildTextField(
            //         controller: _nameController,
            //         label: 'Product Name',
            //         hint: 'Enter product name',
            //         icon: Icons.shopping_bag,
            //       ),
            //     ),
            //     SizedBox(width: 20),
            //     Expanded(
            //       child: _buildTextField(
            //         controller: ,
            //         label: 'Product Code',
            //         hint: 'Enter product code',
            //         icon: Icons.qr_code,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),


            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Save Location',
                  onPressed: () => saveProduct(isDraft: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefix,
    int? maxLines,
  }) {
    final isMultiline = maxLines != null && maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A262D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: isMultiline
              ? Stack(
            children: [
              TextFormField(
                maxLines: maxLines,
                controller: controller,
                keyboardType: keyboardType ?? TextInputType.multiline,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 50,
                    right: 15,
                    top: 15,
                    bottom: 15,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 15,
                child: Icon(
                  icon,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ),
            ],
          )
              : Row(
            children: [
              if (prefix != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    prefix,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: prefix != null ? 0 : 15,
                      vertical: 15,
                    ),
                    prefixIcon: prefix == null
                        ? Icon(icon, color: Colors.grey[400], size: 20)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}