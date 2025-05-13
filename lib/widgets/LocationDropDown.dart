import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LocationDropdown extends StatelessWidget {
  final List<String> items;
  final String labelText;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool showSearchBox;
  final double maxHeight;
  final String hintText;

  ///Country and city DropDrown
  const LocationDropdown({
    Key? key,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.selectedItem,
    this.errorText,
    this.showSearchBox = false,
    this.maxHeight = 100,
    this.hintText = "Search...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) => items,
          selectedItem: selectedItem,
          onChanged: onChanged,
          enabled: true,
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style:
                  TextStyle(color: Colors.white), // 👈 White selected item text
            );
          },
          popupProps: PopupProps<String>.menu(
            itemBuilder: (BuildContext context, String item, bool isSelected,
                bool isDisabled) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.white, // ✅ white text
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
            showSearchBox: showSearchBox,
            fit: FlexFit.loose,
            constraints: BoxConstraints(maxHeight: 180),
            menuProps: MenuProps(
              backgroundColor: Color(0xFF1A262D),
              elevation: 0,
            ),
            containerBuilder: (ctx, popupWidget) => Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A262D),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Color(0xFF1A262D),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: popupWidget,
              ),
            ),
            searchFieldProps: TextFieldProps(
              style: TextStyle(color: Colors.white),
              autofocus: false,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white, // ✅ white text
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFF1A262D)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFF1A262D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFF1A262D)),
                ),
              ),
            ),
            scrollbarProps: ScrollbarProps(
              thumbVisibility: true,
              thickness: 5,
              radius: Radius.circular(8.0),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF1A262D),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Color(0xFF1A262D)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Color(0xFF1A262D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Color(0xFF1A262D)),
              ),
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
