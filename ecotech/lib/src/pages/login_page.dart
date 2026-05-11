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
    final viewModel = context.read<LoginViewModel>();

    final user = await viewModel.login(
      emailController.text.trim(),
      passWordController.text.trim(),
    );

    if (user != null && mounted) {
      Navigator.of(context).pushNamed(
        "/userPage",
        arguments: viewModel.userId!,
      );

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
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("EcoTech",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
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
                const SizedBox(height: 10),
                const Text("Bem Vindo!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                const SizedBox(height: 10),
                Image.asset("assets/images/img_lixo_login.png", height: 200),
                const SizedBox(height: 20),
                CampoFormularioWidget(
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "SENHA",
                  controller: passWordController,
                  obscure: true,
                  icon: Icons.lock,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed("/forgotPassword"),
                    child: const Text("esqueci minha senha",
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 10),
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(onclick: _login, title: "ENTRAR"),
                const SizedBox(height: 15),
                Visibility(
                  visible: viewModel.erroMessage != null,
                  child: Text(
                    viewModel.erroMessage ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem conta? ", style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("/createAccount"),
                      child: const Text("Cadastre-se",
                        style: TextStyle(color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("ou", style: TextStyle(color: Colors.black38)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed("/loginLojaPage"),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF6A0DAD)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store_outlined, color: Color(0xFF6A0DAD), size: 20),
                        SizedBox(width: 8),
                        Text("ENTRAR COMO LOJISTA",
                          style: TextStyle(
                            color: Color(0xFF6A0DAD),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      ],
                    ),
                  ),
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