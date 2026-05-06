import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'dart:async';

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

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"foto_perfil": fotoBase64}),
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Erro ao enviar foto: $e");
    }
  }

  // alterar nome
  static Future<void> alterarNome(int userId, String novoNome) async {
    final url = Uri.parse("$baseUrl/usuario/$userId/nome");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": novoNome}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Erro ao alterar nome');
    }
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