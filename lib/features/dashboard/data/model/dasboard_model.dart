class DashboardModel {
  final double totalLuasTanam;   // Untuk Widget Lahan_Tanam
  final double totalLuasPanen;   // Untuk Widget Lahan_Panen
  final double potensiLahan;     // Untuk Widget Potensi_Lahan
  final double totalHasilPanen;  // Untuk Widget Total_Hasil_Panen (Tonase)
  final int jumlahPersonel;      // Tambahan opsional (statistik ringkas)

  DashboardModel({
    required this.totalLuasTanam,
    required this.totalLuasPanen,
    required this.potensiLahan,
    required this.totalHasilPanen,
    required this.jumlahPersonel,
  });

  // Factory: Konversi dari JSON (Backend) ke Object Dart
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    // Helper function agar aman jika data dari API berupa String atau Integer
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }
    
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return DashboardModel(
      totalLuasTanam: toDouble(json['total_luas_tanam']),
      totalLuasPanen: toDouble(json['total_luas_panen']),
      potensiLahan: toDouble(json['potensi_lahan']),
      totalHasilPanen: toDouble(json['total_hasil_panen']),
      jumlahPersonel: toInt(json['jumlah_personel']),
    );
  }

  // Opsional: Data Dummy untuk testing jika API belum siap
  factory DashboardModel.empty() {
    return DashboardModel(
      totalLuasTanam: 0,
      totalLuasPanen: 0,
      potensiLahan: 0,
      totalHasilPanen: 0,
      jumlahPersonel: 0,
    );
  }
}