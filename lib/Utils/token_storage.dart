import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'idUsuario');
    await storage.delete(key: 'nombre');
    await storage.delete(key: 'rol');
  }

  static Future<void> saveUserData({
    required String idUsuario,
    required String nombre,
    required String rol,
  }) async {
    await storage.write(key: 'idUsuario', value: idUsuario);
    await storage.write(key: 'nombre', value: nombre);
    await storage.write(key: 'rol', value: rol);
  }

  static Future<String?> getNombre() async {
    return await storage.read(key: 'nombre');
  }

  static Future<String?> getRol() async {
    return await storage.read(key: 'rol');
  }

  static Future<String?> getIdUsuario() async {
    return await storage.read(key: 'idUsuario');
  }
}
