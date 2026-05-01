import 'dart:convert';
import 'package:http/http.dart' as http;

class RankingItem {
  final int posicao;
  final String nome;
  final int pontos;

  RankingItem({
    required this.posicao,
    required this.nome,
    required this.pontos,
  });
}

class RankingService {
  static Future<List<RankingItem>> getRanking() async {
    final url = Uri.parse(
      "https://ecotechapi-production.up.railway.app/ranking",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, dynamic> item = entry.value;

        final pontosRaw = item['pontos_totais'];
        final pontos = pontosRaw is int
            ? pontosRaw
            : int.tryParse(pontosRaw.toString()) ?? 0;

        return RankingItem(
          posicao: index + 1,
          nome: item['nome'] ?? 'Sem nome',
          pontos: pontos,
        );
      }).toList();
    }

    return [];
  }
}