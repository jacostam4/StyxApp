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

  static Future<void> crearProducto(Product producto) async {
    final url = Uri.parse('http://localhost:8074/api/producto/register');
    final token = await TokenStorage.getToken();

    final body = jsonEncode({
      "id_categoria": producto.idCategoria,
      "nombre": producto.nombre,
      "costo": producto.costo,
      "precio": producto.precio,
      "referencia": producto.referencia,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Producto creado correctamente');
    } else {
      print(
        'Error al crear producto: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al crear producto');
    }
  }

  static Future<Product> fetchProductoById(int idProducto) async {
    final url = Uri.parse(
      'http://localhost:8074/api/producto/search/$idProducto',
    );
    final token = await TokenStorage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      print(
        'Error al obtener producto: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al obtener producto');
    }
  }

  static Future<void> actualizarProducto(Product producto) async {
    final url = Uri.parse(
      'http://localhost:8074/api/producto/update/${producto.idProducto}',
    );
    final token = await TokenStorage.getToken();

    final body = jsonEncode({
      "id_categoria": producto.idCategoria,
      "nombre": producto.nombre,
      "costo": producto.costo,
      "precio": producto.precio,
      "referencia": producto.referencia,
    });

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Producto actualizado correctamente');
    } else {
      print(
        'Error al actualizar producto: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al actualizar producto');
    }
  }
}
