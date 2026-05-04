import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class AlterPasswordPage extends StatefulWidget {
  const AlterPasswordPage({super.key});

  @override
  State<AlterPasswordPage> createState() => _AlterPasswordPageState();
}

class _AlterPasswordPageState extends State<AlterPasswordPage> {
  final senhaAtualController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  bool _isLoading = false;
  String? _erroMessage;

  Future<void> _alterarSenha() async {
    final int userId =
        ModalRoute.of(context)!.settings.arguments as int;

    if (senhaAtualController.text.isEmpty ||
        novaSenhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      setState(() => _erroMessage = "Preencha todos os campos!");
      return;
    }

    if (novaSenhaController.text != confirmarSenhaController.text) {
      setState(() => _erroMessage = "As senhas não coincidem!");
      return;
    }

    setState(() {
      _isLoading = true;
      _erroMessage = null;
    });

    try {
      await UserService.alterarSenha(
        userId: userId,
        senhaAtual: senhaAtualController.text,
        novaSenha: novaSenhaController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Senha alterada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _erroMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'EcoTech',
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
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              const Text(
                "Alterar Senha",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A0DAD),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Digite sua senha atual e a nova senha.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              CampoFormularioWidget(
                label: "SENHA ATUAL",
                controller: senhaAtualController,
                obscure: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 15),

              CampoFormularioWidget(
                label: "NOVA SENHA",
                controller: novaSenhaController,
                obscure: true,
                icon: Icons.lock,
              ),

              const SizedBox(height: 15),

              CampoFormularioWidget(
                label: "CONFIRMAR NOVA SENHA",
                controller: confirmarSenhaController,
                obscure: true,
                icon: Icons.lock,
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6A0DAD),
                      ),
                    )
                  : ButtonAppWidget(
                      onclick: _alterarSenha,
                      title: "ALTERAR SENHA",
                    ),

              const SizedBox(height: 15),

              Visibility(
                visible: _erroMessage != null,
                child: Text(
                  _erroMessage ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}