import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Utils/token_storage.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://localhost:8074/api/usuario/auth');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final token = jsonBody['token'];

        // 1. Guardar token
        await TokenStorage.saveToken(token);

        // 2. Decodificar token y extraer claims
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final idUsuario = decodedToken['idUsuario'].toString();
        final nombre = decodedToken['nombre'];
        final rol = decodedToken['rol'].toString();

        // 3. Guardar datos del usuario
        await TokenStorage.saveUserData(
          idUsuario: idUsuario,
          nombre: nombre,
          rol: rol,
        );

        return true;
      }

      return false;
    } catch (e) {
      print('Error al hacer login: $e');
      return false;
    }
  }
}
