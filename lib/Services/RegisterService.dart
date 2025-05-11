import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  static Future<String?> registerUser({
    required String nombre,
    required String correo,
    required String telefono,
    required String tipoDoc,
    required String numeroDoc,
    required String direccion,
    required String contrasena,
  }) async {
    final url = Uri.parse('http://localhost:8074/api/usuario/register');
    final data = {
      "nombre": nombre,
      "correo": correo,
      "telefono": telefono,
      "idRol": 2, // Siempre cliente
      "tipoDoc": tipoDoc,
      "numeroDoc": numeroDoc,
      "direccion": direccion,
      "contrasena": contrasena,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // null = éxito
      } else {
        return response.body; // mensaje de error
      }
    } catch (e) {
      return 'Error al conectar con el servidor';
    }
  }
}
