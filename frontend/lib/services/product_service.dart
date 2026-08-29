import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://localhost:5000/api/products';

  static Future<List<Map<String, String>>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['products'];

      return products.map<Map<String, String>>((product) {
        return {
          'id': product['_id'].toString(),
          'name': product['name'].toString(),
          'brand': product['brand'].toString(),
          'category': product['category']['name'].toString(),
          'price': product['price'].toString(),
          'description': product['description'].toString(),
          'image': product['image'].toString(),
          'stock': product['stock'].toString(),
          'rating': product['rating'].toString(),
          'numReviews': product['numReviews'].toString(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
