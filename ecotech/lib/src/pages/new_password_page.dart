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

  // valida se a senha é forte
  String? _validarSenhaForte(String senha) {
    if (senha.isEmpty) return "A nova senha é obrigatória";
    if (senha.length <= 6) return "A senha deve ter mais de 6 caracteres";
    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return "A senha deve conter pelo menos uma letra maiúscula";
    }
    return null;
  }

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

    // valida senha forte
    final erroSenha = _validarSenhaForte(novaSenhaController.text);
    if (erroSenha != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroSenha), backgroundColor: Colors.redAccent),
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
                const Text("Digite sua nova senha",
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
                  label: "NOVA SENHA",
                  controller: novaSenhaController,
                  obscure: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "CONFIRME SUA SENHA",
                  controller: confirmarSenhaController,
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 20),

                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(onclick: _alterarSenha, title: "ALTERAR SUA SENHA"),

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