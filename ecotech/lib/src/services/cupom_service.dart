import 'dart:convert';
import 'package:http/http.dart' as http;

class CupomModel {
  final int idCupom;
  final String titulo;
  final String descricao;
  final double valorDesconto;
  final int pontosNecessarios;
  final String statusUsuario;
  final String? dataResgate;

  CupomModel({
    required this.idCupom,
    required this.titulo,
    required this.descricao,
    required this.valorDesconto,
    required this.pontosNecessarios,
    required this.statusUsuario,
    this.dataResgate,
  });

  factory CupomModel.fromJson(Map<String, dynamic> json) {
    final valorRaw = json['valor_desconto'];
    final valor = valorRaw is double
        ? valorRaw
        : double.tryParse(valorRaw.toString()) ?? 0.0;

    final pontosRaw = json['pontos_necessarios'];
    final pontos = pontosRaw is int
        ? pontosRaw
        : int.tryParse(pontosRaw.toString()) ?? 0;

    return CupomModel(
      idCupom: json['id_cupom'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      valorDesconto: valor,
      pontosNecessarios: pontos,
      statusUsuario: json['status_usuario'] ?? 'disponivel',
      dataResgate: json['data_resgate'],
    );
  }

  bool get resgatado => statusUsuario == 'resgatado';
}

class CupomService {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  // listar cupons com status do usuario
  static Future<List<CupomModel>> listarCupons(int idUsuario) async {
    final url = Uri.parse("$baseUrl/cupons/$idUsuario");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CupomModel.fromJson(item)).toList();
    }

    return [];
  }

  // resgatar cupom
  static Future<Map<String, dynamic>> resgatarCupom({
    required int idUsuario,
    required int idCupom,
  }) async {
    final url = Uri.parse("$baseUrl/cupons/resgatar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "id_cupom": idCupom,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao resgatar cupom');
    }
  }
}