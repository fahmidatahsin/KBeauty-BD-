import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'https://kbeauty-bd.onrender.com/api/products';

  static Future<List<Map<String, String>>> getProducts() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid products API response');
    }

    final productsData = decoded['products'];

    if (productsData is! List) {
      throw Exception('Products data is not a list');
    }

    return productsData
        .map<Map<String, String>>((product) {
          if (product is! Map) {
            return <String, String>{};
          }

          // ===============================
          // CATEGORY
          // ===============================

          String categoryName = '';

          final category = product['category'];

          if (category is Map) {
            categoryName = category['name']?.toString().trim() ?? '';
          } else if (category != null) {
            categoryName = category.toString().trim();
          }

          // ===============================
          // BRAND
          // ===============================

          String brandName = '';

          final brand = product['brand'];

          if (brand is Map) {
            brandName = brand['name']?.toString().trim() ?? '';
          } else if (brand != null) {
            brandName = brand.toString().trim();
          }

          // ===============================
          // IMAGE
          // ===============================

          final image = product['image']?.toString().trim() ?? '';

          // ===============================
          // RETURN PRODUCT
          // ===============================

          return {
            'id': product['_id']?.toString() ?? '',
            'name': product['name']?.toString() ?? '',
            'brand': brandName,
            'category': categoryName,
            'price': product['price']?.toString() ?? '0',
            'description': product['description']?.toString() ?? '',
            'image': image,
            'stock': product['stock']?.toString() ?? '0',
            'rating': product['rating']?.toString() ?? '0',
            'numReviews': product['numReviews']?.toString() ?? '0',
            'vegan': product['vegan']?.toString() ?? 'false',
            'newArrival': product['newArrival']?.toString() ?? 'false',
          };
        })
        .where((product) {
          return product['id'] != null && product['id']!.isNotEmpty;
        })
        .toList();
  }
}
