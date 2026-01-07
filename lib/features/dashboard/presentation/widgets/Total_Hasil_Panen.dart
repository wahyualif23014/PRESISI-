import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HarvestChartCard extends StatefulWidget {
  final double totalPanen; 
  
  const HarvestChartCard({super.key, required this.totalPanen});

  @override
  State<HarvestChartCard> createState() => _HarvestChartCardState();
}

class _HarvestChartCardState extends State<HarvestChartCard> {
  bool showTotal = true;
  bool showJagung = true;
  bool showUbi = true;

  // --- WARNA TEMA ---
  // 1. Total (Hijau)
  final Color totalColor = const Color(0xFF2E7D32);
  
  // 2. Jagung (Oranye)
  final Color jagungColor = const Color(0xFFFF9800);
  
  // 3. Ubi Ungu (Ungu)
  final Color ubiColor = const Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420, // Sedikit dipertinggi untuk muat Filter Chips
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER JUDUL ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TOTAL HASIL PANEN 2026",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.totalPanen} Ton",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: totalColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              // Ikon Filter visual saja
              Icon(Icons.filter_list_rounded, color: Colors.grey.shade400),
            ],
          ),
          
          const SizedBox(height: 16),

          // --- FILTER CHIPS (LOGIKA PENCARIAN/FILTER) ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("Total", totalColor, showTotal, (val) {
                  setState(() => showTotal = val);
                }),
                const SizedBox(width: 8),
                _buildFilterChip("Jagung", jagungColor, showJagung, (val) {
                  setState(() => showJagung = val);
                }),
                const SizedBox(width: 8),
                _buildFilterChip("Ubi Ungu", ubiColor, showUbi, (val) {
                  setState(() => showUbi = val);
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),
          
          // --- CHART AREA ---
          Expanded(
            child: LineChart(
              mainData(),
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Filter Chip
  Widget _buildFilterChip(String label, Color color, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(color: color.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }

  // --- LOGIKA DATA CHART ---
  LineChartData mainData() {
    List<LineChartBarData> visibleLines = [];

    if (showTotal) visibleLines.add(_lineTotal());
    if (showJagung) visibleLines.add(_lineJagung());
    if (showUbi) visibleLines.add(_lineUbi());

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1, 
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1, 
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 35, 
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 0, 
      maxX: 11, 
      minY: 0,
      maxY: 6, 
      lineBarsData: visibleLines, 
      
      // Tooltip Custom
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.white,
          tooltipBorder: const BorderSide(color: Colors.grey, width: 0.5),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              Color textColor = barSpot.bar.color ?? Colors.black;
              String label = "";
                            if (barSpot.bar.color == totalColor) label = "Total";
              else if (barSpot.bar.color == jagungColor) label = "Jagung";
              else if (barSpot.bar.color == ubiColor) label = "Ubi";

              return LineTooltipItem(
                '$label: ${barSpot.y} T',
                TextStyle(
                  color: textColor, 
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // 1. DATA TOTAL (HIJAU)
  LineChartBarData _lineTotal() {
    return LineChartBarData(
      spots: _getTotalData(),
      isCurved: true,
      color: totalColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [totalColor.withOpacity(0.15), totalColor.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // 2. DATA JAGUNG (ORANYE)
  LineChartBarData _lineJagung() {
    return LineChartBarData(
      spots: _getJagungData(),
      isCurved: true,
      color: jagungColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false), 
    );
  }

  // 3. DATA UBI UNGU (UNGU)
  LineChartBarData _lineUbi() {
    return LineChartBarData(
      spots: _getUbiData(),
      isCurved: true,
      color: ubiColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  // --- WIDGET LABEL AXIS ---
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey);
    String text;
    switch (value.toInt()) {
      case 0: text = 'JAN'; break;
      case 1: text = 'FEB'; break;
      case 3: text = 'APR'; break;
      case 5: text = 'JUN'; break;
      case 7: text = 'AUG'; break;
      case 9: text = 'OCT'; break;
      case 11: text = 'DEC'; break;
      case 2: text = 'MAR'; break;
      case 4: text = 'MEI'; break;
      case 6: text = 'JUL'; break;
      case 8: text = 'SEP'; break;
      case 10: text = 'NOV'; break;
      default: return Container(); 
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: Text(text, style: style));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey);
    return Text('${value.toInt()}T', style: style, textAlign: TextAlign.left);
  }

  // --- DUMMY DATA ---
  List<FlSpot> _getTotalData() => const [
    FlSpot(0, 3), FlSpot(1, 3.5), FlSpot(2, 3.4), FlSpot(3, 5.4), 
    FlSpot(4, 4), FlSpot(5, 4.2), FlSpot(6, 3.8), FlSpot(7, 4.8), 
    FlSpot(8, 5.5), FlSpot(9, 4.0), FlSpot(10, 5.0), FlSpot(11, 4.5),
  ];

  List<FlSpot> _getJagungData() => const [
    FlSpot(0, 1), FlSpot(1, 1.2), FlSpot(2, 0.8), FlSpot(3, 2.0), 
    FlSpot(4, 1.5), FlSpot(5, 1.8), FlSpot(6, 2.2), FlSpot(7, 2.0), 
    FlSpot(8, 1.5), FlSpot(9, 1.0), FlSpot(10, 2.5), FlSpot(11, 2.0),
  ];

  List<FlSpot> _getUbiData() => const [
    FlSpot(0, 0.5), FlSpot(1, 0.8), FlSpot(2, 1.0), FlSpot(3, 1.2), 
    FlSpot(4, 1.0), FlSpot(5, 0.5), FlSpot(6, 0.8), FlSpot(7, 1.5), 
    FlSpot(8, 2.0), FlSpot(9, 1.5), FlSpot(10, 1.0), FlSpot(11, 0.5),
  ];
}