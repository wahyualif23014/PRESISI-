import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- IMPORT FILE ANDA ---
import 'auth/provider/auth_provider.dart';
import 'core/router/router_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Setup Formatting Tanggal
  await initializeDateFormatting('id_ID');

  // 2. Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://hbrcteaygmjrzwjyuzje.supabase.co',
    anonKey: 'sb_publishable_iSnXoF0gzV6j3A4-ynRwwQ_ck5tg477',
  );

  // 3. Setup Auth Provider
  final authProvider = AuthProvider();
  
  // Cek Auto Login (tunggu sampai selesai)
  await authProvider.tryAutoLogin();

  // 4. Setup Router (Masukkan authProvider)
  final appRouter = AppRouter(authProvider);

  // 5. Global Error Handling (PENTING: Agar error tidak bikin blank putih)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
      ],
      // PENTING: Pastikan appRouter dikirim ke sini!
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  // Constructor wajib menerima appRouter
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sistem Ketahanan Pangan Presisi',
      debugShowCheckedModeBanner: false,

      // --- KONEKSI ROUTER ---
      routerConfig: appRouter.router,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),

      // Theme
      theme: _lightTheme,
      themeMode: ThemeMode.light,

      // Error Builder yang Aman (Anti Crash Loop)
      builder: (context, child) {
        ErrorWidget.builder = (details) {
          return const _GlobalErrorView(); 
        };
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

/* ===================== THEME ===================== */

final ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

/* ===================== ERROR UI (DIPERBAIKI) ===================== */

class _GlobalErrorView extends StatelessWidget {
  const _GlobalErrorView();

  @override
  Widget build(BuildContext context) {
    // FIX: Bungkus dengan Directionality agar tidak crash jika MaterialApp mati
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Terjadi Kesalahan Aplikasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Silakan restart aplikasi.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}