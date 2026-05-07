import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastrarLojaPage extends StatefulWidget {
  const CadastrarLojaPage({super.key});

  @override
  State<CadastrarLojaPage> createState() => _CadastrarLojaPageState();
}

class _CadastrarLojaPageState extends State<CadastrarLojaPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  final nomeController = TextEditingController();
  final cnpjController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool _isLoading = false;
  String? _erro;

  Future<void> _cadastrar() async {
    if (nomeController.text.isEmpty ||
        cnpjController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      setState(() => _erro = "As senhas não coincidem!");
      return;
    }

    setState(() { _isLoading = true; _erro = null; });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/lojas/cadastrar"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nomeController.text,
          "cnpj": cnpjController.text,
          "email": emailController.text,
          "senha": senhaController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Loja cadastrada com sucesso!"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
      } else {
        setState(() => _erro = data['message'] ?? 'Erro ao cadastrar loja');
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
                const SizedBox(height: 10),
                const Icon(Icons.store, color: Color(0xFF6A0DAD), size: 56),
                const SizedBox(height: 12),
                const Text("Cadastrar Loja",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                const SizedBox(height: 6),
                const Text("Preencha os dados da sua loja",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 24),

                CampoFormularioWidget(
                  label: "NOME DA EMPRESA",
                  controller: nomeController,
                  obscure: false,
                  icon: Icons.business,
                ),
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "CNPJ",
                  controller: cnpjController,
                  obscure: false,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "E-MAIL",
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
                const SizedBox(height: 15),
                CampoFormularioWidget(
                  label: "CONFIRMAR SENHA",
                  controller: confirmarSenhaController,
                  obscure: true,
                  icon: Icons.lock_outline,
                ),

                const SizedBox(height: 20),

                if (_erro != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_erro!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                  ),

                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(onclick: _cadastrar, title: "CADASTRAR LOJA"),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}