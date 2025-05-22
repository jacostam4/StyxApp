import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventario.dart';
import '../utils/token_storage.dart';

class InventarioService {
  final String baseUrl = 'http://localhost:8074/api/inventario';

  Future<List<Inventario>> getAllInventarios() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Inventario.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener inventarios');
    }
  }

  Future<Inventario> getInventarioById(int id) async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/search/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Inventario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener inventario con ID $id');
    }
  }

  Future<List<Inventario>> getInventariosByProducto(int idProducto) async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/producto/$idProducto'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Inventario.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener inventarios por producto');
    }
  }

  Future<List<Inventario>> getInventariosByAlmacen(int idAlmacen) async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/almacen/$idAlmacen'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Inventario.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener inventarios por almacén');
    }
  }

  Future<Inventario> registerInventario(Inventario inventario) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(inventario.toJson()),
    );

    if (response.statusCode == 200) {
      return Inventario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al registrar inventario');
    }
  }

  Future<Inventario> updateInventario(int id, Inventario inventario) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(inventario.toJson()),
    );

    if (response.statusCode == 200) {
      return Inventario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar inventario');
    }
  }

  Future<void> deleteInventario(int id) async {
    final token = await TokenStorage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar inventario');
    }
  }
}
