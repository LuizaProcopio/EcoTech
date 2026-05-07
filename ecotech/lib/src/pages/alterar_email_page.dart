import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class AlterarEmailPage extends StatefulWidget {
  const AlterarEmailPage({super.key});

  @override
  State<AlterarEmailPage> createState() => _AlterarEmailPageState();
}

class _AlterarEmailPageState extends State<AlterarEmailPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  final novoEmailController = TextEditingController();
  final senhaController = TextEditingController();
  final codigoController = TextEditingController();

  bool _enviando = false;
  bool _codigoEnviado = false;
  String? _erro;

  late Map<String, dynamic> _args;

  Future<void> _solicitarCodigo() async {
    if (novoEmailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    setState(() { _enviando = true; _erro = null; });

    try {
      final bool isLoja = _args['isLoja'] ?? false;
      final int id = _args['id'];

      final url = isLoja
          ? Uri.parse("$baseUrl/lojas/$id/solicitar-email")
          : Uri.parse("$baseUrl/usuario/$id/solicitar-email");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "novo_email": novoEmailController.text,
          "senha_atual": senhaController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() => _codigoEnviado = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Código enviado para o novo e-mail!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() => _erro = data['message'] ?? 'Erro ao solicitar alteração');
      }
    } catch (e) {
      setState(() => _erro = "Erro de conexão!");
    } finally {
      setState(() => _enviando = false);
    }
  }

  Future<void> _confirmarCodigo() async {
    if (codigoController.text.isEmpty) {
      setState(() => _erro = "Digite o código!");
      return;
    }

    setState(() { _enviando = true; _erro = null; });

    try {
      final bool isLoja = _args['isLoja'] ?? false;
      final int id = _args['id'];

      final url = isLoja
          ? Uri.parse("$baseUrl/lojas/$id/confirmar-email")
          : Uri.parse("$baseUrl/usuario/$id/confirmar-email");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"codigo": codigoController.text}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("E-mail atualizado com sucesso!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        setState(() => _erro = data['message'] ?? 'Código inválido');
      }
    } catch (e) {
      setState(() => _erro = "Erro de conexão!");
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
            const Icon(Icons.email_outlined, color: Color(0xFF6A0DAD), size: 48),
            const SizedBox(height: 12),
            const Text('Alterar E-mail',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
            const SizedBox(height: 8),
            Text(
              _codigoEnviado
                ? 'Digite o código enviado para ${novoEmailController.text}'
                : 'Digite o novo e-mail e sua senha atual.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 30),

            if (!_codigoEnviado) ...[
              CampoFormularioWidget(
                label: "NOVO E-MAIL",
                controller: novoEmailController,
                obscure: false,
                icon: Icons.email,
              ),
              const SizedBox(height: 15),
              CampoFormularioWidget(
                label: "SENHA ATUAL",
                controller: senhaController,
                obscure: true,
                icon: Icons.lock,
              ),
            ] else ...[
              CampoFormularioWidget(
                label: "CÓDIGO DE CONFIRMAÇÃO",
                controller: codigoController,
                obscure: false,
                icon: Icons.confirmation_number,
              ),
            ],

            const SizedBox(height: 20),

            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_erro!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
              ),

            _enviando
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                : ButtonAppWidget(
                    onclick: _codigoEnviado ? _confirmarCodigo : _solicitarCodigo,
                    title: _codigoEnviado ? "CONFIRMAR CÓDIGO" : "ENVIAR CÓDIGO",
                  ),

            if (_codigoEnviado)
              TextButton(
                onPressed: () => setState(() {
                  _codigoEnviado = false;
                  codigoController.clear();
                }),
                child: const Text("Reenviar código",
                  style: TextStyle(color: Color(0xFF6A0DAD))),
              ),
          ],
        ),
      ),
    );
  }
}