import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../auth/provider/auth_provider.dart';
import '../shared/widgets/CustomBottomNavBar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      
      // 1. App Bar di Atas
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _TopBar(),
      ),

      // 2. Body (Konten Halaman)
      body: child,

      // 3. Custom Bottom Navigation Bar (Ganti dari BottomNavigationBar biasa)
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

// --- WIDGET TOPBAR ---
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final String location = GoRouterState.of(context).uri.toString();

    // Data User
    final String userName = auth.user?.nama ?? "Tamu";
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : "U";

    // Menentukan Judul berdasarkan Lokasi
    String title = "PRESISI SYSTEM";
    if (location.contains('dashboard')) title = "DASHBOARD";
    else if (location.contains('units')) title = "DATA KESATUAN";
    else if (location.contains('land')) title = "KELOLA LAHAN";
    else if (location.contains('recap')) title = "REKAPITULASI";
    else if (location.contains('personnel')) title = "DATA PERSONEL";
    else if (location.contains('positions')) title = "DATA JABATAN";
    else if (location.contains('regions')) title = "DATA WILAYAH";
    else if (location.contains('commodities')) title = "DATA KOMODITAS";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Sistem Ketahanan Pangan",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),

            const Spacer(),

            // Notifikasi & Profil
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                
                // Profil Dropdown
                PopupMenuButton(
                  offset: const Offset(0, 50),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.orange.shade700,
                    child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.read<AuthProvider>().logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text("Keluar", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}