import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/productContorller.dart';
import '../../models/Product.dart';
import '../../providers/ProductsListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/DropDown.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
  }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  String? errorMessage;
  String? _selectedCategory;
  final List<ProductCategory> _categories = ProductCategory.values;
  final ProductController productController = ProductController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveProduct({bool isDraft = false}) async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double? price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ProductCategory category;
    try {
      category = ProductCategory.values.firstWhere(
          (e) => e.name.toLowerCase() == _selectedCategory!.toLowerCase());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid category selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print(category);
    // Create Product object
    Product newProduct = Product(
      code: _codeController.text,
      name: _nameController.text,
      price: price,
      description: _descriptionController.text,
      category: category,
      imageUrl: _imageURLController.text,
      status: isDraft ? ProductStatus.DRAFT : ProductStatus.ACTIVE,
    );

    setState(() {
      _isLoading = true;
       errorMessage = null;
    });

    try {

        final result= await productController.addProduct(newProduct);

      if (result['success']) {

      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft
                ? 'Product saved as draft'
                : 'Product saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

          Product addedProduct =
            result.containsKey('data') ? result['data'] : newProduct;

         Provider.of<ProductsListProvider>(context, listen: false)
            .addProduct(addedProduct);

        Navigator.pop(context, newProduct);
      }
      else {
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
        height: MediaQuery.of(context).size.height * 0.8,
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
                        'Add New Product',
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _nameController,
                          label: 'Product Name',
                          hint: 'Enter product name',
                          icon: Icons.shopping_bag,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          controller: _codeController,
                          label: 'Product Code',
                          hint: 'Enter product code',
                          icon: Icons.qr_code,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _priceController,
                          label: 'Price',
                          hint: 'Enter price',
                          icon: Icons.attach_money,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          prefix: '\$',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: DropDown(
                          label: "Categories",
                          hint: "Select Category",
                          icon: Icons.category_outlined,
                          items: _categories.map((e) => e.label).toList(),
                          selectedItem: _selectedCategory != null
                              ? ProductCategory.values
                                  .firstWhere(
                                      (e) => e.name == _selectedCategory)
                                  .label
                              : null,
                          onChanged: (String? selectedLabel) {
                            if (selectedLabel != null) {
                              final matched = ProductCategory.values.firstWhere(
                                  (e) =>
                                      e.label.toLowerCase() ==
                                      selectedLabel.toLowerCase());
                              setState(() {
                                _selectedCategory =
                                    matched.name; // Store enum.name
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Descriptions',
                    hint: 'Enter product description',
                    maxLines: 4,
                    icon: Icons.info,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: CustomTextField(
                      controller: _imageURLController,
                      label: 'Image URL',
                      hint: 'Enter image url',
                      icon: Icons.photo,
                      maxLines: 1,
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
                      SizedBox(width: 15),
                      CustomButton(
                        text: 'Save Product',
                        onPressed: () => saveProduct(isDraft: false),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
