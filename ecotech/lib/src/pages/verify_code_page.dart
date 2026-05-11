import 'package:ecotech/src/viewmodel/forgot_password_view_model.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final codigoController = TextEditingController();

  void _verificarCodigo() async {
    final codigo = codigoController.text.trim();

    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, digite o código!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final viewModel = context.read<ForgotPasswordViewModel>();
    final sucesso = await viewModel.verificarCodigo(codigo);

    if (sucesso && mounted) {
      Navigator.of(context).pushNamed("/newPassword");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();

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
                const SizedBox(height: 20),
                const Text("Esqueceu sua senha",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                const SizedBox(height: 10),
                const Text("Digite o código que enviamos para o seu e-mail.",
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 10),
                Text(viewModel.email,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                CampoFormularioWidget(
                  label: "CÓDIGO",
                  controller: codigoController,
                  obscure: false,
                  icon: Icons.lock_open,
                ),
                const SizedBox(height: 20),

                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(onclick: _verificarCodigo, title: "ALTERAR SUA SENHA"),

                const SizedBox(height: 15),

                Visibility(
                  visible: viewModel.erroMessage != null,
                  child: Text(
                    viewModel.erroMessage ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
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