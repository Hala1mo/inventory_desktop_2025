import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/MovementListProvider.dart';

class MovementFilters extends StatefulWidget {
  const MovementFilters({super.key});

  @override
  State<MovementFilters> createState() => _MovementFiltersState();
}

class _MovementFiltersState extends State<MovementFilters> {
  String? selectedProduct;
  String? selectedToLocation;
  String? selectedFromLocation;
  String selectedSort = 'Newest';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovementListProvider>(context);

    final products = provider.uniqueProducts;
    final toLocations = provider.uniqueToLocations;
    final fromLocations = provider.uniqueFromLocations;

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
              items: ['Newest', 'Oldest'],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSort = value;
                  });
                  provider.filterMovements(sort: value);
                }
              },
              icon: Icons.sort,
              hintText: 'Sort by Date',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('PRODUCT'),
            const SizedBox(height: 8),
            isLoading
                ? _buildLoadingDropdown('Loading products...')
                : _buildDropdown(
                    value: selectedProduct,
                    items: products,
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                      provider.filterMovements(product: value);
                    },
                    icon: Icons.inventory,
                    hintText: 'Select Product',
                  ),
            const SizedBox(height: 20),
            _buildSectionTitle('FROM LOCATION'),
            const SizedBox(height: 8),
            isLoading
                ? _buildLoadingDropdown('Loading locations...')
                : _buildDropdown(
                    value: selectedFromLocation,
                    items: fromLocations,
                    onChanged: (value) {
                      setState(() {
                        selectedFromLocation = value;
                      });
                      provider.filterMovements(fromLocation: value);
                    },
                    icon: Icons.location_on_outlined,
                    hintText: 'Select From Location',
                  ),
            const SizedBox(height: 20),
            _buildSectionTitle('TO LOCATION'),
            const SizedBox(height: 8),
            isLoading
                ? _buildLoadingDropdown('Loading locations...')
                : _buildDropdown(
                    value: selectedToLocation,
                    items: toLocations,
                    onChanged: (value) {
                      setState(() {
                        selectedToLocation = value;
                      });
                      provider.filterMovements(toLocation: value);
                    },
                    icon: Icons.location_on,
                    hintText: 'Select To Location',
                  ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedProduct = null;
                  selectedToLocation = null;
                  selectedFromLocation = null;
                  selectedSort = 'Newest';
                });
                provider.clearFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A3B44),
                disabledBackgroundColor: Colors.grey.shade400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    color: Colors.white),
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
