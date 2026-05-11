import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DescarteViewModel extends ChangeNotifier {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  bool isLoading = false;
  String? erroMessage;
  Map<String, dynamic>? resultado;

  // --------------------------------------------------------
  // REGISTRAR DESCARTE COM GEMINI VISION
  // --------------------------------------------------------
  Future<bool> registrarDescarte({
    required int idUsuario,
    required String imagemBase64,
  }) async {
    isLoading = true;
    erroMessage = null;
    resultado = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/descarte/registrar'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_usuario": idUsuario,
          "imagem_base64": imagemBase64,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        resultado = jsonDecode(response.body);
        return true;
      } else {
        final data = jsonDecode(response.body);
        erroMessage = data['message'] ?? 'Erro ao registrar descarte';
        return false;
      }
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // limpa o resultado para um novo descarte
  void limpar() {
    resultado = null;
    erroMessage = null;
    notifyListeners();
  }
}