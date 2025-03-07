import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/currency_formatter.dart';

class ChartLegend extends StatelessWidget {
  final String title;
  final Color color;
  final double value;

  const ChartLegend({
    Key? key,
    required this.title,
    required this.color,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          color: color,
        ),
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              formatCurrency(value),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final double maxY;
  final List<String> bottomTitles;

  const CustomBarChart({
    Key? key,
    required this.barGroups,
    required this.maxY,
    required this.bottomTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              final index = value.toInt();
              if (index >= 0 && index < bottomTitles.length) {
                return bottomTitles[index];
              }
              return '';
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;

  const CustomPieChart({
    Key? key,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2.0,
        centerSpaceRadius: 40.0,
      ),
    );
  }
}