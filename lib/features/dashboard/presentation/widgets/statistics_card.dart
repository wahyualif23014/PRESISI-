import 'package:flutter/material.dart';
import '../../data/model/dasboard_model.dart';

class StatisticsCard extends StatelessWidget {
  final String title; 
  final String year;  
  final LahanStatistikModel data;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.year,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.totalLuas}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "HA",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildLegendItem("PRODUKTIF", data.produktif),
                    _buildLegendItem("PERHUTANAN", data.perhutanan),
                    _buildLegendItem("LUAS BAKU SAWAH (LBS)", data.luasBakuSawah),
                    _buildLegendItem("PESANTREN", data.pesantren),
                  ],
                ),
              ),

              Text(
                "${data.percentage}%",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 8),

          // Footer Title
          Text(
            "$title $year",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, size: 16, color: Colors.orange),
          Expanded(
            child: Text(
              "$label : ",
              style: const TextStyle(fontSize: 10, color: Colors.orange),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "$value HA",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}