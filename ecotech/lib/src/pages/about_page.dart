import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C4FCF),
        foregroundColor: Colors.white,
        title: const Text('Sobre o Descarte'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Imagem principal
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/img_sobre.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Texto simples e direto
                  const Text(
                    'O descarte correto preserva o solo e a água. '
                    'Separar o lixo reciclável e eletrônicos evita a poluição '
                    'e ajuda a saúde de todos.\n\n'
                    'Com o EcoTech, você registra suas ações e ajuda o planeta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          // Botão inferior centralizado
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ButtonAppWidget(
              title: "ENTENDER MAIS",
              onclick: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}