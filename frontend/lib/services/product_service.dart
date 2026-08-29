import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://localhost:5000/api/products';

  static Future<List<Map<String, String>>> getProducts() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    // ===============================
    // CHECK API RESPONSE
    // ===============================

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid products API response');
    }

    final productsData = decoded['products'];

    if (productsData is! List) {
      throw Exception('Products data is not a list');
    }

    // ===============================
    // CONVERT PRODUCTS
    // ===============================

    return productsData
        .map<Map<String, String>>((product) {
          if (product is! Map) {
            return <String, String>{};
          }

          // -------------------------------
          // CATEGORY SAFE HANDLING
          // -------------------------------

          String categoryName = '';

          final category = product['category'];

          if (category is Map) {
            categoryName = category['name']?.toString() ?? '';
          } else if (category != null) {
            categoryName = category.toString();
          }

          // -------------------------------
          // IMAGE
          // -------------------------------

          final image = product['image']?.toString() ?? '';

          // -------------------------------
          // RETURN PRODUCT
          // -------------------------------

          return {
            'id': product['_id']?.toString() ?? '',
            'name': product['name']?.toString() ?? '',
            'brand': product['brand']['name'].toString(),
            'category': categoryName,
            'price': product['price']?.toString() ?? '0',
            'description': product['description']?.toString() ?? '',
            'image': image,
            'stock': product['stock']?.toString() ?? '0',
            'rating': product['rating']?.toString() ?? '0',
            'numReviews': product['numReviews']?.toString() ?? '0',

            // These may or may not exist in backend
            'vegan': product['vegan']?.toString() ?? 'false',
            'newArrival': product['newArrival']?.toString() ?? 'false',
          };
        })
        .where((product) {
          // Empty/invalid products বাদ দিচ্ছি
          return product['id'] != null && product['id']!.isNotEmpty;
        })
        .toList();
  }
}
