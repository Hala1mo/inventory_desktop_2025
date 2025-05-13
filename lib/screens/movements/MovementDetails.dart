import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_desktop/models/ProductMovement.dart';
import 'package:inventory_desktop/screens/movements/EditMovement.dart';

import '../../widgets/CustomButton.dart';

class MovementDetails extends StatelessWidget {
  final ProductMovement movement;

  const MovementDetails({
    Key? key,
    required this.movement,
  }) : super(key: key);

  IconData _getMovementIcon() {
    switch (movement.movementType) {
      case MovementType.IN:
        return Icons.arrow_downward;
      case MovementType.OUT:
        return Icons.arrow_upward;
      case MovementType.TRANSFER:
        return Icons.swap_horiz;
    }
  }

  Color _getMovementColor() {
    switch (movement.movementType) {
      case MovementType.IN:
        return Colors.green;
      case MovementType.OUT:
        return Colors.red;
      case MovementType.TRANSFER:
        return Colors.blue;
    }
  }

  String _getMovementTypeText() {
    switch (movement.movementType) {
      case MovementType.IN:
        return "In Movement";
      case MovementType.OUT:
        return "Out Movement";
      case MovementType.TRANSFER:
        return "Transfer Movement";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xFF0F171A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Movement Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: 'Edit',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditMovement(movement: movement);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Movement Type Section
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF2A3B44),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getMovementIcon(),
                    size: 30,
                    color: _getMovementColor(),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMovementTypeText(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getMovementColor(),
                      ),
                    ),
                    Text(
                      'Movement ID: ${movement.id}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Product Information"),
                      SizedBox(height: 10),
                      _buildDetailRow("Name", movement.product.name),
                      _buildDetailRow("Code", movement.product.code),
                      _buildDetailRow(
                          "Category", movement.product.category.name),
                      _buildDetailRow("Quantity", movement.quantity.toString()),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Location Information"),
                      SizedBox(height: 10),
                      if (movement.fromLocation != null)
                        _buildDetailRow("From",
                            "${movement.fromLocation!.name}, ${movement.fromLocation!.city}"),
                      if (movement.toLocation != null)
                        _buildDetailRow("To",
                            "${movement.toLocation!.name}, ${movement.toLocation!.city}"),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Additional Details
                      _buildSectionTitle("Additional Information"),
                      SizedBox(height: 10),
                      _buildDetailRow("Date",
                          "${movement.timestamp!.day}/${movement.timestamp!.month}/${movement.timestamp!.year}"),
                      _buildDetailRow("Time",
                          "${movement.timestamp!.hour}:${movement.timestamp!.minute.toString().padLeft(2, '0')}"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notes:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                     Container(
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Color(0xFF1A262D),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    movement.notes?.isNotEmpty == true ? movement.notes! : "No notes",
    style: TextStyle(
      fontSize: 14,
      color: Colors.grey[300],
    ),
  ),
),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
