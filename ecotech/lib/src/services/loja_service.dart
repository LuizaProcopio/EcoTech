import 'dart:convert';
import 'package:http/http.dart' as http;

class LojaModel {
  final int idLoja;
  final String nome;
  final String? email;
  final int totalCupons;

  LojaModel({
    required this.idLoja,
    required this.nome,
    this.email,
    required this.totalCupons,
  });

  factory LojaModel.fromJson(Map<String, dynamic> json) {
    return LojaModel(
      idLoja: json['id_loja'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'],
      totalCupons: json['total_cupons'] is int
          ? json['total_cupons']
          : int.tryParse(json['total_cupons'].toString()) ?? 0,
    );
  }
}

class LojaService {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  // listar lojas
  static Future<List<LojaModel>> listarLojas(int idUsuario) async {
    final url = Uri.parse("$baseUrl/lojas/$idUsuario");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LojaModel.fromJson(e)).toList();
    }
    return [];
  }

  // criar loja
  static Future<void> criarLoja({
    required int idUsuario,
    required String nome,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse("$baseUrl/lojas");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "nome": nome,
        "email": email,
        "senha": senha,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Erro ao criar loja');
    }
  }

  // verificar cupom
  static Future<Map<String, dynamic>> verificarCupom({
    required String codigoCupom,
    required double valorCompra,
    required int idLoja,
  }) async {
    final url = Uri.parse("$baseUrl/lojas/verificar-cupom");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "codigo_cupom": codigoCupom,
        "valor_compra": valorCompra,
        "id_loja": idLoja,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao verificar cupom');
    }
  }
}