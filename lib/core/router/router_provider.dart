// lib/core/router/router_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import '../../presentation/main_layout.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';

// Import halaman fitur (Pastikan file-file ini dibuat nanti)
// import '../../features/main_data/commodities/presentation/commodity_page.dart';
// import '../../features/main_data/regions/presentation/region_page.dart';
// ... dst

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.dashboard,
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      // SHELL ROUTE: Menjaga Sidebar tetap ada (Konsistensi Navigasi)
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child); 
        },
        routes: [
          // 1. DASHBOARD (BERANDA)
          GoRoute(
            path: RouteNames.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),

          // --- GRUP DATA UTAMA ---

          // 2. TINGKAT KESATUAN
          GoRoute(
            path: RouteNames.units,
            name: 'units',
            pageBuilder: (context, state) => NoTransitionPage(
              // Nanti ganti dengan UnitPage()
              child: _buildPlaceholderPage(context, "Tingkat Kesatuan", "Data Polres/Polsek"), 
            ),
          ),

          // 3. JABATAN
          GoRoute(
            path: RouteNames.positions,
            name: 'positions',
            pageBuilder: (context, state) => NoTransitionPage(
              // Nanti ganti dengan PositionPage()
              child: _buildPlaceholderPage(context, "Jabatan", "Data Pangkat & Jabatan"), 
            ),
          ),

          // 4. WILAYAH
          GoRoute(
            path: RouteNames.regions,
            name: 'regions',
            pageBuilder: (context, state) => NoTransitionPage(
              // Nanti ganti dengan RegionPage()
              child: _buildPlaceholderPage(context, "Wilayah Administratif", "Provinsi, Kab, Kec"), 
            ),
          ),

          // 5. KOMODITI LAHAN
          GoRoute(
            path: RouteNames.commodities,
            name: 'commodities',
            pageBuilder: (context, state) => NoTransitionPage(
              // Nanti ganti dengan CommodityPage()
              child: _buildPlaceholderPage(context, "Komoditi Lahan", "Jenis Tanaman Pangan"), 
            ),
          ),

          // --- MENU LAINNYA ---

          GoRoute(
            path: RouteNames.personnel,
            name: 'personnel',
            pageBuilder: (context, state) => NoTransitionPage(
               child: _buildPlaceholderPage(context, "Data Personel", "Daftar Anggota"), 
            ),
          ),
          
          GoRoute(
            path: RouteNames.landManagement,
            name: 'landManagement',
            pageBuilder: (context, state) => NoTransitionPage(
               child: _buildPlaceholderPage(context, "Kelola Lahan", "Manajemen Lahan Polri"), 
            ),
          ),
        ],
      ),
    ],
  );
});

// --- HELPER PAGE CONTOH (Supaya tidak error saat copy-paste) ---
// Widget ini mensimulasikan halaman dengan Header Breadcrumb untuk kembali ke beranda
Widget _buildPlaceholderPage(BuildContext context, String title, String subtitle) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BREADCRUMB (Navigasi Balik)
          Row(
            children: [
              InkWell(
                onTap: () => context.go(RouteNames.dashboard), // KEMBALI KE BERANDA
                child: const Text(
                  "BERANDA", 
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
                ),
              ),
              const Text("  »  ", style: TextStyle(color: Colors.grey)),
              const Text(
                "DATA UTAMA", 
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)
              ),
              const Text("  »  ", style: TextStyle(color: Colors.grey)),
              Text(
                title.toUpperCase(), 
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. JUDUL HALAMAN
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const Divider(),

          // 3. AREA KONTEN (Tabel biasanya disini)
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.construction, size: 50, color: Colors.orange),
                    const SizedBox(height: 10),
                    Text("Konten $title akan ditampilkan di sini."),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => context.go(RouteNames.dashboard),
                      icon: const Icon(Icons.home),
                      label: const Text("Kembali ke Dashboard"),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}