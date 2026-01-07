import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/sidebar_menu.dart'; 

// 1. CONTROLLER SIDEBAR
class SidebarController extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}

final sidebarOpenProvider = NotifierProvider<SidebarController, bool>(SidebarController.new);

// 2. MAIN LAYOUT
class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    final bool isSidebarOpen = ref.watch(sidebarOpenProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Desktop (Fixed)
          if (!isMobile && isSidebarOpen)
            const SizedBox(
              width: 260,
              child: SidebarMenu(),
            ),

          // Area Konten Utama
          Expanded(
            child: Column(
              children: [
                // TopBar (Header dengan tombol Profil/Notif)
                _TopBar(isMobile: isMobile),
                
                // Konten Halaman (Child dari Router)
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
                    child: Container(
                      color: const Color(0xFFF4F6F9),
                      width: double.infinity,
                      child: child, 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. WIDGET TOPBAR (Private)
class _TopBar extends ConsumerWidget {
  final bool isMobile;
  const _TopBar({required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    final isSidebarOpen = ref.watch(sidebarOpenProvider);

    // TODO: Hubungkan data ini dengan Provider User Anda
    const String userName = "Budi Santoso";
    const String? profileImageUrl = null;
    const int notificationCount = 3;

    return Container(
      height: 80, 
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isMobile ? const Color(0xFFF4F6F9) : Colors.white,
        border: isMobile ? null : const Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: SafeArea( 
        bottom: false,
        child: Row(
          children: [
            // Tombol Menu Sidebar
            IconButton(
              icon: Icon(
                isMobile 
                    ? Icons.menu 
                    : (isSidebarOpen ? Icons.menu_open : Icons.menu),
                color: Colors.black87
              ),
              onPressed: () {
                if (isMobile) {
                  Scaffold.of(context).openDrawer();
                } else {
                  ref.read(sidebarOpenProvider.notifier).toggle();
                }
              },
            ),
            const SizedBox(width: 12),
            
            // Judul Halaman
            Expanded(
              child: Text(
                _getTitle(location).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14, 
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action Buttons (Notif & Profil)
            Row(
              children: [
                _HeaderNotificationButton(
                  count: notificationCount,
                  onTap: () => print("Notif tapped"),
                ),
                const SizedBox(width: 12),
                _HeaderProfileButton(
                  userName: userName,
                  imageUrl: profileImageUrl,
                  onTap: () => print("Profile tapped"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getTitle(String location) {
    if (location.contains('dashboard')) return 'Dashboard';
    if (location.contains('units')) return 'Tingkat Kesatuan';
    if (location.contains('regions')) return 'Wilayah';
    if (location.contains('commodities')) return 'Komoditi';
    if (location.contains('personnel')) return 'Personel';
    if (location.contains('land')) return 'Kelola Lahan';
    return 'Presisi';
  }
}

// 4. WIDGET PENDUKUNG (Private)
class _HeaderNotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _HeaderNotificationButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 768;
    return SizedBox(
      width: isSmall ? 40 : 44,
      height: isSmall ? 40 : 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(30),
              child: Center(
                child: Icon(Icons.notifications_outlined, color: Colors.black54, size: 22),
              ),
            ),
          ),
          if (count > 0)
            Positioned(
              right: 0, top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderProfileButton extends StatelessWidget {
  final String userName;
  final String? imageUrl;
  final VoidCallback onTap;

  const _HeaderProfileButton({required this.userName, this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 768;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isSmall ? 40 : 44,
        height: isSmall ? 40 : 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
          image: imageUrl != null 
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) 
            : null,
          color: Colors.blueAccent,
        ),
        child: imageUrl == null
          ? Center(child: Text(userName.isNotEmpty ? userName[0] : 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
          : null,
      ),
    );
  }
}