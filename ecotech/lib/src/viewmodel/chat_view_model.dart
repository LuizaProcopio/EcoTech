import 'package:ecotech/src/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? erroMessage;
  List<ChatMessage> mensagens = [];

  ChatViewModel() {
    // mensagem de boas vindas ao iniciar
    mensagens.add(ChatMessage(
      text:
          'Olá! Sou o assistente virtual do EcoTech. Posso te ajudar com dúvidas sobre reciclagem e sobre o aplicativo. Como posso te ajudar?',
      isUser: false,
    ));
  }

  // --------------------------------------------------------
  // ENVIAR MENSAGEM
  // --------------------------------------------------------
  Future<void> enviarMensagem(String texto) async {
    if (texto.trim().isEmpty || isLoading) return;

    // adiciona a mensagem do usuário
    mensagens.add(ChatMessage(text: texto, isUser: true));
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      final resposta = await ChatService.enviarMensagem(
        mensagem: texto,
        historico: List.from(mensagens)..removeLast(),
      );

      mensagens.add(ChatMessage(text: resposta, isUser: false));
    } catch (e) {
      mensagens.add(ChatMessage(
        text: 'Erro ao conectar. Tente novamente.',
        isUser: false,
      ));
      erroMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // limpa o histórico
  void limpar() {
    mensagens.clear();
    mensagens.add(ChatMessage(
      text:
          'Olá! Sou o assistente virtual do EcoTech. Como posso te ajudar?',
      isUser: false,
    ));
    notifyListeners();
  }
}