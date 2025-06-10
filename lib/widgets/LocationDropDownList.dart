import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../models/Location.dart';

class LocationDropDownList extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<Location> items;
  final Location? selectedItem;
  final ValueChanged<Location?> onChanged;

  const LocationDropDownList({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  State<LocationDropDownList> createState() => _DropDownState();
}

class _DropDownState extends State<LocationDropDownList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonHideUnderline(
          child: DropdownButton2<Location>(
            isExpanded: true,
            hint: Row(
              children: [
                Icon(widget.icon, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  widget.hint,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            items: widget.items.map((Location item) {
              return DropdownMenuItem<Location>(
                value: item,
                child: Row(
                  children: [
                    Icon(widget.icon, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            value: widget.selectedItem,
            onChanged: widget.onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12, right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF1A262D),
              ),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_outlined),
              iconSize: 20,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
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
        ),
      ],
    );
  }
}
