import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/ProductoImagen.dart';
import '../Utils/token_storage.dart';

class ProductoImagenService {
  static Future<List<ProductoImagen>> fetchImagenesPorProducto(
    int idProducto,
  ) async {
    final url = Uri.parse(
      'http://localhost:8074/api/producto-imagen/search/$idProducto',
    );

    final token = await TokenStorage.getToken(); // Obtener el token
    print('TOKEN: $token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Añadir el token al encabezado
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductoImagen.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar imágenes del producto');
    }
  }
}
