import 'dart:math';
import 'package:flutter/material.dart';
import '../services/cupom_service.dart';

class RecompensasPage extends StatefulWidget {
  const RecompensasPage({super.key});

  @override
  State<RecompensasPage> createState() => _RecompensasPageState();
}

class _RecompensasPageState extends State<RecompensasPage> {
  late Future<List<CupomModel>> _futureCupons;
  late int _userId;

  // gera código único ECO + 5 caracteres aleatórios (letras e números misturados)
  String _gerarCodigoCupom(int idCupom, int idUsuario) {
    final random = Random(idCupom * 9999 + idUsuario * 1234);
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
    final codigo = List.generate(5, (_) => chars[random.nextInt(chars.length)]).join();
    return 'ECO$codigo';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = ModalRoute.of(context)!.settings.arguments as int;
    _futureCupons = CupomService.listarCupons(_userId);
  }

  void _recarregar() {
    setState(() {
      _futureCupons = CupomService.listarCupons(_userId);
    });
  }

  Future<void> _resgatar(CupomModel cupom) async {
    try {
      final resultado = await CupomService.resgatarCupom(
        idUsuario: _userId,
        idCupom: cupom.idCupom,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Cupom resgatado!'),
            backgroundColor: Colors.green,
          ),
        );
        _recarregar();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _mostrarCupom(CupomModel cupom) {
    final codigo = _gerarCodigoCupom(cupom.idCupom, _userId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6A0DAD).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, color: Color(0xFF6A0DAD), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    cupom.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cupom.valorDesconto.toStringAsFixed(0)}% de desconto',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6A0DAD),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6A0DAD), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'CUPOM RESGATADO',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    codigo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0DAD),
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Apresente este cupom no estabelecimento para obter o desconto.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              'Válido por 2 dias após o resgate.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'EcoTech',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // banner topo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF6A0DAD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.card_giftcard, color: Colors.amber, size: 40),
                SizedBox(height: 6),
                Text(
                  'Recompensas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Use seus pontos para resgatar cupons!',
                  style: TextStyle(
                    color: Color(0xFFD4C8F7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // cabeçalho da tabela
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6A0DAD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Desconto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Pontos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // lista de cupons
          Expanded(
            child: FutureBuilder<List<CupomModel>>(
              future: _futureCupons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6A0DAD)),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum cupom disponível"));
                }

                final cupons = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    itemCount: cupons.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final cupom = cupons[index];
                      return _buildCupomCard(cupom);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCupomCard(CupomModel cupom) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  cupom.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${cupom.valorDesconto.toStringAsFixed(0)}%off',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${cupom.pontosNecessarios}pts',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          cupom.resgatado
              ? GestureDetector(
                  onTap: () => _mostrarCupom(cupom),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'CUPOM RESGATADO',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => _resgatar(cupom),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A0DAD),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'RESGATAR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}