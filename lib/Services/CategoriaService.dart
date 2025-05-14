import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/Categoria.dart';
import '../Utils/token_storage.dart';

class CategoriaService {
  final String _baseUrl = 'http://localhost:8074/api/categoria';

  Future<List<Categoria>> getCategorias() async {
    final url = Uri.parse('$_baseUrl/all');
    final token = await TokenStorage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Categoria.fromJson(e)).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('Error al cargar categorías');
    }
  }
}
