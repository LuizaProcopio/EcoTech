import 'package:ecotech/src/viewmodel/forgot_password_view_model.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  void _alterarSenha() async {
    if (novaSenhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (novaSenhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final viewModel = context.read<ForgotPasswordViewModel>();

    final sucesso = await viewModel.novaSenha(novaSenhaController.text);

    if (sucesso && mounted) {
      Navigator.of(context).pushNamed("/passwordChanged");
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
                  "Digite sua nova senha",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 30),

                CampoFormularioWidget(
                  label: "NOVA SENHA",
                  controller: novaSenhaController,
                  obscure: true,
                  icon: Icons.lock,
                ),

                SizedBox(height: 15),

                CampoFormularioWidget(
                  label: "CONFIRME SUA SENHA",
                  controller: confirmarSenhaController,
                  obscure: true,
                  icon: Icons.lock_outline,
                ),

                SizedBox(height: 20),

                viewModel.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A0DAD),
                        ),
                      )
                    : ButtonAppWidget(
                        onclick: _alterarSenha,
                        title: "ALTERAR SUA SENHA",
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