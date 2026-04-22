// Rode no terminal do VS "flutter pub get"
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart'; 

class DisposalRegistrationPage extends StatefulWidget {
  const DisposalRegistrationPage({super.key});

  @override
  State<DisposalRegistrationPage> createState() => _DisposalRegistrationPageState();
}

class _DisposalRegistrationPageState extends State<DisposalRegistrationPage> {

  File? _imagemCapturada;
  final ImagePicker _picker = ImagePicker();
  bool _enviando = false;

  // ── Lógica da Câmera ──────────────────────────────────────────────────────

  Future<void> _abrirCamera() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (foto != null) {
      setState(() {
        _imagemCapturada = File(foto.path);
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
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _enviando = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descarte registrado com sucesso!'),
        backgroundColor: Color(0xFF6A0DAD),
      ),
    );

    setState(() => _imagemCapturada = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0DAD),
        foregroundColor: Colors.white,
        title: const Text('EcoTech', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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
          Image.file(_imagemCapturada!, fit: BoxFit.cover),
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: _abrirCamera,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _abrirCamera,
      child: Container(
        color: const Color(0xFFF0F0F0),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('Toque para abrir a câmera'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Barra Inferior com o SEU Widget de Botão ───────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity, // Garante que o container ocupe a largura toda
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 2. Usando o seu ButtonAppWidget aqui
          _enviando 
            ? const CircularProgressIndicator(color: Color(0xFF6A0DAD))
            : ButtonAppWidget(
                title: "DESCARTE", 
                onclick: _registrarDescarte,
              ),
        ],
      ),
    );
  }
}