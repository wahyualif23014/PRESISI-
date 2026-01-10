// features/dashboard/data/model/dashboard_model.dart

import 'lahan_group_model.dart';
import 'quarterly_item_model.dart';
import 'summary_item_model.dart'; // Import model summary baru

class DashboardModel {
  final LahanGroup totalLuasTanam;
  final LahanGroup totalLuasPanen;
  final LahanGroup potensiLahan;
  final double totalHasilPanen;
  final int jumlahPersonel;
  
  // List data kwartal
  final List<QuarterlyItem> quarterlyData;
  
  // List data summary (Total Keseluruhan) - BARU
  final List<SummaryItem> summaryData;

  DashboardModel({
    required this.totalLuasTanam,
    required this.totalLuasPanen,
    required this.potensiLahan,
    required this.totalHasilPanen,
    required this.jumlahPersonel,
    required this.quarterlyData,
    required this.summaryData, // Tambahkan di constructor
  });

  // --- FACTORY DUMMY DATA ---
  factory DashboardModel.dummy() {
    return DashboardModel(
      // Data Lahan (Kuning, Orange, Ungu)
      totalLuasTanam: LahanGroup.createDummy(430.98, {
        "Produktif": 192.23, "Perhutanan": 220.5, "Luas Baku Sawah (LBS)": 18.25, "Pesantren": 234.00,
      }),
      potensiLahan: LahanGroup.createDummy(555.55, {
        "Blok A": 998.21, "Blok B": 82.61, "Blok C": 21.21, "Blok D": 78.11,
      }),
      totalLuasPanen: LahanGroup.createDummy(222.18, {
        "Jagung": 998.21, "Padi": 82.61, "Kedelai": 21.21, "Ubi": 78.11,
      }),
      
      totalHasilPanen: 12500.8,
      jumlahPersonel: 45,
      
      // --- DATA DUMMY KWARTAL (LENGKAP Q1 - Q4) ---
      quarterlyData: [
        // === KWARTAL 1 (Jan - Mar) ===
        QuarterlyItem(value: 90, unit: "HA", label: "Tanam Lahan Produktif", period: "Kwartal 1"),
        QuarterlyItem(value: 10, unit: "HA", label: "Tanam Lahan Perhutanan", period: "Kwartal 1"),
        QuarterlyItem(value: 32, unit: "HA", label: "Tanam Lahan LBS", period: "Kwartal 1"),
        QuarterlyItem(value: 8, unit: "HA", label: "Tanam Lahan Pesantren", period: "Kwartal 1"),
        
        // === KWARTAL 2 (Apr - Jun) ===
        QuarterlyItem(value: 120, unit: "HA", label: "Perluasan Lahan Produktif", period: "Kwartal 2"),
        QuarterlyItem(value: 45, unit: "HA", label: "Tanam Lahan Pesantren", period: "Kwartal 2"),
        QuarterlyItem(value: 15, unit: "HA", label: "Tanam Lahan Gambut", period: "Kwartal 2"),
        QuarterlyItem(value: 60, unit: "HA", label: "Optimalisasi Lahan Tidur", period: "Kwartal 2"),
        
        // === KWARTAL 3 (Jul - Sep) ===
        QuarterlyItem(value: 200, unit: "HA", label: "Panen Raya Jagung", period: "Kwartal 3"),
        QuarterlyItem(value: 150, unit: "HA", label: "Panen Raya Padi", period: "Kwartal 3"),
        QuarterlyItem(value: 50, unit: "HA", label: "Distribusi Bibit Unggul", period: "Kwartal 3"),
        
        // === KWARTAL 4 (Okt - Des) ===
        QuarterlyItem(value: 300, unit: "HA", label: "Evaluasi Akhir Tahun", period: "Kwartal 4"),
        QuarterlyItem(value: 80, unit: "HA", label: "Persiapan Tanam 2027", period: "Kwartal 4"),
        QuarterlyItem(value: 25, unit: "HA", label: "Pembersihan Lahan", period: "Kwartal 4"),
        QuarterlyItem(value: 100, unit: "HA", label: "Rekapitulasi Panen", period: "Kwartal 4"),
      ],

      // --- DATA DUMMY TOTAL KESELURUHAN (BARU) ---
      summaryData: [
        SummaryItem(label: "Berhasil", value: 90, unit: "HA", type: "success"),
        SummaryItem(label: "Gagal", value: 90, unit: "HA", type: "failed"),
        SummaryItem(label: "Tanam", value: 90, unit: "HA", type: "plant"),
        SummaryItem(label: "Proses", value: 90, unit: "HA", type: "process"),
      ],
    );
  }

  // --- FACTORY JSON (Untuk API Nanti) ---
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalLuasTanam: LahanGroup.fromJson(json['total_luas_tanam'] ?? {}),
      totalLuasPanen: LahanGroup.fromJson(json['total_luas_panen'] ?? {}),
      potensiLahan: LahanGroup.fromJson(json['potensi_lahan'] ?? {}),
      totalHasilPanen: (json['total_hasil_panen'] as num?)?.toDouble() ?? 0.0,
      jumlahPersonel: (json['jumlah_personel'] as num?)?.toInt() ?? 0,
      
      // Parsing list Kwartal
      quarterlyData: (json['quarterly_data'] as List? ?? [])
          .map((e) => QuarterlyItem.fromJson(e))
          .toList(),
      
      // Parsing list Summary (BARU)
      summaryData: (json['summary_data'] as List? ?? [])
          .map((e) => SummaryItem.fromJson(e))
          .toList(),
    );
  }
}