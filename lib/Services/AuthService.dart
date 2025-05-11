import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Utils/token_storage.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://localhost:8074/api/usuario/auth');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final token = response.body;
        await TokenStorage.saveToken(token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
