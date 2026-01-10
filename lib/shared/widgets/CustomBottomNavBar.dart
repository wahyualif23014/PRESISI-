import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presisi/router/route_names.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String location = GoRouterState.of(context).uri.toString();

    const Color primaryColor = Color(0xFF7C6FDE);
    const Color inactiveColor = Color(0xFF94A3B8);
    const Color backgroundColor = Colors.white;
    
    final double itemWidth = size.width / 5;
    int currentIndex = _getCurrentIndex(location);

    return Container(
      width: size.width,
      height: 100, // Tinggi diperbesar sedikit agar area sentuh lebih leluasa
      color: Colors.transparent, 
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter, // Align ke bawah
        children: [
          // 1. Background Curve
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80, // Tinggi background putih
            child: _AnimatedCurveBackground(
              currentIndex: currentIndex,
              itemWidth: itemWidth,
              backgroundColor: backgroundColor,
            ),
          ),

          // 2. Navigation Items
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100, // Full height container
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _NavBarItem(
                  index: 0, currentIndex: currentIndex, width: itemWidth,
                  label: "Rekap", icon: Icons.print_outlined, activeIcon: Icons.print_rounded,
                  primaryColor: primaryColor, inactiveColor: inactiveColor,
                  onTap: () => context.go(RouteNames.recap),
                ),
                _NavBarItem(
                  index: 1, currentIndex: currentIndex, width: itemWidth,
                  label: "Data", icon: Icons.storage_outlined, activeIcon: Icons.storage_rounded,
                  primaryColor: primaryColor, inactiveColor: inactiveColor,
                  onTap: () => context.go(RouteNames.units),
                ),
                _NavBarItem(
                  index: 2, currentIndex: currentIndex, width: itemWidth,
                  label: "Beranda", icon: Icons.beach_access_outlined, activeIcon: Icons.beach_access_rounded,
                  primaryColor: primaryColor, inactiveColor: inactiveColor,
                  onTap: () => context.go(RouteNames.dashboard),
                ),
                _NavBarItem(
                  index: 3, currentIndex: currentIndex, width: itemWidth,
                  label: "Lahan", icon: Icons.spa_outlined, activeIcon: Icons.spa_rounded,
                  primaryColor: primaryColor, inactiveColor: inactiveColor,
                  onTap: () => context.go(RouteNames.landManagement),
                ),
                _NavBarItem(
                  index: 4, currentIndex: currentIndex, width: itemWidth,
                  label: "Personel", icon: Icons.person_outline, activeIcon: Icons.person_rounded,
                  primaryColor: primaryColor, inactiveColor: inactiveColor,
                  onTap: () => context.go(RouteNames.personnel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(String location) {
    if (location == RouteNames.recap) return 0;
    if (location.startsWith('/units') || location.startsWith('/positions') || location.startsWith('/regions') || location.startsWith('/commodities')) return 1;
    if (location == RouteNames.dashboard) return 2;
    if (location.startsWith('/land')) return 3;
    if (location.startsWith('/personnel')) return 4;
    return 2; 
  }
}

class _AnimatedCurveBackground extends StatelessWidget {
  final int currentIndex;
  final double itemWidth;
  final Color backgroundColor;

  const _AnimatedCurveBackground({
    required this.currentIndex,
    required this.itemWidth,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: currentIndex.toDouble()),
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      builder: (context, value, child) {
        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 80),
          painter: _CurvePainter(
            position: value,
            itemWidth: itemWidth,
            color: backgroundColor,
          ),
        );
      },
    );
  }
}

class _CurvePainter extends CustomPainter {
  final double position;
  final double itemWidth;
  final Color color;

  _CurvePainter({
    required this.position,
    required this.itemWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);

    double loc = (position * itemWidth) + (itemWidth / 2);
    double curveWidth = itemWidth * 0.85; 

    // Garis lurus kiri
    path.lineTo(loc - (curveWidth / 2) - 20, 0);

    // CURVE: Lebih menonjol ke atas (-35)
    path.cubicTo(
      loc - (curveWidth / 2.5), 0,    
      loc - (curveWidth / 3.0), -35,  
      loc, -35,                       
    );

    path.cubicTo(
      loc + (curveWidth / 3.0), -35,  
      loc + (curveWidth / 2.5), 0,    
      loc + (curveWidth / 2) + 20, 0, 
    );

    // Garis lurus kanan
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.04), 6, true); 
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final double width;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color primaryColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.width,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.primaryColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: 100, // Match parent height
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Posisi Icon Dinaikkan
            // Top 10: Ikon aktif naik ke puncak curve
            // Top 40: Ikon tidak aktif di posisi standar bawah
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              top: isSelected ? 10 : 40, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(isSelected ? 14 : 0),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      size: isSelected ? 28 : 26,
                      color: isSelected ? Colors.white : inactiveColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1.0 : 1.0,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? primaryColor : inactiveColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}