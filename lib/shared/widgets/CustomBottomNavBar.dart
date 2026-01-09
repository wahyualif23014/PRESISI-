import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presisi/router/route_names.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 5;
    final String location = GoRouterState.of(context).uri.toString();

    const Color primaryColor = Color(0xFF7C6FDE);
    const Color inactiveColor = Color(0xFFB0B0B0);

    return SizedBox(
      width: size.width,
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
          ),

          // Item navigasi (kiri & kanan)
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _NavBarItem(
                    width: itemWidth,
                    label: "Rekapitulasi",
                    icon: Icons.print_outlined,
                    activeIcon: Icons.print,
                    isSelected: location == RouteNames.recap,
                    activeColor: primaryColor,
                    inactiveColor: inactiveColor,
                    onTap: () => context.go(RouteNames.recap),
                  ),

                  // Item 2: Data Utama
                  _NavBarItem(
                    width: itemWidth,
                    label: "Data Utama",
                    icon: Icons.storage_outlined,
                    activeIcon: Icons.storage,
                    isSelected: location.startsWith('/units') ||
                        location.startsWith('/positions') ||
                        location.startsWith('/regions') ||
                        location.startsWith('/commodities'),
                    activeColor: primaryColor,
                    inactiveColor: inactiveColor,
                    onTap: () => context.go(RouteNames.units),
                  ),

                  SizedBox(width: itemWidth),

                  // Item 4: Kelola Lahan
                  _NavBarItem(
                    width: itemWidth,
                    label: "Kelola Lahan",
                    icon: Icons.spa_outlined,
                    activeIcon: Icons.spa,
                    isSelected: location.startsWith('/land'),
                    activeColor: primaryColor,
                    inactiveColor: inactiveColor,
                    onTap: () => context.go(RouteNames.landManagement),
                  ),

                  // Item 5: Personel
                  _NavBarItem(
                    width: itemWidth,
                    label: "Personel",
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    isSelected: location.startsWith('/personnel'),
                    activeColor: primaryColor,
                    inactiveColor: inactiveColor,
                    onTap: () => context.go(RouteNames.personnel),
                  ),
                ],
              ),
            ),
          ),

          // Floating Button Beranda (Tengah Atas)
          Positioned(
            bottom: 25,
            left: (size.width / 2) - 30,
            child: _FloatingHomeButton(
              isSelected: location == RouteNames.dashboard,
              primaryColor: primaryColor,
              onTap: () => context.go(RouteNames.dashboard),
            ),
          ),

          // Label "Beranda" di bawah floating button
          Positioned(
            bottom: 8,
            left: (size.width / 2) - (itemWidth / 2),
            width: itemWidth,
            child: Text(
              "Beranda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: location == RouteNames.dashboard
                    ? primaryColor
                    : inactiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SUB-WIDGET: ITEM NAVIGASI BIASA
// ==========================================
class _NavBarItem extends StatelessWidget {
  final double width;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.width,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon dengan animasi scale
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 4),
                // Label
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingHomeButton extends StatelessWidget {
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _FloatingHomeButton({
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              blurRadius: 25,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: Icon(
          Icons.beach_access,
          color: Colors.white,
          size: isSelected ? 32 : 28,
        ),
      ),
    );
  }
}