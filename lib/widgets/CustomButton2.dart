import 'package:flutter/material.dart';

class CustomButton2 extends StatefulWidget  {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const CustomButton2({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<CustomButton2> createState() => _CustomButton2State();
}


class _CustomButton2State extends State<CustomButton2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isDisabled ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:  Color(0xFF0F171A),
        disabledBackgroundColor: Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:  Color(0xFF1CB65D),
            width: 0.5, 
          ),
        ),
        elevation: 0, 
        minimumSize: const Size(150, 50),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1CB65D),
        ),
      ),
    );
  }
}