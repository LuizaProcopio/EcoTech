import 'dart:convert';
import 'package:http/http.dart' as http;

class CupomModel {
  final int idCupom;
  final int? idLoja;
  final String? nomeLoja;
  final String titulo;
  final String descricao;
  final double valorDesconto;
  final int pontosNecessarios;
  final String statusUsuario;
  final String? dataResgate;
  final bool utilizado;

  CupomModel({
    required this.idCupom,
    this.idLoja,
    this.nomeLoja,
    required this.titulo,
    required this.descricao,
    required this.valorDesconto,
    required this.pontosNecessarios,
    required this.statusUsuario,
    this.dataResgate,
    required this.utilizado,
  });

  factory CupomModel.fromJson(Map<String, dynamic> json) {
    final valorRaw = json['valor_desconto'];
    final valor = valorRaw is double ? valorRaw : double.tryParse(valorRaw.toString()) ?? 0.0;

    final pontosRaw = json['pontos_necessarios'];
    final pontos = pontosRaw is int ? pontosRaw : int.tryParse(pontosRaw.toString()) ?? 0;

    // utilizado vem como 0 ou 1 do banco
    final utilizadoRaw = json['utilizado'];
    final utilizado = utilizadoRaw == 1 || utilizadoRaw == true;

    return CupomModel(
      idCupom: json['id_cupom'] ?? 0,
      idLoja: json['id_loja'],
      nomeLoja: json['nome_loja'],
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      valorDesconto: valor,
      pontosNecessarios: pontos,
      statusUsuario: json['status_usuario'] ?? 'disponivel',
      dataResgate: json['data_resgate'],
      utilizado: utilizado,
    );
  }

  // cupom foi resgatado mas ainda não foi usado pela loja
  bool get resgatado => statusUsuario == 'resgatado' && !utilizado;

  // cupom foi usado pela loja — aguardando liberação de 2 dias
  bool get aguardandoLiberacao => utilizado == true;
}

class CupomService {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  static Future<List<CupomModel>> listarCupons(int idUsuario) async {
    final url = Uri.parse("$baseUrl/cupons/$idUsuario");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CupomModel.fromJson(item)).toList();
    }

    return [];
  }

  static Future<Map<String, dynamic>> resgatarCupom({
    required int idUsuario,
    required int idCupom,
  }) async {
    final url = Uri.parse("$baseUrl/cupons/resgatar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_usuario": idUsuario, "id_cupom": idCupom}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erro ao resgatar cupom');
    }
  }
}