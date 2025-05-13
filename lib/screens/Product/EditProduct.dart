import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/productContorller.dart';
import '../../models/Product.dart';
import '../../providers/ProductsListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomButton2.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/DeleteButton.dart';
import '../../widgets/DropDown.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  const EditProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageURLController;

  String? _selectedCategory;
  final List<ProductCategory> _categories = ProductCategory.values;
  final ProductController productController = ProductController();
  bool _isLoading = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product data
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _codeController = TextEditingController(text: widget.product.code);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _imageURLController = TextEditingController(text: widget.product.imageUrl);
    _selectedCategory = widget.product.category.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  Future<void> updateProduct({bool isDraft = false}) async {
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

    Product updatedProduct = Product(
      id: widget.product.id,
      code: _codeController.text,
      name: _nameController.text,
      price: price,
      description: _descriptionController.text,
      category: category,
      imageUrl: _imageURLController.text,
      status: isDraft ? ProductStatus.DRAFT : ProductStatus.ACTIVE,
      createdAt: widget.product.createdAt,
    );

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await productController.updateProduct(updatedProduct);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft
                ? 'Product saved as draft'
                : 'Product updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        ProductsListProvider provider =
            Provider.of<ProductsListProvider>(context, listen: false);
        provider.updateLocation(updatedProduct);

        Navigator.pop(context, updatedProduct);
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

  Future<void> deleteProduct(Product product) async {
    try {
      final result = await productController.deleteProduct(product);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
          ProductsListProvider provider =
            Provider.of<ProductsListProvider>(context, listen: false);
        provider.removeProduct(product);

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
                        'Edit Product',
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
                                _selectedCategory = matched.name;
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
                      DeleteButton(
                        text: 'Delete Product',
                        onPressed: () => deleteProduct(widget.product),
                      ),
                      SizedBox(width: 15),
                      CustomButton(
                        text: 'Update Product',
                        onPressed: () => updateProduct(isDraft: false),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
