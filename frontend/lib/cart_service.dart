import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CartService {
  static const String _cartUrl = '${AuthService.baseUrl}/cart';

  // ============================================================
  // GET CART
  // ============================================================

  Future<Map<String, dynamic>> getCart() async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.get(Uri.parse(_cartUrl), headers: headers);

    final data = _decodeResponse(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? 'Failed to load cart');
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart(String productId, int quantity) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(
      Uri.parse(_cartUrl),
      headers: headers,
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to add product to cart');
    }
  }

  // ============================================================
  // UPDATE CART
  // ============================================================

  Future<void> updateCart(String productId, int quantity) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.put(
      Uri.parse('$_cartUrl/$productId'),
      headers: headers,
      body: jsonEncode({'quantity': quantity}),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to update cart');
    }
  }

  // ============================================================
  // REMOVE SINGLE ITEM
  // ============================================================

  Future<void> removeFromCart(String productId) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.delete(
      Uri.parse('$_cartUrl/$productId'),
      headers: headers,
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to remove product');
    }
  }

  // ============================================================
  // CLEAR ENTIRE CART
  // ============================================================

  Future<void> clearCart() async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.delete(Uri.parse(_cartUrl), headers: headers);

    final data = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to clear cart');
    }
  }

  // ============================================================
  // RESPONSE DECODER
  // ============================================================

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {'message': 'Unexpected server response'};
    } catch (_) {
      return {'message': 'Server returned an invalid response'};
    }
  }
}
