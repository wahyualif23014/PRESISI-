import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Provider & Model
import '../providers/dashboard_provider.dart';
import '../../../auth/provider/auth_provider.dart'; // Untuk ambil nama user

// Import Widgets
import './widgets/dashboard_header.dart';
import './widgets/statistics_card.dart';
import './widgets/Total_Hasil_Panen.dart'; // Sesuaikan nama file widget chart Anda

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?.nama ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DashboardProvider>().refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Agar bisa di-refresh meski konten pendek
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          
          // Konsumen DashboardProvider
          child: Consumer<DashboardProvider>(
            builder: (context, dashboard, child) {
              // 1. KONDISI LOADING
              if (dashboard.isLoading) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // 2. KONDISI ERROR
              if (dashboard.errorMessage != null) {
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text("Gagal memuat data: ${dashboard.errorMessage}"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => dashboard.fetchDashboardData(), 
                          child: const Text("Coba Lagi"),
                        )
                      ],
                    ),
                  ),
                );
              }

              // 3. KONDISI DATA KOSONG (Opsional)
              final data = dashboard.data;
              if (data == null) {
                return const Center(child: Text("Data tidak tersedia"));
              }

              // 4. KONDISI SUKSES (Tampilkan UI)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A. HEADER SECTION
                  DashboardHeader(userName: userName),

                  const SizedBox(height: 24),

                  // B. STATISTICS SECTION
                  _buildSectionTitle("Ringkasan Area Lahan"),
                  const SizedBox(height: 12),
                  
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      // Logic Responsive: 1 kolom (HP), 2 kolom (Tablet), 3 kolom (Desktop)
                      int columns = width < 600 ? 1 : (width < 1100 ? 2 : 3);
                      
                      double spacing = 16;
                      // Hitung lebar per item
                      double itemWidth = (width - (spacing * (columns - 1))) / columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: StatisticsCard(
                              title: "TOTAL POTENSI LAHAN",
                              year: "2026",
                              data: data.potensiLahan, // Dari Model
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: StatisticsCard(
                              title: "TOTAL LAHAN TANAM",
                              year: "2026",
                              data: data.totalLuasTanam, // Dari Model
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: StatisticsCard(
                              title: "TOTAL LAHAN PANEN",
                              year: "2026",
                              data: data.totalLuasPanen, // Dari Model
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // C. CHART SECTION
                  _buildSectionTitle("Analisis Hasil Panen"),
                  const SizedBox(height: 12),
                  
                  // Pastikan nama widget ini sesuai dengan file widget Anda
                  HarvestChartCard(
                    totalPanen: data.totalHasilPanen,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Judul Seksi
  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B), 
        letterSpacing: 1.0,
      ),
    );
  }
}