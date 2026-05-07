import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerfilLojaPage extends StatefulWidget {
  const PerfilLojaPage({super.key});

  @override
  State<PerfilLojaPage> createState() => _PerfilLojaPageState();
}

class _PerfilLojaPageState extends State<PerfilLojaPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  void _alterarSenha(int idLoja) {
    final senhaAtualController = TextEditingController();
    final novaSenhaController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Alterar Senha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              CampoFormularioWidget(
                label: "SENHA ATUAL",
                controller: senhaAtualController,
                obscure: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 12),
              CampoFormularioWidget(
                label: "NOVA SENHA",
                controller: novaSenhaController,
                obscure: true,
                icon: Icons.lock,
              ),
              const SizedBox(height: 16),
              ButtonAppWidget(
                title: "SALVAR",
                onclick: () async {
                  Navigator.of(context).pop();
                  try {
                    final response = await http.put(
                      Uri.parse("$baseUrl/lojas/$idLoja/senha"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({
                        "senha_atual": senhaAtualController.text,
                        "nova_senha": novaSenhaController.text,
                      }),
                    );
                    final data = jsonDecode(response.body);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(data['message'] ?? ''),
                        backgroundColor: response.statusCode == 200 ? Colors.green : Colors.redAccent,
                      ));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Erro de conexão!"),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/forgotPassword");
                },
                child: const Text("Esqueci minha senha",
                  style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int idLoja = args['idLoja'];
    final String nomeLoja = args['nomeLoja'];
    final String emailLoja = args['emailLoja'] ?? '';

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
        child: Column(
          children: [
            // banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF6A0DAD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.store, color: Color(0xFF6A0DAD), size: 44),
                  ),
                  const SizedBox(height: 8),
                  const Text('Perfil da Loja',
                    style: TextStyle(color: Color(0xFFD4C8F7), fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informações',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),

                  _buildInfoCard(Icons.store_outlined, 'Nome da Loja', nomeLoja),
                  const SizedBox(height: 8),

                  // email clicável para alterar
                  _buildInfoCardEditavel(
                    icon: Icons.email_outlined,
                    label: 'E-mail',
                    value: emailLoja,
                    onTap: () => Navigator.of(context).pushNamed(
                      "/alterarEmailPage",
                      arguments: {'id': idLoja, 'isLoja': true},
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text('Segurança',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),

                  _buildActionCard(
                    icon: Icons.lock_outline,
                    label: 'Alterar Senha',
                    onTap: () => _alterarSenha(idLoja),
                  ),

                  const SizedBox(height: 30),

                  // botão sair
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamedAndRemoveUntil("/", (r) => false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('SAIR DA CONTA',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardEditavel({required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF6A0DAD)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87))),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}