import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth_service.dart';

class OrderService {
  static String get baseUrl => '${AuthService.baseUrl}/orders';

  static Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String address,
    required String contactNumber,
    String? paymentMethod,
  }) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        'name': name.trim(),
        'address': address.trim(),
        'contactNumber': contactNumber.trim(),
        if (paymentMethod != null && paymentMethod.trim().isNotEmpty)
          'paymentMethod': paymentMethod.trim(),
      }),
    );

    Map<String, dynamic> data = {};

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map) {
        data = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(data['message'] ?? 'Failed to place order.');
  }
}
