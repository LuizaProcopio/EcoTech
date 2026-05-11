import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlterPasswordLojaPage extends StatefulWidget {
  const AlterPasswordLojaPage({super.key});

  @override
  State<AlterPasswordLojaPage> createState() => _AlterPasswordLojaPageState();
}

class _AlterPasswordLojaPageState extends State<AlterPasswordLojaPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  final senhaAtualController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  bool _isLoading = false;
  String? _erro;

  // valida se a senha é forte
  String? _validarSenhaForte(String senha) {
    if (senha.isEmpty) return "A nova senha é obrigatória";
    if (senha.length <= 6) return "A senha deve ter mais de 6 caracteres";
    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return "A senha deve conter pelo menos uma letra maiúscula";
    }
    return null;
  }

  Future<void> _alterarSenha(int idLoja) async {
    // trim em todos os campos
    final senhaAtual = senhaAtualController.text.trim();
    final novaSenha = novaSenhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    if (senhaAtual.isEmpty || novaSenha.isEmpty || confirmarSenha.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    final erroSenha = _validarSenhaForte(novaSenha);
    if (erroSenha != null) {
      setState(() => _erro = erroSenha);
      return;
    }

    if (novaSenha != confirmarSenha) {
      setState(() => _erro = "As senhas não coincidem!");
      return;
    }

    setState(() { _isLoading = true; _erro = null; });

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/lojas/$idLoja/senha"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "senha_atual": senhaAtual,
          "nova_senha": novaSenha,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Senha alterada com sucesso!"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
      } else {
        setState(() => _erro = data['message'] ?? 'Erro ao alterar senha');
      }
    } catch (e) {
      setState(() => _erro = "Erro de conexão!");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int idLoja = ModalRoute.of(context)!.settings.arguments as int;

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
            const SizedBox(height: 12),

            // dica de senha forte
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6A0DAD).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF6A0DAD), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A senha deve ter mais de 6 caracteres e pelo menos uma letra maiúscula.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6A0DAD)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                : ButtonAppWidget(onclick: () => _alterarSenha(idLoja), title: "SALVAR"),
          ],
        ),
      ),
    );
  }
}