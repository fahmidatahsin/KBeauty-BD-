import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';

  // Backend base URL
  static const String baseUrl = 'https://kbeauty-bd.onrender.com/api';

  // ============================================================
  // SAVE TOKEN
  // ============================================================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ============================================================
  // CHECK LOGIN
  // ============================================================

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // AUTHENTICATED HEADERS
  // ============================================================

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ============================================================
  // GET LOGGED-IN USER PROFILE
  // ============================================================

  static Future<Map<String, dynamic>> getProfile() async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data['user']);
    }

    throw Exception(data['message'] ?? 'Failed to load profile');
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final headers = await getAuthHeaders();

    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: headers,
      body: jsonEncode({'fullName': fullName, 'email': email, 'phone': phone}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data['user']);
    }

    throw Exception(data['message'] ?? 'Failed to update profile');
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
