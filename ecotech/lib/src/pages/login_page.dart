import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  void _login() {
    Navigator.of(context).pushNamed("/login");
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

                // 2. Texto "Bem Vindo!"
                Text(
                  "Bem Vindo!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 10),

                Image.asset(
                  "assets/images/img_lixo_login.png", // Imagem do lixo
                  height: 200,
                ),

                SizedBox(height: 20),

                CampoFormularioWidget(
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email, // icone de carta
                ),

                SizedBox(height: 15),

                CampoFormularioWidget(
                  label: "SENHA",
                  controller: passWordController,
                  obscure: true, // icone de acadeado
                  icon: Icons.lock,
                ),

                // 3. "esqueci minha senha" alinhado à direita
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: navegar para recuperação de senha
                      Navigator.of(context).pushNamed("/forgotPassword");
                    },
                    child: Text(
                      "esqueci minha senha",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // botão importado /src/widgets/button_app_widgets.dart
                ButtonAppWidget(onclick: _login, title: "ENTRAR"),

                SizedBox(height: 20),

                // 4. "Não tem conta? Cadastre-se" no rodapé
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem conta? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: navegar para cadastro

                        Navigator.of(context).pushNamed("/createAccount");
                      },
                      child: Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: Color(0xFF6A0DAD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}