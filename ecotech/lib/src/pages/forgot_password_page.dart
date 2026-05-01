import 'package:ecotech/src/viewmodel/forgot_password_view_model.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void _enviarCodigo() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, digite seu e-mail!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final viewModel = context.read<ForgotPasswordViewModel>();

    final sucesso = await viewModel.enviarCodigo(emailController.text);

    if (sucesso && mounted) {
      Navigator.of(context).pushNamed("/verifyCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();

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
                SizedBox(height: 20),

                Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Digite seu e-mail para receber o código de verificação.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(height: 30),

                CampoFormularioWidget(
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email,
                ),

                SizedBox(height: 20),

                viewModel.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A0DAD),
                        ),
                      )
                    : ButtonAppWidget(
                        onclick: _enviarCodigo,
                        title: "ENVIAR CÓDIGO",
                      ),

                SizedBox(height: 15),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}