// lib/features/dashboard/data/dashboard_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/dasboard_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

class DashboardRepository {
  // Mode Dev: Set ke true jika ingin pakai data palsu (agar cepat tampil)
  final bool useMockData = true; 

  Future<DashboardModel> getDashboardData() async {
    // Simulasi loading 2 detik supaya terlihat seperti request asli
    await Future.delayed(const Duration(seconds: 2));

    if (useMockData) {
      // KEMBALIKAN DATA DUMMY LANGSUNG
      return DashboardModel(
        userName: "DIO VLADIKA",
        greetingText: "INI MERUPAKAN APLIKASI SISTEM KETAHANAN PANGAN PRESISI POLDA JAWA TIMUR...",
        totalPanenTahunIni: 1250,
        potensiLahan: LahanStatistikModel(
          totalLuas: 2.65,
          produktif: 2.65,
          perhutanan: 0,
          luasBakuSawah: 1.5,
          pesantren: 0,
          percentage: 100,
        ),
        lahanTanam: LahanStatistikModel(
          totalLuas: 1.2,
          produktif: 0.8,
          perhutanan: 0,
          luasBakuSawah: 0.4,
          pesantren: 0,
          percentage: 45,
        ),
        lahanPanen: LahanStatistikModel(
          totalLuas: 0.5,
          produktif: 0.5,
          perhutanan: 0,
          luasBakuSawah: 0,
          pesantren: 0,
          percentage: 20,
        ),
        chartData: [],
      );
    } else {
      // ... Kode request ke API Laravel yang asli (Dio/Http) ...
      throw UnimplementedError("API Asli belum disambungkan");
    }
  }
}