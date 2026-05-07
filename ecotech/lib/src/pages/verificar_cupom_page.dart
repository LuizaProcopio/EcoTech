import 'package:flutter/material.dart';
import '../services/loja_service.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';

class VerificarCupomPage extends StatefulWidget {
  const VerificarCupomPage({super.key});

  @override
  State<VerificarCupomPage> createState() => _VerificarCupomPageState();
}

class _VerificarCupomPageState extends State<VerificarCupomPage> {
  final codigoController = TextEditingController();
  final valorController = TextEditingController();
  bool _verificando = false;
  Map<String, dynamic>? _resultado;
  String? _erro;

  Future<void> _verificar(int idLoja) async {
    if (codigoController.text.isEmpty || valorController.text.isEmpty) {
      setState(() => _erro = "Preencha todos os campos!");
      return;
    }

    final valor = double.tryParse(valorController.text.replaceAll(',', '.'));
    if (valor == null) {
      setState(() => _erro = "Valor da compra inválido!");
      return;
    }

    setState(() { _verificando = true; _erro = null; _resultado = null; });

    try {
      final resultado = await LojaService.verificarCupom(
        codigoCupom: codigoController.text.toUpperCase(),
        valorCompra: valor,
        idLoja: idLoja,
      );
      setState(() => _resultado = resultado);
    } catch (e) {
      setState(() => _erro = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _verificando = false);
    }
  }

  void _novaVerificacao() {
    setState(() {
      codigoController.clear();
      valorController.clear();
      _resultado = null;
      _erro = null;
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamed(
              "/perfilLojaPage",
              arguments: {
                'idLoja': idLoja,
                'nomeLoja': nomeLoja,
                'emailLoja': emailLoja,
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6A0DAD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified, color: Colors.amber, size: 36),
                  const SizedBox(height: 8),
                  const Text('Verificar Cupom',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(nomeLoja, style: const TextStyle(color: Color(0xFFD4C8F7), fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_resultado == null) ...[
              CampoFormularioWidget(
                label: "CÓDIGO DO CUPOM",
                controller: codigoController,
                obscure: false,
                icon: Icons.confirmation_number_outlined,
              ),
              const SizedBox(height: 15),
              CampoFormularioWidget(
                label: "VALOR DA COMPRA (R\$)",
                controller: valorController,
                obscure: false,
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 20),

              if (_erro != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_erro!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                ),

              _verificando
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                  : ButtonAppWidget(onclick: () => _verificar(idLoja), title: "VERIFICAR CUPOM"),

            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 12),
                    const Text('Cupom Válido!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 16),
                    _buildLinha('Cupom', _resultado!['titulo'] ?? ''),
                    _buildLinha('Cliente', _resultado!['nome_usuario'] ?? ''),
                    const Divider(height: 24),
                    _buildLinha('Valor da Compra', 'R\$ ${_resultado!['valor_compra']}'),
                    _buildLinha('Desconto (${_resultado!['desconto_percentual']}%)',
                      '- R\$ ${_resultado!['valor_desconto']}', cor: Colors.green),
                    const Divider(height: 16),
                    _buildLinha('VALOR FINAL', 'R\$ ${_resultado!['valor_final']}',
                      bold: true, cor: const Color(0xFF6A0DAD)),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              ButtonAppWidget(onclick: _novaVerificacao, title: "NOVA VERIFICAÇÃO"),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLinha(String label, String valor, {bool bold = false, Color? cor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: 14, color: Colors.black54,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(valor, style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            color: cor ?? Colors.black87)),
        ],
      ),
    );
  }
}