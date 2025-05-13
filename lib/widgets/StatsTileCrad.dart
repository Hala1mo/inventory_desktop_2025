import 'package:flutter/material.dart';

class StatsTileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconBackgroundColor;
  final Color iconColor;
  final double width;

  const StatsTileCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconBackgroundColor = const Color(0xFF1F2B33),
    this.iconColor = Colors.white,
    this.width = 350,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF1A262D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
