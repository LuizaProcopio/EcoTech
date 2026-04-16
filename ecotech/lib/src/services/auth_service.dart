import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // endereço da API
  // 10.0.2.2 é o localhost do computador visto pelo emulador Android
  final String baseUrl = "https://ecotechapi-production.up.railway.app";

  // --------------------------------------------------------
  // LOGIN
  // Chama: POST /auth/login
  // --------------------------------------------------------
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'E-mail ou senha inválidos');
    }
  }

  // --------------------------------------------------------
  // CADASTRO
  // Chama: POST /auth/cadastro
  // --------------------------------------------------------
  Future<Map<String, dynamic>> cadastro(
      String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/cadastro'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "email": email,
        "senha": senha,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao criar conta');
    }
  }
}