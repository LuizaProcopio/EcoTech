import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginLojaPage extends StatefulWidget {
  const LoginLojaPage({super.key});

  @override
  State<LoginLojaPage> createState() => _LoginLojaPageState();
}

class _LoginLojaPageState extends State<LoginLojaPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _isLoading = false;
  String? _erro;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    setState(() { _isLoading = true; _erro = null; });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/lojas/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "senha": senha,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.of(context).pushNamed(
            "/verificarCupomPage",
            arguments: {
              'idLoja': data['id_loja'],
              'nomeLoja': data['nome_loja'],
              'emailLoja': email,
            },
          );
        }
      } else {
        setState(() => _erro = data['message'] ?? 'Email ou senha inválidos');
      }
    } catch (e) {
      setState(() => _erro = "Erro de conexão!");
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
                const Icon(Icons.store, color: Color(0xFF6A0DAD), size: 64),
                const SizedBox(height: 16),
                const Text("Acesso Lojista",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                const SizedBox(height: 8),
                const Text("Entre com as credenciais da sua loja",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 30),

                CampoFormularioWidget(
                  label: "E-MAIL DA LOJA",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "SENHA",
                  controller: senhaController,
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
                    : ButtonAppWidget(onclick: _login, title: "ENTRAR"),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem loja? ", style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("/cadastrarLojaPage"),
                      child: const Text("Cadastre sua loja",
                        style: TextStyle(color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold)),
                    ),
                  ],
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