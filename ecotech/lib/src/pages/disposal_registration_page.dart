import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class DisposalRegistrationPage extends StatefulWidget {
  const DisposalRegistrationPage({super.key});

  @override
  State<DisposalRegistrationPage> createState() =>
      _DisposalRegistrationPageState();
}

class _DisposalRegistrationPageState extends State<DisposalRegistrationPage> {
  static const String baseUrl = "https://ecotechapi-production.up.railway.app";

  XFile? _imagemCapturada;
  final ImagePicker _picker = ImagePicker();
  bool _enviando = false;
  Map<String, dynamic>? _resultado;
  bool _naoELixo = false;
  String? _mensagemNaoLixo;

  // ── Lógica da Câmera ──────────────────────────────────────────────────────

  Future<void> _abrirCamera() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (foto != null) {
      setState(() {
        _imagemCapturada = foto;
        _resultado = null;
        _naoELixo = false;
        _mensagemNaoLixo = null;
      });
    }
  }

  Future<void> _abrirGaleria() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (foto != null) {
      setState(() {
        _imagemCapturada = foto;
        _resultado = null;
        _naoELixo = false;
        _mensagemNaoLixo = null;
      });
    }
  }

  // ── Lógica de Registro ─────────────────────────────────────────────────────

  Future<void> _registrarDescarte() async {
    if (_imagemCapturada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire uma foto do item antes de registrar.')),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      final bytes = await _imagemCapturada!.readAsBytes();
      final base64 = base64Encode(bytes);

      final int userId = ModalRoute.of(context)!.settings.arguments as int;

      final response = await http.post(
        Uri.parse('$baseUrl/descarte/registrar'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_usuario": userId,
          "imagem_base64": base64,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // verifica se é lixo ou não
        if (data['is_lixo'] == false) {
          setState(() {
            _naoELixo = true;
            _mensagemNaoLixo = data['mensagem'];
          });
        } else {
          setState(() => _resultado = data);
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Erro ao registrar descarte'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _resetar() {
    setState(() {
      _imagemCapturada = null;
      _resultado = null;
      _naoELixo = false;
      _mensagemNaoLixo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        foregroundColor: Colors.white,
        title: const Text('EcoTech',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _resultado != null
            ? _buildResultado()
            : _naoELixo
                ? _buildNaoELixo()
                : Column(
                    children: [
                      Expanded(child: _buildPreview()),
                      _buildBottomBar(),
                    ],
                  ),
      ),
    );
  }

  // ── Preview da Foto ────────────────────────────────────────────────────────

  Widget _buildPreview() {
    if (_imagemCapturada != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<dynamic>(
            future: _imagemCapturada!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: _abrirCamera,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
        const SizedBox(height: 12),
        const Text('Tire ou selecione uma foto do resíduo',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _abrirCamera,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A0DAD),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Câmera',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _abrirGaleria,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6A0DAD)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.photo_library, color: Color(0xFF6A0DAD), size: 18),
                    SizedBox(width: 8),
                    Text('Galeria',
                        style: TextStyle(color: Color(0xFF6A0DAD), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Tela de Não É Lixo ─────────────────────────────────────────────────────

  Widget _buildNaoELixo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // ícone de aviso
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange, width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 56),
                const SizedBox(height: 12),
                const Text(
                  'Isso não parece um lixo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _mensagemNaoLixo ?? 'A imagem não parece ser um resíduo descartável. Tente novamente com uma foto de lixo.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // aviso de pontos
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nenhum ponto foi somado. Apenas descartes de resíduos reais são pontuados.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          ButtonAppWidget(
            title: 'TENTAR NOVAMENTE',
            onclick: _resetar,
          ),
        ],
      ),
    );
  }

  // ── Resultado do Gemini ────────────────────────────────────────────────────

  Widget _buildResultado() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Descarte registrado!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green)),
                      Text(
                          'Você ganhou ${_resultado!['pontos_ganhos']} pontos!',
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildInfoResultado('Tipo de Lixo', _resultado!['tipo_lixo'] ?? '', Icons.delete_outline),
          _buildInfoResultado('Material', _resultado!['material'] ?? '', Icons.layers_outlined),
          _buildInfoResultado('Como Descartar', _resultado!['como_descartar'] ?? '', Icons.recycling),
          _buildInfoResultado('Tempo de Degradação', _resultado!['tempo_degradacao'] ?? '', Icons.access_time),
          _buildInfoResultado('Impacto Ambiental', _resultado!['impacto_ambiental'] ?? '', Icons.warning_amber_outlined),
          _buildInfoResultado('Curiosidade', _resultado!['curiosidade'] ?? '', Icons.lightbulb_outline),

          const SizedBox(height: 20),

          ButtonAppWidget(
            title: 'NOVO DESCARTE',
            onclick: _resetar,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoResultado(String titulo, String valor, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6A0DAD), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(valor,
                    style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Barra Inferior ─────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: _enviando
          ? const Column(
              children: [
                CircularProgressIndicator(color: Color(0xFF6A0DAD)),
                SizedBox(height: 8),
                Text('Analisando com IA...', style: TextStyle(color: Colors.grey)),
              ],
            )
          : ButtonAppWidget(
              title: "REGISTRAR DESCARTE",
              onclick: _registrarDescarte,
            ),
    );
  }
}