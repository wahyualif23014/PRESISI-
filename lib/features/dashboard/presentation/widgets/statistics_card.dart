import 'package:flutter/material.dart';

// Widget ini sekarang independen, tidak butuh import Model khusus
// Cukup terima data via parameter constructor

class StatisticsCard extends StatelessWidget {
  final String title;
  final String year;
  final double data; // Total Luas (misal: 25000.0)

  // Opsional: Jika ingin menampilkan breakdown detail, bisa ditambahkan Map/List
  // Tapi untuk sekarang kita simpelkan dulu sesuai DashboardPage sebelumnya
  
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
        borderRadius: BorderRadius.circular(12), // Radius lebih halus
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Kiri: Angka Besar
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatNumber(data), // Helper format angka biar rapi (misal 2.5K)
                      style: const TextStyle(
                        fontSize: 28, // Sedikit dikecilkan agar muat di HP
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "HEKTAR (HA)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              // Bagian Kanan: Breakdown (Statistik Kecil)
              // Karena data detail belum ada di DashboardModel sederhana kita,
              // Saya buat dummy breakdown atau kalkulasi persentase sederhana
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Contoh simulasi data breakdown (Nanti bisa diganti data real dari backend)
                    _buildLegendItem("PRODUKTIF", data * 0.6), // Asumsi 60%
                    _buildLegendItem("PERHUTANAN", data * 0.2), // Asumsi 20%
                    _buildLegendItem("LAINNYA", data * 0.2),
                  ],
                ),
              ),

              // Persentase Kenaikan (Dummy Visual)
              const Column(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                  Text(
                    "+2.4%",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 8),

          // Footer Title
          Row(
            children: [
              Container(
                width: 4, height: 16, 
                color: Colors.orange, 
                margin: const EdgeInsets.only(right: 8),
              ),
              Text(
                "$title $year",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Baris Kecil (Legend)
  Widget _buildLegendItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.orange),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "${_formatNumber(value)} HA",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  // Helper: Memformat angka (misal 15000 -> 15k) agar tidak kepanjangan
  String _formatNumber(double number) {
    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toStringAsFixed(0);
  }
}