import 'package:flutter/material.dart';
import '../../../features/dashboard/data/model/dasboard_model.dart';
import '../../../features/dashboard/data/services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service = DashboardService();

  // --- STATE ---
  DashboardModel? _data;
  bool _isLoading = false;
  String? _errorMessage;

  // --- GETTERS ---
  DashboardModel? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- ACTIONS ---
  
  // Fungsi untuk memuat data dashboard
  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      // Panggil Service
      final result = await _service.getDashboardStats();
      
      _data = result;
      _isLoading = false;
      notifyListeners(); // Beritahu UI data sudah siap

    } catch (e) {
      print("Error Dashboard: $e");
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners(); // Beritahu UI terjadi error
    }
  }

  // Fungsi untuk refresh (misal pull-to-refresh)
  Future<void> refresh() async {
    await fetchDashboardData();
  }
}