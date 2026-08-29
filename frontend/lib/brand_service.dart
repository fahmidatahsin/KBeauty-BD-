import 'dart:convert';
import 'package:http/http.dart' as http;

class BrandService {
  static const String baseUrl = 'https://kbeauty-bd.onrender.com/api';

  static Future<List<String>> getBrands() async {
    final response = await http.get(Uri.parse('$baseUrl/brands'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<String>((brand) => brand['name'].toString()).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }
}
