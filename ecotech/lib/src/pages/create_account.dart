import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final personController = TextEditingController();

  void _createAccount() {
    // verificação se os campos estiverem vazios, exibe um aviso e não deixa avançar
    if (personController.text.isEmpty || 
        emailController.text.isEmpty || 
        passWordController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos!"), // mensagem de erro de informações
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Para a execução aqui
    }

    // se os campos estão preenchidos.
    // o comando 'pop' remove a tela de cadastro e volta para a tela de login que estava atrás.
    Navigator.of(context).pop();

    // mostra uma mensagem de sucesso na tela de login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Conta criada com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );
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
                  "Crie sua Conta!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 10),

                Image.asset(
                  "assets/images/img_criacao_senha.png", // Imagem do lixo
                  height: 200,
                ),

                SizedBox(height: 20),

                CampoFormularioWidget( // local para colocar nome de usuario
                  label: "NOME",
                  controller: personController,
                  obscure: false,
                  icon: Icons.person, // icone de pessoa
                ),

                SizedBox(height: 15),

                CampoFormularioWidget( // local para colocar senha de usuario
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email, // icone de carta
                ),

                SizedBox(height: 15),

                CampoFormularioWidget( // local para colocar senha de usuario
                  label: "SENHA",
                  controller: passWordController,
                  obscure: true, // icone de acadeado
                  icon: Icons.lock,
                ),

                SizedBox(height: 10),

                // botão importado /src/widgets/button_app_widgets.dart
                ButtonAppWidget(
                  onclick: _createAccount, 
                  title: "CADASTRAR",
                  ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}