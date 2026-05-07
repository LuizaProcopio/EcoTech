import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import '../services/user_service.dart';

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
  String? _erro;

  Future<void> _alterarSenha() async {
    if (senhaAtualController.text.isEmpty ||
        novaSenhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    if (novaSenhaController.text != confirmarSenhaController.text) {
      setState(() => _erro = "As senhas não coincidem!");
      return;
    }

    setState(() { _isLoading = true; _erro = null; });

    try {
      final int userId = ModalRoute.of(context)!.settings.arguments as int;

      await UserService.alterarSenha(
        userId: userId,
        senhaAtual: senhaAtualController.text,
        novaSenha: novaSenhaController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Senha alterada com sucesso!"),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _erro = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('EcoTech',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.lock_outline, color: Color(0xFF6A0DAD), size: 48),
            const SizedBox(height: 12),
            const Text('Alterar Senha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
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

            // link esqueci minha senha
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed("/forgotPassword"),
                child: const Text("Esqueci minha senha",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
              ),
            ),

            const SizedBox(height: 10),

            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_erro!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
              ),

            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                : ButtonAppWidget(onclick: _alterarSenha, title: "SALVAR"),
          ],
        ),
      ),
    );
  }
}