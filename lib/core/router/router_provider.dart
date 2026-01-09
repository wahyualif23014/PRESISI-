import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

// Import Auth Provider & Pages
import '../../auth/provider/auth_provider.dart';
import '../../auth/pages/login_screen.dart';
import '../../auth/pages/register_screen.dart';

import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../presentation/main_layout.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.dashboard,
    refreshListenable: authProvider,
    
    // Logic Redirect
    redirect: (context, state) {
      final bool isLoggedIn = authProvider.isAuth;
      final bool isLoading = authProvider.isLoading;

      if (isLoading) return null;

      final String location = state.matchedLocation;
      final bool isGoingToLogin = location == RouteNames.login;
      final bool isGoingToRegister = location == RouteNames.register;

      // Jika belum login
      if (!isLoggedIn) {
        if (isGoingToLogin || isGoingToRegister) {
          return null;
        }
        return RouteNames.login;
      }

      // Jika sudah login
      if (isLoggedIn) {
        if (isGoingToLogin || isGoingToRegister) {
          return RouteNames.dashboard;
        }
      }

      return null;
    },

    routes: [
      // 1. Login
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),

      // 2. Register
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),

      // 3. Shell Route (Halaman Utama dengan Navbar/Sidebar)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // A. Dashboard (Terhubung ke File Asli)
          GoRoute(
            path: RouteNames.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),

          // B. Placeholder Menu Lain (Agar tidak error saat diklik)
          GoRoute(
            path: RouteNames.units,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Scaffold(body: Center(child: Text("Halaman Data Kesatuan"))),
            ),
          ),
          GoRoute(
            path: RouteNames.personnel,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Scaffold(body: Center(child: Text("Halaman Data Personel"))),
            ),
          ),
          GoRoute(
            path: RouteNames.landManagement,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Scaffold(body: Center(child: Text("Halaman Manajemen Lahan"))),
            ),
          ),
        ],
      ),
    ],
  );
}