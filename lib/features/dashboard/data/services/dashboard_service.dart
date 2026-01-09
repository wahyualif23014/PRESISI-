import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/dasboard_model.dart';

class DashboardService {
  // Sesuaikan URL dengan environment Anda
  static const String baseUrl = 'http://10.0.2.2:3000'; 
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<DashboardModel> getDashboardStats() async {
    try {
      // 1. Ambil Token yang tersimpan saat login
      String? token = await _storage.read(key: 'token');

      if (token == null) {
        throw Exception("Token tidak ditemukan, silakan login kembali.");
      }

      // 2. Request ke Backend dengan Header Authorization
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/stats'), // Pastikan endpoint ini benar di backend Anda
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Format umum JWT
        },
      );

      // 3. Cek Status Code
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Asumsi format backend: { status: true, data: { ... } }
        // Jika backend langsung mengembalikan object data, sesuaikan path-nya.
        return DashboardModel.fromJson(data['data']); 
      } else {
        // Jika token expired (401) atau error lain
        throw Exception('Gagal memuat data dashboard: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Lempar error ke Provider
    }
  }
}