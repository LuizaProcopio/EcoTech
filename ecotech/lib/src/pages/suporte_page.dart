import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class SuportePage extends StatefulWidget {
  const SuportePage({super.key});

  @override
  State<SuportePage> createState() => _SuportePageState();
}

class _SuportePageState extends State<SuportePage> {
  final List<ChatMessage> _mensagens = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _mensagens.add(ChatMessage(
      text: 'Olá! Sou o assistente virtual do EcoTech. Posso te ajudar com dúvidas sobre reciclagem e sobre o aplicativo. Como posso te ajudar?',
      isUser: false,
    ));
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _enviando) return;

    _controller.clear();

    setState(() {
      _mensagens.add(ChatMessage(text: texto, isUser: true));
      _enviando = true;
    });

    _scrollParaBaixo();

    try {
      final resposta = await ChatService.enviarMensagem(
        mensagem: texto,
        historico: _mensagens.sublist(0, _mensagens.length - 1),
      );

      if (mounted) {
        setState(() {
          _mensagens.add(ChatMessage(text: resposta, isUser: false));
        });
        _scrollParaBaixo();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mensagens.add(ChatMessage(
            text: 'Erro ao conectar. Tente novamente.',
            isUser: false,
          ));
        });
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _scrollParaBaixo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset garante que o layout sobe com o teclado
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.recycling, color: Color(0xFF6A0DAD), size: 18),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EcoTech Suporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Assistente Virtual',
                  style: TextStyle(
                    color: Color(0xFFD4C8F7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // lista de mensagens
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _mensagens.length,
                itemBuilder: (context, index) {
                  final msg = _mensagens[index];
                  return _buildMensagem(msg);
                },
              ),
            ),

            // indicador de digitando
            if (_enviando)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: LinearProgressIndicator(
                              color: Color(0xFF6A0DAD),
                              backgroundColor: Color(0xFFE0D4F5),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('digitando...',
                              style: TextStyle(color: Colors.black45, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // campo de texto — agora usando bottomInset do teclado corretamente
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                // adiciona o espaço do teclado + padding base
                MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 16,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _enviar(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Digite sua dúvida...',
                        hintStyle: const TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _enviar,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A0DAD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMensagem(ChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF6A0DAD),
              child: Icon(Icons.recycling, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF6A0DAD) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFC0B4F0),
              child: Icon(Icons.person, color: Color(0xFF3C3489), size: 16),
            ),
          ],
        ],
      ),
    );
  }
}