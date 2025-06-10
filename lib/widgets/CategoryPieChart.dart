import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, int> distribution;
  
  const CategoryPieChart({
    Key? key, 
    required this.distribution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      width: 600, 
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:  Color(0xFF1A262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Row(
              children: [
            
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: _getSections(),
                      pieTouchData: PieTouchData(),
                    ),
                  ),
                ),
              
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getLegendItems(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final List<PieChartSectionData> sections = [];
    
    // Colors for categories
    final Color electronicsColor = Colors.blue.shade500;
    final Color furnitureColor = Colors.amber.shade500;
    
    int totalItems = 0;
    distribution.forEach((_, count) => totalItems += count);
    
    // Electronics Section
    if (distribution.containsKey('ELECTRONICS')) {
      final int count = distribution['ELECTRONICS'] ?? 0;
      final double percentage = totalItems > 0 ? count / totalItems * 100 : 0;
      
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(0)}%',
          color: electronicsColor,
          radius: 110,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
      );
    }
    
    // Furniture Section
    if (distribution.containsKey('FURNITURE')) {
      final int count = distribution['FURNITURE'] ?? 0;
      final double percentage = totalItems > 0 ? count / totalItems * 100 : 0;
      
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(0)}%',
          color: furnitureColor,
          radius: 110,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
      );
    }
    
    return sections;
  }
  
  List<Widget> _getLegendItems() {
    return [
      _buildLegendItem('Electronics', distribution['ELECTRONICS'] ?? 0, Colors.blue.shade500),
      const SizedBox(height: 12),
      _buildLegendItem('Furniture', distribution['FURNITURE'] ?? 0, Colors.amber.shade500),
    ];
  }
  
  Widget _buildLegendItem(String title, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title: $count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}