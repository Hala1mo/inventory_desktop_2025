import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/LocationProductCount.dart';

class LocationBarChart extends StatelessWidget {
  final List<LocationProductCount> locationCounts;
  final String title;

  const LocationBarChart({
    Key? key,
    required this.locationCounts,
    this.title = 'Products Per Location',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    final sortedData = List<LocationProductCount>.from(locationCounts)
      ..sort((a, b) => b.quantity.compareTo(a.quantity));
    

    final displayData = sortedData.length > 8 ? sortedData.sublist(0, 8) : sortedData;
    
    final maxY = displayData.isEmpty 
        ? 10 
        : (displayData.map((e) => e.quantity).reduce((a, b) => a > b ? a : b) * 1.2).toInt();

    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: displayData.isEmpty
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY.toDouble(),
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                        //  tooltipBgColor: const Color(0xFF262D31),
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${displayData[groupIndex].name}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Quantity: ${rod.toY.round()}',
                                  style: TextStyle(
                                    color: Colors.amber.shade300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value >= displayData.length || value < 0) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  displayData[value.toInt()].name.length > 30
                                      ? '${displayData[value.toInt()].name.substring(0, 8)}...'
                                      : displayData[value.toInt()].name,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 35,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: maxY / 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white10,
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: displayData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final double percentOfMax = data.quantity / maxY;
                        final color = ColorTween(
                          begin: Colors.blue.shade400,
                          end: Colors.amber.shade400,
                        ).lerp(percentOfMax) ?? Colors.blue.shade400;
                        
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: data.quantity.toDouble(),
                              color: color,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}