import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ganti Riverpod ke Provider
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';
import '../../auth/provider/auth_provider.dart'; // Import AuthProvider

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final String displayName = user?.nama.toUpperCase() ?? "TAMU";
    final String displayRole = user?.role ?? "User";
    
    final String initial = displayName.isNotEmpty ? displayName[0] : "U";

    return Container(
      width: 260, // Lebar standar sidebar
      color: const Color(0xFF343A40), 
      child: Column(
        children: [
          // BAGIAN 1: HEADER & PROFILE
          _buildHeader(),
          
          _buildUserProfile(
            name: displayName, 
            role: displayRole,
            initial: initial,
          ), 
          
          const Divider(color: Colors.white10, height: 1),

          // BAGIAN 2: MENU LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                // A. Menu Beranda
                _SidebarItem(
                  title: "BERANDA",
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  isSelected: location == RouteNames.dashboard,
                  onTap: () => context.go(RouteNames.dashboard),
                ),

                // B. Menu Data Utama (Accordion)
                _SidebarExpansion(
                  title: "DATA UTAMA",
                  icon: Icons.folder_open,
                  activeIcon: Icons.folder,
                  initiallyExpanded: location == RouteNames.units || 
                                     location == RouteNames.positions ||
                                     location == RouteNames.regions ||
                                     location == RouteNames.commodities,
                  children: [
                    _SidebarSubItem(
                      title: "Tingkat Kesatuan",
                      isSelected: location == RouteNames.units,
                      onTap: () => context.go(RouteNames.units),
                    ),
                    _SidebarSubItem(
                      title: "Jabatan",
                      isSelected: location == RouteNames.positions,
                      onTap: () => context.go(RouteNames.positions),
                    ),
                    _SidebarSubItem(
                      title: "Wilayah Administratif",
                      isSelected: location == RouteNames.regions,
                      onTap: () => context.go(RouteNames.regions),
                    ),
                    _SidebarSubItem(
                      title: "Komoditi Lahan",
                      isSelected: location == RouteNames.commodities,
                      onTap: () => context.go(RouteNames.commodities),
                    ),
                  ],
                ),

                // C. Menu Lainnya
                _SidebarItem(
                  title: "DATA PERSONEL",
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  isSelected: location == RouteNames.personnel,
                  onTap: () => context.go(RouteNames.personnel),
                ),
                 _SidebarItem(
                  title: "KELOLA LAHAN",
                  icon: Icons.agriculture_outlined,
                  activeIcon: Icons.agriculture,
                  isSelected: location == RouteNames.landManagement,
                  onTap: () => context.go(RouteNames.landManagement),
                ),
                _SidebarItem(
                  title: "REKAPITULASI",
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  isSelected: location == RouteNames.recap,
                  onTap: () => context.go(RouteNames.recap),
                ),
              ],
            ),
          ),
          
          // BAGIAN 3: FOOTER
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: const Text(
              "BIRO SDM POLDA JATIM © 2025",
              style: TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER (Private) ---

  Widget _buildHeader() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      color: const Color(0xFF2B3035), 
      child: const Row(
        children: [
          Icon(Icons.eco, color: Colors.orange, size: 28),
          SizedBox(width: 12),
          Text(
            "SIKAP PRESISI",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile({
    required String name, 
    required String role, 
    required String initial
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade700, 
            radius: 20,
            child: Text(
              initial, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w600, 
                    fontSize: 14
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  role, 
                  style: const TextStyle(color: Colors.grey, fontSize: 11)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 1. Item Menu Biasa (Single)
class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.title, 
    required this.icon, 
    this.activeIcon,
    required this.isSelected, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          isSelected ? (activeIcon ?? icon) : icon, 
          color: isSelected ? Colors.white : Colors.grey[400],
          size: 22,
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400], 
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal
          )
        ),
        hoverColor: Colors.white.withOpacity(0.05),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}

// 2. Item Sub-Menu (Indented)
class _SidebarSubItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarSubItem({
    required this.title, 
    required this.isSelected, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          Icons.circle, 
          size: 6, 
          color: isSelected ? Colors.orange : Colors.grey[600]
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: isSelected ? Colors.orangeAccent : Colors.grey[400], 
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
          )
        ),
        contentPadding: const EdgeInsets.only(left: 24, right: 8), 
        dense: true,
        visualDensity: const VisualDensity(vertical: -2), // Lebih rapat
        onTap: onTap,
      ),
    );
  }
}

// 3. Wrapper Accordion (Dropdown)
class _SidebarExpansion extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? activeIcon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _SidebarExpansion({
    required this.title, 
    required this.icon, 
    this.activeIcon,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey(title), // Agar status expanded tersimpan saat scroll
        leading: Icon(
          initiallyExpanded ? (activeIcon ?? icon) : icon, 
          color: initiallyExpanded ? Colors.white : Colors.grey[400],
          size: 22,
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: initiallyExpanded ? Colors.white : Colors.grey[400], 
            fontSize: 13,
            fontWeight: initiallyExpanded ? FontWeight.w600 : FontWeight.normal
          )
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.grey[600],
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: children,
      ),
    );
  }
}