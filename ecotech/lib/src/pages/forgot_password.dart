import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void _forgotPassword() {
    Navigator.of(context).pushNamed("/forgotPassword");

    if ( emailController.text.isEmpty
        ) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha o campo de E-mail!"), // mensagem de erro de informações
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Para a execução aqui
    }
    // se as informações estiver corretas o usuario ira para essa tela
    Navigator.of(context).pushNamed("/passwordCode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar roxa com título "EcoTech"
      appBar: AppBar( // Local onde fica a seta "voltar" <-
        backgroundColor: Color(0xFF6A0DAD), // Fundo de tela roxo
        iconTheme: IconThemeData(color: Colors.white),
        title: Text( 
          "EcoTech", // Nome do aplicativo
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),

                // 2. Texto "Esqueceu sua Senha?"
                Text(
                  "Esqueceu sua Senha?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Digite seu e-mail",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 15),

                      // Campo de formulário customizado
                      CampoFormularioWidget(
                        label: "E-MAIL",
                        controller: emailController,
                        obscure: false,
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "ENVIAMOS UM CÓDIGO POR E-MAIL PARA VERIFICAR SEU NÚMERO DE TELEFONE.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Botão de ação
                ButtonAppWidget(
                  onclick: _forgotPassword, 
                  title: "VERIFICAR E-MAIL",
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}