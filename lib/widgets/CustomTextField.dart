import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputType? inputType;
  final String? prefix;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
    
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputType,
    this.prefix,
    this.maxLines,
    this.inputFormatters,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines != null && maxLines! > 1;
    
    // Use inputType if provided, otherwise fall back to keyboardType
    final effectiveInputType = inputType ?? keyboardType ?? TextInputType.text;
    
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
                      keyboardType: isMultiline ? TextInputType.multiline : effectiveInputType,
                      inputFormatters: inputFormatters,
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
                          prefix!,
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
                        keyboardType: effectiveInputType,
                        inputFormatters: inputFormatters,
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