import 'package:ecotech/src/viewmodel/login_view_model.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  void _login() async {
    // pega o ViewModel
    final viewModel = context.read<LoginViewModel>();

    // chama a API
    final user = await viewModel.login(
      emailController.text,
      passWordController.text,
    );

    // se o login foi bem sucedido, navega para a próxima tela
    if (user != null && mounted) {
      Navigator.of(context).pushNamed("/");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bem vindo, ${user.userName}!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // observa o ViewModel para reagir a mudanças
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0DAD),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "EcoTech",
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
                  "assets/images/img_lixo_login.png",
                  height: 200,
                ),

                SizedBox(height: 20),

                CampoFormularioWidget(
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email,
                ),

                SizedBox(height: 15),

                CampoFormularioWidget(
                  label: "SENHA",
                  controller: passWordController,
                  obscure: true,
                  icon: Icons.lock,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
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

                // mostra loading enquanto aguarda a API
                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(onclick: _login, title: "ENTRAR"),

                SizedBox(height: 15),

                // mostra erro da API se houver
                Visibility(
                  visible: viewModel.erroMessage != null,
                  child: Text(
                    viewModel.erroMessage ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem conta? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
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