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
      backgroundColor: Colors.white,
 
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(
                  userName: data.userName,
                ),

                StatisticsCard(
                  title: "TOTAL POTENSI LAHAN SAMPAI TAHUN",
                  year: "2026",
                  data: data.potensiLahan,
                ),

                StatisticsCard(
                  title: "TOTAL LAHAN TANAM TAHUN",
                  year: "2026",
                  data: data.lahanTanam, 
                ),

                StatisticsCard(
                  title: "TOTAL LAHAN PANEN TAHUN",
                  year: "2026",
                  data: data.lahanPanen, 
                ),

                const SizedBox(height: 10),

                HarvestChartCard(
                  totalPanen: data.totalPanenTahunIni,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}