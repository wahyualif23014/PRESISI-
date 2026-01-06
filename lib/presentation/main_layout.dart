// lib/presentation/main_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/sidebar_menu.dart'; 

// 1. CLASS NOTIFIER: Pengganti StateProvider untuk Riverpod terbaru
class SidebarController extends Notifier<bool> {
  @override
  bool build() {
    return true; // Default state: Sidebar Terbuka (true)
  }

  void toggle() {
    state = !state; // Membalik nilai (true jadi false, dst)
  }
}

// 2. PROVIDER: Daftarkan Notifier di atas
final sidebarOpenProvider = NotifierProvider<SidebarController, bool>(SidebarController.new);

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. WATCH: Memantau status sidebar (true/false)
    final isSidebarOpen = ref.watch(sidebarOpenProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), 
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4. LOGIC: Tampilkan sidebar hanya jika isSidebarOpen == true
          if (isSidebarOpen) 
            const SidebarMenu(),

          // 5. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                // Header (Pass 'ref' untuk akses tombol)
                _buildTopBar(context, ref),

                // Isi Halaman
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0), 
                    child: child, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Header
  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    final String title = _getTitleFromRoute(location);
    
    // Ambil status untuk menentukan icon
    final isSidebarOpen = ref.watch(sidebarOpenProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12)), 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bagian Kiri: Tombol Menu & Judul
          Row(
            children: [
              // TOMBOL TOGGLE SIDEBAR
              IconButton(
                icon: Icon(
                  isSidebarOpen ? Icons.menu_open : Icons.menu, 
                  color: Colors.black54
                ),
                onPressed: () {
                  // Memanggil fungsi toggle dari SidebarController
                  ref.read(sidebarOpenProvider.notifier).toggle();
                },
              ),
              const SizedBox(width: 10),
              
              // Judul Halaman
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),

          // Area Kanan Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const Icon(Icons.help_outline, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  String _getTitleFromRoute(String location) {
    if (location.contains('dashboard')) return 'Dashboard';
    if (location.contains('units')) return 'Tingkat Kesatuan';
    if (location.contains('regions')) return 'Wilayah Administratif';
    if (location.contains('commodities')) return 'Komoditi Lahan';
    if (location.contains('personnel')) return 'Data Personel';
    if (location.contains('land')) return 'Kelola Lahan';
    return 'Aplikasi Presisi';
  }
}