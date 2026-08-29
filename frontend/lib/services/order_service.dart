import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth_service.dart';

class OrderService {
  static const String baseUrl = 'http://localhost:5000/api/orders';

  // ============================================================
  // PLACE ORDER
  // ============================================================

  static Future<Map<String, dynamic>> placeOrder() async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(Uri.parse(baseUrl), headers: headers);

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data['message'] ?? 'Failed to place order.');
  }
}
