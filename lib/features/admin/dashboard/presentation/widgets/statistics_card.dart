import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String year;
  final double data; // Data dari DashboardModel

  const StatisticsCard({
    super.key,
    required this.title,
    required this.year,
    required this.data, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Hapus margin bottom di sini agar diatur oleh Wrap/LayoutBuilder di parent
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Konsisten dengan Carousel
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.08), // Shadow halus
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Judul
          Row(
            children: [
              Container(
                width: 4, height: 16, 
                decoration: BoxDecoration(
                  color: Colors.orange, 
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(right: 8),
              ),
              Expanded(
                child: Text(
                  "$title $year",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B), // Slate 500
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Konten Utama
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Angka Besar
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatNumber(data),
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A), // Slate 900
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "HEKTAR (HA)",
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF94A3B8), // Slate 400
                      ),
                    ),
                  ],
                ),
              ),
              
              // Breakdown (Visual Dummy Proporsional)
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLegendItem("Produktif", data * 0.65, Colors.blue),
                    const SizedBox(height: 4),
                    _buildLegendItem("Cadangan", data * 0.35, Colors.orange),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 8),

          // Footer: Indikator Kenaikan
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7), // Green 100
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.trending_up, color: Color(0xFF166534), size: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                "+2.4% dari tahun lalu",
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  color: Color(0xFF166534), // Green 800
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 6),
        Text(
          _formatNumber(value),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toStringAsFixed(0);
  }
}