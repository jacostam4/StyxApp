import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:html' as html; // Importa dart:html para usar localStorage en Web
import 'package:flutter/foundation.dart' show kIsWeb;

class TokenStorage {
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      // Solución para Web
      html.window.localStorage['jwt_token'] = token;
    } else {
      // Solución para Android/iOS
      const storage = FlutterSecureStorage();
      await storage.write(key: 'jwt_token', value: token);
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      // Solución para Web
      return html.window.localStorage['jwt_token'];
    } else {
      // Solución para Android/iOS
      const storage = FlutterSecureStorage();
      return await storage.read(key: 'jwt_token');
    }
  }

  static Future<void> deleteToken() async {
    if (kIsWeb) {
      // Solución para Web
      html.window.localStorage.remove('jwt_token');
    } else {
      // Solución para Android/iOS
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'jwt_token');
    }
  }
}
