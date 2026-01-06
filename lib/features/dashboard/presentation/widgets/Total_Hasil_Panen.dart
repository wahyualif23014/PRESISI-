import 'package:flutter/material.dart';

class HarvestChartCard extends StatelessWidget {
  final int totalPanen;
  
  const HarvestChartCard({super.key, required this.totalPanen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, 
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TOTAL HASIL PANEN TAHUN 2026 : $totalPanen TON",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          

          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 40, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    const Text("Area Grafik", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}