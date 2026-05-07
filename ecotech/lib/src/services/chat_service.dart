import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatService {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  static Future<String> enviarMensagem({
    required String mensagem,
    required List<ChatMessage> historico,
  }) async {
    final url = Uri.parse("$baseUrl/chat/mensagem");

    // converte o historico para o formato da API
    final historicoFormatado = historico.map((msg) => {
      "role": msg.isUser ? "user" : "model",
      "text": msg.text,
    }).toList();

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mensagem": mensagem,
        "historico": historicoFormatado,
      }),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['resposta'] ?? 'Sem resposta';
    } else {
      throw Exception(data['message'] ?? 'Erro ao enviar mensagem');
    }
  }
}