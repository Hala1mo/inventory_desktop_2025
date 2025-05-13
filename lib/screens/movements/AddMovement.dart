import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_desktop/models/Product.dart';
import 'package:provider/provider.dart';

import '../../controllers/LocationController.dart';
import '../../controllers/productContorller.dart';
import '../../controllers/productMovementController.dart';
import '../../models/Location.dart';
import '../../models/ProductMovement.dart';
import '../../providers/MovementListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/DropDown.dart';
import '../../widgets/LocationDropDownList.dart';
import '../../widgets/ProductDropDown.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({
    super.key,
  });

  @override
  _AddMovementState createState() => _AddMovementState();
}

class _AddMovementState extends State<AddMovement> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final LocationController locationController = LocationController();
  final ProductController productController = ProductController();
  final ProductMovementController movementController =
      ProductMovementController();
  final List<MovementType> movementTypes = MovementType.values;
  bool _isLoading = false;
  String? errorMessage;
  String? _selectedMovement;
  Location? selectedToLocation;
  Location? selectedFromLocation;
  Product? selectedProduct;
  List<Product> productsData = [];
  List<Location> locationsData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> products = await productController.getProducts();
      List<Location> locations = await locationController.getLocations();

      setState(() {
        productsData = products;
        locationsData = locations;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
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
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> saveProductMovement() async {
    if (selectedProduct == null ||
        _selectedMovement == null ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate quantity
    int quantity;
    try {
      quantity = int.parse(_quantityController.text);
      if (quantity <= 0) {
        throw FormatException('Quantity must be greater than zero');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid positive quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    MovementType moveType =
        MovementType.values.firstWhere((e) => e.name == _selectedMovement);

    if (moveType == MovementType.IN && selectedToLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a destination location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (moveType == MovementType.OUT && selectedFromLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a source location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (moveType == MovementType.TRANSFER &&
        (selectedFromLocation == null || selectedToLocation == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both source and destination locations'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (moveType == MovementType.TRANSFER &&
        selectedFromLocation == selectedToLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Source and destination cannot be the same'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      ProductMovement movementData = ProductMovement(
        movementType: moveType,
        quantity: quantity,
        notes: notesController.text,
        product: selectedProduct!,
        fromLocation: selectedFromLocation,
        toLocation: selectedToLocation,
      );

      final result = await movementController.addMovement(movementData);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product movement saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Provider.of<MovementListProvider>(context, listen: false)
            .addMovements(movementData);
        Navigator.pop(context);
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
    // Determine which movement type is selected
    MovementType? moveType;
    if (_selectedMovement != null) {
      moveType =
          MovementType.values.firstWhere((e) => e.name == _selectedMovement);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.78,
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
                        'Add New Product Movement',
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

                  // Movement Type Dropdown
                  DropDown(
                    label: "Movement Type",
                    hint: "Select Movement Type",
                    icon: Icons.swap_horiz,
                    items: MovementType.values.map((e) => e.label).toList(),
                    selectedItem: _selectedMovement != null
                        ? MovementType.values
                            .firstWhere((e) => e.name == _selectedMovement)
                            .label
                        : null,
                    onChanged: (String? selectedLabel) {
                      if (selectedLabel != null) {
                        final matched = MovementType.values.firstWhere((e) =>
                            e.label.toLowerCase() ==
                            selectedLabel.toLowerCase());
                        setState(() {
                          _selectedMovement = matched.name;
                          if (matched != MovementType.TRANSFER) {
                            if (matched == MovementType.IN) {
                              selectedFromLocation = null;
                            } else if (matched == MovementType.OUT) {
                              selectedToLocation = null;
                            }
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),

                  // Product Dropdown
                  ProductDropDown(
                    items: productsData,
                    label: 'Product',
                    selectedItem: selectedProduct,
                    icon: Icons.inventory,
                    hint: "Select Product",
                    onChanged: (Product? product) {
                      setState(() {
                        selectedProduct = product;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  CustomTextField(
                    controller: _quantityController,
                    label: 'Quantity',
                    hint: 'Enter quantity',
                    icon: Icons.numbers,
                    inputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 16),
                  if (moveType == MovementType.OUT ||
                      moveType == MovementType.TRANSFER)
                    Column(
                      children: [
                        LocationDropDownList(
                          items: locationsData,
                          label: 'From Location',
                          selectedItem: selectedFromLocation,
                          icon: Icons.location_on_outlined,
                          hint: "Select Source Location",
                          onChanged: (Location? loc) {
                            setState(() {
                              selectedFromLocation = loc;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  if (moveType == MovementType.IN ||
                      moveType == MovementType.TRANSFER)
                    Column(
                      children: [
                        LocationDropDownList(
                          items: locationsData,
                          label: 'Destination Location',
                          selectedItem: selectedToLocation,
                          icon: Icons.location_on,
                          hint: "Select Destination Location",
                          onChanged: (Location? loc) {
                            setState(() {
                              selectedToLocation = loc;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  SizedBox(height: 5),
                  Expanded(
                    child: CustomTextField(
                      controller: notesController,
                      label: 'Notes',
                      hint: 'Add any additional information or remarks...',
                      icon: Icons.notes,
                      maxLines: 3,
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

                  // Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Save Product Movement',
                        onPressed: saveProductMovement,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
