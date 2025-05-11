// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../controllers/productContorller.dart';
// import '../../models/Product.dart';
// import '../../providers/ProductsListProvider.dart';
// import '../../widgets/CustomButton.dart';
// import '../../widgets/CustomButton2.dart';
// import '../../widgets/DeleteButton.dart';
// import '../../widgets/DropDown.dart';
//
// class EditLocation extends StatefulWidget {
//   final Location location;
//
//   const EditLocation({
//     Key? key,
//     required this.location,
//   }) : super(key: key);
//
//   @override
//   _EditLocationState createState() => _EditLocationState();
// }
//
// class _EditLocationState extends State<EditLocation> {
//   late TextEditingController _nameController;
//   late TextEditingController _addressController;
//
//
//
//   Future<void> loadCountries() async {
//     final String data =
//     await rootBundle.loadString('assets/countries+states+cities.json');
//     final List<dynamic> jsonData = json.decode(data);
//     setState(() {
//       countriesData = jsonData;
//       countries = jsonData
//           .map<String>((country) => country['name'].toString())
//           .toList();
//     });
//   }
//
//   void onCountryChanged(String? value) {
//     setState(() {
//       selectedCountry = value;
//       selectedState = null;
//
//       final countryData = countriesData.firstWhere(
//             (country) => country['name'] == value,
//         orElse: () => null,
//       );
//
//       if (countryData != null && countryData['states'] != null) {
//         states = (countryData['states'] as List<dynamic>)
//             .map<String>((state) => state['name'].toString())
//             .toList();
//       } else {
//         states = [];
//       }
//     });
//   }
//
//   void onStateChanged(String? value) {
//     setState(() {
//       selectedState = value;
//     });
//   }
//
//   String? _selectedCategory;
//   final LocationController locationController = LocationController();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with existing product data
//     _nameController = TextEditingController(text: widget.product.name);
//     _priceController =
//         TextEditingController(text: widget.product.price.toString());
//     _codeController = TextEditingController(text: widget.product.code);
//     _descriptionController =
//         TextEditingController(text: widget.product.description);
//     _imageURLController = TextEditingController(text: widget.product.imageUrl);
//     _selectedCategory = widget.product.category.name;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//
//     super.dispose();
//   }
//
//   Future<void> updateProduct({bool isDraft = false}) async {
//     if (_nameController.text.isEmpty ||
//         _addressController.text.isEmpty ||
//    ) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please fill all fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//

// Location updatedLocation = Location(
//   name: _nameController.text,
//   address: _addressController.text,
//   country: selectedState!,
//   city: selectedState!,
// );
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       bool success = await locationController.updateLocation(updatedLocation);
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Location updated successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         Navigator.pop(context, updatedProduct);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating product: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> deleteLocation(Location location) async {
//     try {
//       bool success = await locationController.deleteLocation(location);
//
//       if (success) {
//         Provider.of<LocationsListProvider>(context, listen: false)
//             .removeLocation(location);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Location is deleted '),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error deleting product: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.all(20),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.5,
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//         decoration: BoxDecoration(
//           color: Color(0xFF0F171A),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: _isLoading
//             ? Center(
//           child: CircularProgressIndicator(color: Colors.white),
//         )
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Edit Location',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//
//
//                 Expanded(
//                   child: _buildTextField(
//                     controller: _nameController,
//                     label: 'Location Name',
//                     hint: 'Enter product name',
//                     icon: Icons.shopping_bag,
//                   ),
//                 ),
//
//
//             SizedBox(height: 20),
//             _buildTextField(
//               controller: _descriptionController,
//               label: 'Descriptions',
//               hint: 'Enter product description',
//               maxLines: 4,
//               icon: Icons.info,
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: _buildTextField(
//                 controller: _imageURLController,
//                 label: 'Image URL',
//                 hint: 'Enter image url',
//                 icon: Icons.photo,
//                 maxLines: 1,
//               ),
//             ),
//             SizedBox(height: 5),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 DeleteButton(
//                   text: 'Delete Location',
//                   onPressed: () => deleteLocation(widget.product),
//                 ),
//                 SizedBox(width: 15),
//                 CustomButton(
//                   text: 'Update Product',
//                   onPressed: () => updateLocation(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? prefix,
//     int? maxLines,
//   }) {
//     final isMultiline = maxLines != null && maxLines > 1;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[400],
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Color(0xFF1A262D),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade800),
//           ),
//           child: isMultiline
//               ? Stack(
//             children: [
//               TextFormField(
//                 maxLines: maxLines,
//                 controller: controller,
//                 keyboardType: keyboardType ?? TextInputType.multiline,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: hint,
//                   hintStyle: TextStyle(color: Colors.grey[500]),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.only(
//                     left: 50,
//                     right: 15,
//                     top: 15,
//                     bottom: 15,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 15,
//                 top: 15,
//                 child: Icon(
//                   icon,
//                   color: Colors.grey[400],
//                   size: 20,
//                 ),
//               ),
//             ],
//           )
//               : Row(
//             children: [
//               if (prefix != null)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   child: Text(
//                     prefix,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               Expanded(
//                 child: TextFormField(
//                   controller: controller,
//                   keyboardType: keyboardType,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     hintStyle: TextStyle(color: Colors.grey[500]),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: prefix != null ? 0 : 15,
//                       vertical: 15,
//                     ),
//                     prefixIcon: prefix == null
//                         ? Icon(icon, color: Colors.grey[400], size: 20)
//                         : null,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
