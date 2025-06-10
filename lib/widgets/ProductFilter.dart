import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ProductsListProvider.dart';

class ProductFilters extends StatefulWidget {
  const ProductFilters({Key? key}) : super(key: key);

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  String selectedStatus = 'All';
  String selectedType = 'Retail';
  String sortBy = 'Alphabetical: A-Z';
  String stockAlert = 'All Stock';
  String category = 'All Stock';
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  String? selectedSort = 'A-Z';
  String? timeSort = 'Newest';

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductsListProvider provider =
        Provider.of<ProductsListProvider>(context, listen: false);
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
                  provider.filterProducts(
                    sortAlpha: value,
                  );
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
                  provider.filterProducts(
                    sortTime: value,
                  );
                }
              },
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('CATEGORY'),
            const SizedBox(height: 8),
            buildCustomDropdown2(
              icon: Icons.category_outlined,
              items: ['All Stock', 'ELECTRONICS', 'FURNITURE'],
              selectedItem: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                  Provider.of<ProductsListProvider>(context, listen: false).filterProducts(
                    status: selectedStatus,
                    category: category,
                    minPrice: double.tryParse(minPriceController.text),
                    maxPrice: double.tryParse(maxPriceController.text),
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // Price
            _buildSectionTitle('PRICE'),
            const SizedBox(height: 8),
            _buildPriceInput("Minimum Price", minPriceController),
            const SizedBox(height: 8),
            _buildPriceInput("Maximum Price", maxPriceController),
            const SizedBox(height: 35),

            ElevatedButton(
              onPressed: () {

                setState(() {
                  selectedStatus = 'All';
                  selectedType = 'Retail';
                  sortBy = 'Alphabetical: A-Z';
                  stockAlert = 'All Stock';
                  category = 'All Stock';
                  selectedSort = 'A-Z';
                  timeSort = 'Newest';
                  minPriceController.clear();
                  maxPriceController.clear();
                });
                provider.clearFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A3B44),
                // Dark green from the image
                disabledBackgroundColor: Colors.grey.shade400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                elevation: 0,
                // No shadow
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

  Widget _buildPriceInput(String text, TextEditingController enteredPrice) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: const Color(0xFF6C6B6B), width: 0.5)),
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
            decoration: BoxDecoration(
                color: Color(0xFF1A262D),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFF6C6B6B), width: 0.5)),
            child: TextField(
              controller: enteredPrice,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: text,
                hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                // Adjust vertical padding
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Apply price filter when value changes
                Provider.of<ProductsListProvider>(context, listen: false).filterProducts(
                  minPrice: double.tryParse(minPriceController.text),
                  maxPrice: double.tryParse(maxPriceController.text),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

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
              borderRadius: BorderRadius.circular(4), color: Color(0xFF2A3B44)),
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
          width: 260,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color:  Color(0xFF1A262D),),
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

  Widget buildCustomDropdown2({
    required IconData icon,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
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
                                text: item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
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
                ))
            .toList(),
        value: selectedItem,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 260,
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Color(0xFF2A3B44)),
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
          width: 260,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color:  Color(0xFF1A262D),),
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
