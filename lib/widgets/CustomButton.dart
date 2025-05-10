import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget  {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}


class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isDisabled ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1CB65D), // Dark green from the image
        disabledBackgroundColor: Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
        ),
        elevation: 0, // No shadow
        minimumSize: const Size(120, 40), // Set minimum size
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white, // White text
        ),
      ),
    );
  }
}