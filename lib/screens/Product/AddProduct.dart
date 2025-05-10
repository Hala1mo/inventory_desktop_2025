import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/productContorller.dart';
import '../../models/LocationStock.dart';
import '../../models/Product.dart';
import '../../providers/ProductsListProvider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomButton2.dart';
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
              (e) => e.name.toLowerCase() == _selectedCategory!.toLowerCase()

    );
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
    });

    try {
     bool success= await productController.addProduct(newProduct);

      if (success) {
        Provider.of<ProductsListProvider>(context, listen: false)
            .addProduct(newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft ? 'Product saved as draft' : 'Product saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, newProduct);
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
                  child: _buildTextField(
                    controller: _nameController,
                    label: 'Product Name',
                    hint: 'Enter product name',
                    icon: Icons.shopping_bag,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
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
                  child: _buildTextField(
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
                  child:DropDown(
                  label: "Categories",
                  hint: "Select Category",
                  icon: Icons.category_outlined,
                  items: _categories.map((e) => e.label).toList(),
                  selectedItem: _selectedCategory != null
                      ? ProductCategory.values
                      .firstWhere((e) => e.name == _selectedCategory)
                      .label
                      : null,
                  onChanged: (String? selectedLabel) {
                    if (selectedLabel != null) {
                      final matched = ProductCategory.values.firstWhere(
                              (e) => e.label.toLowerCase() == selectedLabel.toLowerCase());
                      setState(() {
                        _selectedCategory = matched.name; // Store enum.name
                      });
                    }
                  },
                ),
                ),
              ],
            ),

            SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Descriptions',
              hint: 'Enter product description',
              maxLines: 4,
              icon: Icons.info,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildTextField(
                controller: _imageURLController,
                label: 'Image URL',
                hint: 'Enter image url',
                icon: Icons.photo,
                maxLines: 1,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton2(
                  text: 'Save as draft',
                  onPressed: () => saveProduct(isDraft: true),
                ),
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