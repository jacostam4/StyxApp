import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:styx_app/Models/Almacen.dart';
import 'package:styx_app/Utils/token_storage.dart';

class Almacenservice {
  static Future<List<Almacen>> getAlmacenes() async {
    final url = Uri.parse('http://localhost:8074/api/almacen/all');
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
      return data.map((json) => Almacen.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar almacenes');
    }
  }

  static Future<Almacen> getAlmacenById(int idAlmacen) async {
    final url = Uri.parse('http://localhost:8074/api/almacen/$idAlmacen');
    final token = await TokenStorage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Almacen.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar almacen');
    }
  }
}
