// import 'package:flutter/material.dart';
//
// class ProductFilters extends StatefulWidget {
//   final Function(Map<String, dynamic>) onFiltersChanged;
//   final Map<String, dynamic> initialFilters;
//
//   const ProductFilters({
//     Key? key,
//     required this.onFiltersChanged,
//     this.initialFilters = const {
//       'status': 'All',
//       //'category': 'All',
//       //'price': 'All',
//     },
//   }) : super(key: key);
//
//   @override
//   State<ProductFilters> createState() => _ProductFiltersState();
// }
//
// class _ProductFiltersState extends State<ProductFilters> {
//   late Map<String, dynamic> selectedFilters;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedFilters = Map<String, dynamic>.from(widget.initialFilters);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 280,
//       height: 600,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color:    Color(0xFF1A262D),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child:SingleChildScrollView(
//     child:Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Status Filter
//         _buildFilterSection(
//           title: 'PRODUCT STATUS',
//           filterType: 'status',
//           options: {
//             'All': '1708',
//             'Active': '1232',
//             'Inactive': '250',
//             'Draft': '36',
//           },
//         ),
//
//         const SizedBox(height: 16),
//
//         _buildSectionTitle('SORT BY'),
//         const SizedBox(height: 8),
//         _buildDropdownSelector(
//           icon: Icons.sort,
//           text: sortBy,
//           onTap: () {
//             // Show sort options dialog/dropdown
//           },
//         ),
//
//         const SizedBox(height: 16),
//
//
//       ],
//         ),
//         ),
//     );
//   }
//
//   Widget _buildFilterSection({
//     required String title,
//     required String filterType,
//     required Map<String, String> options,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Color(0xFF8A8A8A),
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: _buildGridLayout(filterType, options),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGridLayout(String filterType, Map<String, String> options) {
//     final List<MapEntry<String, String>> optionsList = options.entries.toList();
//     final List<Widget> rows = [];
//
//     for (int i = 0; i < optionsList.length; i += 2) {
//       final firstOption = optionsList[i];
//
//       // Create row with children
//       final List<Widget> rowChildren = [
//         // First filter chip (always exists)
//         Expanded(
//           child: _buildFilterChip(
//             filterType: filterType,
//             option: firstOption.key,
//             count: firstOption.value,
//           ),
//         ),
//
//         // Add spacing between options
//         const SizedBox(width: 8),
//
//         // Second filter chip (if exists)
//         if (i + 1 < optionsList.length)
//           Expanded(
//             child: _buildFilterChip(
//               filterType: filterType,
//               option: optionsList[i + 1].key,
//               count: optionsList[i + 1].value,
//             ),
//           )
//         else
//         // Empty space to maintain layout if odd number of options
//           Expanded(child: Container()),
//       ];
//
//       rows.add(
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Row(children: rowChildren),
//         ),
//       );
//     }
//
//     return Column(children: rows);
//   }
//   Widget _buildFilterChip({
//     required String filterType,
//     required String option,
//      String? count,
//   }) {
//     final isSelected = selectedFilters[filterType] == option;
//
//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedFilters[filterType] = option;
//         });
//         widget.onFiltersChanged(selectedFilters);
//       },
//       borderRadius: BorderRadius.circular(100),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         // Remove right padding since we're handling spacing in the row
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border.all(
//             color: isSelected
//                 ?  Color(0xFF00D563)
//                 : Colors.grey.shade800,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
//           children: [
//             Text(
//               option,
//               style: TextStyle(
//                 color:  Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if(count!=null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ?  Color(0xFF00D563).withOpacity(0.1)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 count,
//                 style: TextStyle(
//                   color: isSelected
//                       ? const Color(0xFF00D563)
//                       : Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildSectionTitle(String title) {
//   return Text(
//     title,
//     style: const TextStyle(
//       color: Color(0xFF8A8A8A),
//       fontSize: 12,
//       fontWeight: FontWeight.w500,
//       letterSpacing: 0.5,
//     ),
//   );
// }

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ProductFilters extends StatefulWidget {
  const ProductFilters({Key? key}) : super(key: key);

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  String selectedStatus = 'All';
  String selectedType = 'Retail';
  String sortBy = 'Alphabetical: A-Z';
  String stockAlert = 'All stock';
  String category = 'All stock';
  TextEditingController minPriceController = TextEditingController();
  String? selectedSort = 'A-Z';
  String? timeSort = 'Newest';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 600,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1A262D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Status
          _buildSectionTitle('PRODUCT STATUS'),
          const SizedBox(height: 8),
          _buildStatusGrid(),
          const SizedBox(height: 20),


          buildCustomDropdown(
            icon: Icons.sort,
            items: ['A-Z', 'Z-A'],
            selectedItem: selectedSort,
            labelText: 'ALPHABETICAL',
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedSort = value;
                });
                // Handle the sorting logic here
              }
            },
          ),
          const SizedBox(height: 20),
          buildCustomDropdown(
            icon: Icons.sort,
            items: ['Newest', 'Oldest'],
            selectedItem: timeSort,
            labelText: 'TIME SORT',
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  timeSort = value;
                });
                // Handle the sorting logic here
              }
            },
          ),
          const SizedBox(height: 20),
          // Stock Alert
          _buildSectionTitle('STOCK ALERT'),
          const SizedBox(height: 8),
          _buildDropdownSelector(
            icon: Icons.notifications_outlined,
            text: stockAlert,
            onTap: () {
              // Show stock alert options
            },
          ),
          const SizedBox(height: 20),

         // Category
          _buildSectionTitle('CATEGORY'),
          const SizedBox(height: 8),
          _buildDropdownSelector(
            icon: Icons.category_outlined,
            text: category,
            onTap: () {
              // Show category options
            },
          ),
          const SizedBox(height: 20),

          // Price
          _buildSectionTitle('PRICE'),
          const SizedBox(height: 8),
          _buildPriceInput(),

          _buildDropdownSelector(
            icon: Icons.category_outlined,
            text: "fff",
            onTap: () {
              // Show category options
            },),
        ],
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

  Widget _buildStatusGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      // Width to height ratio
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildStatusItem('All', '1708'),
        _buildStatusItem('Active', '1232'),
        _buildStatusItem('Inactive', '250'),
        _buildStatusItem('Draft', '36'),
      ],
    );
  }

  Widget _buildStatusItem(String status, String count) {
    final isSelected = selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF122B32) : Colors.transparent,
          border: Border.all(
            color:
                isSelected ? const Color(0xFF00D563) : const Color(0xFF2C2C2C),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00D563).withOpacity(0.4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSelector({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFF1A262D),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white70,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF1A262D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: const Text(
            "\$",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF1A262D),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: TextField(
              controller: minPriceController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Minimum price",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
    );
  }


  String? selectedValue;

  Widget buildCustomDropdown({
    required IconData icon,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
    required String labelText,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$labelText: ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    const TextSpan(
                      text: 'Select',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$labelText: ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ))
            .toList(),
        value: selectedItem,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 260,
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF1A262D),
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 20,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF1A262D),
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 12, right: 12),
        ),
      ),
    );
  }
}
