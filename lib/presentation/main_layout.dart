import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Import AuthProvider untuk mengambil data user & logout
import '../auth/provider/auth_provider.dart';

// Import Sidebar Menu Anda (Pastikan path-nya benar)
import '../shared/widgets/sidebar_menu.dart'; 

// 1. STATE MANAGEMENT SIDEBAR (Lokal untuk Layout ini saja)
class SidebarProvider with ChangeNotifier {
  bool _isOpen = true;

  bool get isOpen => _isOpen;

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

// 2. MAIN LAYOUT
class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Kita bungkus Layout dengan SidebarProvider agar state sidebar hidup selama Layout aktif
    return ChangeNotifierProvider(
      create: (_) => SidebarProvider(),
      child: const _MainLayoutContent(),
    );
  }
}

// Private Widget untuk konten agar bisa akses context SidebarProvider
class _MainLayoutContent extends StatelessWidget {
  const _MainLayoutContent();

  @override
  Widget build(BuildContext context) {
    final sidebar = context.watch<SidebarProvider>();
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    // Jika Mobile, sidebar default tertutup. Jika Desktop, ikuti state provider.
    final showDesktopSidebar = !isMobile && sidebar.isOpen;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      // Drawer hanya muncul di Mobile
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: showDesktopSidebar ? 260 : 0,
            child: showDesktopSidebar 
              ? const SidebarMenu() // Pastikan Widget SidebarMenu Anda handle overflow
              : null, 
          ),

          Expanded(
            child: Column(
              children: [
                // TopBar
                _TopBar(isMobile: isMobile),
                
                Expanded(
                  child: Builder(builder: (context) {
                    final mainLayout = context.findAncestorWidgetOfExactType<MainLayout>();
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
                      child: Container(
                        color: const Color(0xFFF4F6F9),
                        width: double.infinity,
                        // Child diambil dari parent widget
                        child: mainLayout?.child ?? const SizedBox.shrink(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. WIDGET TOPBAR
class _TopBar extends StatelessWidget {
  final bool isMobile;
  const _TopBar({required this.isMobile});

  String _getTitle(String location) {
    if (location.contains('dashboard')) return 'Dashboard';
    if (location.contains('units')) return 'Tingkat Kesatuan';
    if (location.contains('positions')) return 'Jabatan';
    if (location.contains('regions')) return 'Wilayah';
    if (location.contains('commodities')) return 'Komoditi';
    if (location.contains('personnel')) return 'Personel';
    if (location.contains('land')) return 'Kelola Lahan';
    if (location.contains('recap')) return 'Rekapitulasi';
    return 'Presisi';
  }

  @override
  Widget build(BuildContext context) {
    final sidebar = context.watch<SidebarProvider>();
    final auth = context.watch<AuthProvider>(); // Ambil data user
    final String location = GoRouterState.of(context).uri.toString();

    // Data User dari Provider
    final String userName = auth.user?.nama ?? "Tamu";
    final String userRole = auth.user?.role ?? "";
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : "U";

    return Container(
      height: 70, // Sedikit dikecilkan agar lebih modern
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isMobile ? const Color(0xFFF4F6F9) : Colors.white,
        border: isMobile ? null : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Tombol Menu Toggle
            IconButton(
              icon: Icon(
                isMobile 
                  ? Icons.menu 
                  : (sidebar.isOpen ? Icons.menu_open : Icons.menu),
                color: Colors.black87,
              ),
              onPressed: () {
                if (isMobile) {
                  Scaffold.of(context).openDrawer();
                } else {
                  context.read<SidebarProvider>().toggle();
                }
              },
            ),
            const SizedBox(width: 12),
            
            // Judul Halaman
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(location).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Breadcrumb kecil opsional
                  if (!isMobile)
                    Text(
                      "Sistem Ketahanan Pangan",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                ],
              ),
            ),

            // Action Buttons
            Row(
              children: [
                _HeaderNotificationButton(
                  count: 3, 
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                
                // Profil dengan Popup Menu untuk Logout
                PopupMenuButton(
                  offset: const Offset(0, 50),
                  child: _HeaderProfileButton(
                    userName: userName,
                    initial: initial,
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      // Panggil fungsi logout dari AuthProvider
                      context.read<AuthProvider>().logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(userRole, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const Divider(),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey),
                          SizedBox(width: 8),
                          Text("Profil Saya"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
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

// 4. WIDGET KECIL (Helper)
class _HeaderNotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _HeaderNotificationButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.notifications_outlined, color: Colors.black54),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 8, top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text(
                '$count', 
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderProfileButton extends StatelessWidget {
  final String userName;
  final String initial;

  const _HeaderProfileButton({required this.userName, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade700,
            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(width: 8),
          if (MediaQuery.of(context).size.width > 600)
            Text(
              userName, 
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}