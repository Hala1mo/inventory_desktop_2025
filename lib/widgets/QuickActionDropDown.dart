import 'package:flutter/material.dart';

class QuickActionDropdown extends StatelessWidget {
  final Function() onAddLocation;
  final Function() onAddProduct;
  final Function() onAddMovement;

  const QuickActionDropdown({
    Key? key,
    required this.onAddLocation,
    required this.onAddProduct,
    required this.onAddMovement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00D46A), 
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: const Color(0xFF1A2226),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'location',
            child: _buildMenuItem(Icons.location_on, 'Add Location'),
          ),
          PopupMenuItem(
            value: 'product',
            child: _buildMenuItem(Icons.inventory, 'Add Product'),
          ),
          PopupMenuItem(
            value: 'movement',
            child: _buildMenuItem(Icons.swap_horiz, 'Add Movement'),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'location':
              onAddLocation();
              break;
            case 'product':
              onAddProduct();
              break;
            case 'movement':
              onAddMovement();
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Quick Action',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black87,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}