import 'package:flutter/material.dart';

class DeleteButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const DeleteButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<DeleteButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0F171A),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
        ),
        elevation: 0,
        minimumSize: const Size(150, 50), 
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
