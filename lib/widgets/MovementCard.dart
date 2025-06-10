import 'package:flutter/material.dart';
import '../models/ProductMovement.dart';
import '../screens/movements/MovementDetails.dart';

class MovementCard extends StatefulWidget {
  final ProductMovement movement;

  const MovementCard({
    super.key,
    required this.movement,
  });

  @override
  _MovementCardState createState() => _MovementCardState();
}

class _MovementCardState extends State<MovementCard> {

  IconData _getMovementIcon() {
    switch (widget.movement.movementType) {
      case MovementType.IN:
        return Icons.arrow_downward;
      case MovementType.OUT:
        return Icons.arrow_upward;
      case MovementType.TRANSFER:
        return Icons.swap_horiz;
    }
  }

  Color _getMovementColor() {
    switch (widget.movement.movementType) {
      case MovementType.IN:
        return Colors.green;
      case MovementType.OUT:
        return Colors.red;
      case MovementType.TRANSFER:
        return Colors.blue;
    }
  }

  String _getMovementTypeText() {
    switch (widget.movement.movementType) {
      case MovementType.IN:
        return "In";
      case MovementType.OUT:
        return "Out";
      case MovementType.TRANSFER:
        return "Transfer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          print(widget.movement.timestamp);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MovementDetails(movement: widget.movement);
            },
          );
        },
        child: Container(
          width: 200,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF1A262D),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movement type icon
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Color(0xFF2A3B44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getMovementIcon(),
                      size: 35,
                      color: _getMovementColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getMovementColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getMovementTypeText(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getMovementColor(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.movement.product.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Location info
                      Text(
                        widget.movement.movementType == MovementType.OUT
                            ? "From: ${widget.movement.fromLocation?.name ?? 'Unknown'}"
                            : widget.movement.movementType == MovementType.IN
                                ? "To: ${widget.movement.toLocation?.name ?? 'Unknown'}"
                                : "${widget.movement.fromLocation?.name ?? 'Unknown'} → ${widget.movement.toLocation?.name ?? 'Unknown'}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


