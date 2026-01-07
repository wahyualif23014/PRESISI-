import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/controllers/dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/statistics_card.dart';
import '../presentation/widgets/Total_Hasil_Panen.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), 
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(dashboardControllerProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: state.when(
            loading: () => const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) => SizedBox(
              height: 400,
              child: Center(child: Text("Gagal memuat data: $e")),
            ),
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER SECTION
                  DashboardHeader(
                    userName: data.userName,
                  ),

                  const SizedBox(height: 24),

                  // 2. STATISTICS SECTION
                  _buildSectionTitle("Ringkasan Area Lahan"),
                  const SizedBox(height: 12),
                  
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int columns = width < 600 ? 1 : (width < 1100 ? 2 : 3);
                      
                      double spacing = 16;
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
                              data: data.potensiLahan,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: StatisticsCard(
                              title: "TOTAL LAHAN TANAM",
                              year: "2026",
                              data: data.lahanTanam,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: StatisticsCard(
                              title: "TOTAL LAHAN PANEN",
                              year: "2026",
                              data: data.lahanPanen,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // 3. CHART SECTION
                  _buildSectionTitle("Analisis Hasil Panen"),
                  const SizedBox(height: 12),
                  
                  HarvestChartCard(
                    totalPanen: data.totalPanenTahunIni.toDouble(),
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

  // Widget kecil untuk Judul Seksi (Reusable)
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