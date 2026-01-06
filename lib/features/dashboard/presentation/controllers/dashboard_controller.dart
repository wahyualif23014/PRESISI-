import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dashboard_repository.dart';
import '../../data/model/dasboard_model.dart';

// Provider Controller
final dashboardControllerProvider = 
    AsyncNotifierProvider<DashboardController, DashboardModel>(() {
  return DashboardController();
});

class DashboardController extends AsyncNotifier<DashboardModel> {
  @override
  Future<DashboardModel> build() async {
    // Panggil Repository
    final repo = ref.read(dashboardRepositoryProvider);
    return repo.getDashboardData();
  }

  // Fungsi Refresh (Tarik untuk menyegarkan)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}