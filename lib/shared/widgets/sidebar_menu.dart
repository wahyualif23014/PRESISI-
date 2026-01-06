// lib/shared/widgets/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';

class SidebarMenu extends ConsumerWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final String location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 250, // Lebar Sidebar
      color: const Color(0xFF343A40), // Warna background gelap
      child: Column(
        children: [
          // BAGIAN 1: HEADER & PROFILE
          _buildHeader(),
          // Nanti User data bisa diambil dari Provider (ref.watch(userProvider))
          _buildUserProfile(name: "DIO VLADIKA", role: "Polda Jatim"), 
          const Divider(color: Colors.white24),

          // BAGIAN 2: MENU LIST
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // A. Menu Beranda
                _SidebarItem(
                  title: "BERANDA",
                  icon: Icons.dashboard,
                  isSelected: location == RouteNames.dashboard,
                  onTap: () => context.go(RouteNames.dashboard),
                ),

                // B. Menu Data Utama (Accordion)
                _SidebarExpansion(
                  title: "DATA UTAMA",
                  icon: Icons.folder,
                  // Cek apakah salah satu child aktif agar accordion tetap terbuka (opsional)
                  initiallyExpanded: location == RouteNames.commodities || 
                                     location == RouteNames.regions, 
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
                  icon: Icons.person,
                  isSelected: location == RouteNames.personnel,
                  onTap: () => context.go(RouteNames.personnel),
                ),
                 _SidebarItem(
                  title: "KELOLA LAHAN",
                  icon: Icons.agriculture,
                  isSelected: location == RouteNames.landManagement,
                  onTap: () => context.go(RouteNames.landManagement),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
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

  // --- WIDGET KECIL (HELPER) ---

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco, color: Colors.orange),
          SizedBox(width: 10),
          Text(
            "SIKAP PRESISI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile({required String name, required String role}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.grey, 
            child: Text("DV", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(role, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}

// Item Menu Biasa (Single)
class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.title, required this.icon, required this.isSelected, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 13)),
      tileColor: isSelected ? Colors.white.withOpacity(0.1) : null,
      onTap: onTap,
    );
  }
}

// Item Sub-Menu (Indented)
class _SidebarSubItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarSubItem({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.circle, size: 6, color: isSelected ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 12)),
      contentPadding: const EdgeInsets.only(left: 32), // Indentasi ke dalam
      tileColor: isSelected ? Colors.white.withOpacity(0.05) : null,
      onTap: onTap,
    );
  }
}

// Wrapper Accordion (Dropdown)
class _SidebarExpansion extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _SidebarExpansion({
    required this.title, 
    required this.icon, 
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Hilangkan garis border bawaan ExpansionTile
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
        iconColor: Colors.grey,
        collapsedIconColor: Colors.grey,
        initiallyExpanded: initiallyExpanded,
        children: children,
      ),
    );
  }
}