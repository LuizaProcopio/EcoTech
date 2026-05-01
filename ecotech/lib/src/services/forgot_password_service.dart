import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  final String baseUrl = "https://ecotechapi-production.up.railway.app";

  // --------------------------------------------------------
  // TELA 1 — envia o código por email
  // Chama: POST /auth/esqueceu-senha
  // --------------------------------------------------------
  Future<Map<String, dynamic>> enviarCodigo(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/esqueceu-senha'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao enviar código');
    }
  }

  // --------------------------------------------------------
  // TELA 2 — verifica o código
  // Chama: POST /auth/verificar-codigo
  // --------------------------------------------------------
  Future<Map<String, dynamic>> verificarCodigo(
      String email, String codigo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verificar-codigo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "codigo": codigo}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Código inválido');
    }
  }

  // --------------------------------------------------------
  // TELA 3 — salva a nova senha
  // Chama: POST /auth/nova-senha
  // --------------------------------------------------------
  Future<Map<String, dynamic>> novaSenha(
      String email, String codigo, String novaSenha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/nova-senha'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "codigo": codigo,
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