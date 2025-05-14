import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/Product.dart';
import '../Utils/token_storage.dart';

class ProductoService {
  static Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('http://localhost:8074/api/producto/all');

    final token = await TokenStorage.getToken();
    print('TOKEN: $token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar productos');
    }
  }
}
