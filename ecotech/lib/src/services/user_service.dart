import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  // buscar perfil do usuario
  static Future<UserModel?> getUser(int id) async {
    final url = Uri.parse("$baseUrl/usuario/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromJson(data);
    }

    return null;
  }

  // salvar foto de perfil
  static Future<bool> salvarFoto(int userId, String fotoBase64) async {
    final url = Uri.parse("$baseUrl/usuario/$userId/foto");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"foto_perfil": fotoBase64}),
    );

    return response.statusCode == 200;
  }

  // alterar senha
  static Future<Map<String, dynamic>> alterarSenha({
    required int userId,
    required String senhaAtual,
    required String novaSenha,
  }) async {
    final url = Uri.parse("$baseUrl/usuario/alterar-senha");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": userId,
        "senha_atual": senhaAtual,
        "nova_senha": novaSenha,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao alterar senha');
    }
  }
}