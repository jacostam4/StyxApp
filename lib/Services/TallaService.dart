import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:styx_app/Models/Talla.dart';
import 'package:styx_app/Utils/token_storage.dart';

class Tallaservice {
  static Future<List<Talla>> fetchAllTallas() async {
    final url = Uri.parse('http://localhost:8074/api/talla/all');
    final token = await TokenStorage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Talla.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar tallas');
    }
  }

  static Future<Talla> fetchTallaById(int idTalla) async {
    final url = Uri.parse('http://localhost:8074/api/talla/$idTalla');
    final token = await TokenStorage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Talla.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar talla');
    }
  }
}
