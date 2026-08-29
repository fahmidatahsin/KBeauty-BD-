import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth_service.dart';

class OrderService {
  static const String baseUrl = 'https://kbeauty-bd.onrender.com/api/orders';

  static Future<Map<String, dynamic>> placeOrder({
    required String customerName,
    required String address,
    required String contactNo,
  }) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        'customerName': customerName,
        'address': address,
        'contactNo': contactNo,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data['message'] ?? 'Failed to place order.');
  }
}
