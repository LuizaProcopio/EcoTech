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

  // gera código único ECO + 5 caracteres aleatórios
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
    setState(() => _futureCupons = CupomService.listarCupons(_userId));
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
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
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
                  Text(cupom.nomeLoja ?? cupom.titulo,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('${cupom.valorDesconto.toStringAsFixed(0)}% de desconto',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF6A0DAD), fontWeight: FontWeight.w500)),
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
                  const Text('CUPOM RESGATADO',
                    style: TextStyle(fontSize: 12, color: Colors.black45, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(codigo,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD), letterSpacing: 4)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Apresente este cupom no estabelecimento para obter o desconto.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 8),
            const Text('Válido por 2 dias após o resgate.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.redAccent, fontStyle: FontStyle.italic)),
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
        title: const Text('EcoTech',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF6A0DAD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: const Column(
              children: [
                Icon(Icons.card_giftcard, color: Colors.amber, size: 40),
                SizedBox(height: 6),
                Text('Recompensas',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Use seus pontos para resgatar cupons!',
                  style: TextStyle(color: Color(0xFFD4C8F7), fontSize: 13)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: FutureBuilder<List<CupomModel>>(
              future: _futureCupons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum cupom disponível"));
                }

                final cupons = snapshot.data!;

                // agrupa por loja
                final Map<String, List<CupomModel>> porLoja = {};
                for (final c in cupons) {
                  final loja = c.nomeLoja ?? c.titulo;
                  porLoja.putIfAbsent(loja, () => []).add(c);
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: porLoja.length,
                  itemBuilder: (context, index) {
                    final loja = porLoja.keys.elementAt(index);
                    final cuponsDaLoja = porLoja[loja]!;
                    return _buildLojaCard(loja, cuponsDaLoja);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLojaCard(String nomeLoja, List<CupomModel> cupons) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF6A0DAD),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.store, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(nomeLoja,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          ...cupons.map((cupom) => _buildCupomItem(cupom)),
        ],
      ),
    );
  }

  Widget _buildCupomItem(CupomModel cupom) {
    // define o status visual do cupom
    final bool aguardandoLiberacao = cupom.statusUsuario == 'utilizado';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          // desconto
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: aguardandoLiberacao
                  ? Colors.grey.withValues(alpha: 0.15)
                  : const Color(0xFF6A0DAD).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${cupom.valorDesconto.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: aguardandoLiberacao ? Colors.grey : const Color(0xFF6A0DAD),
                  )),
                Text('off', style: TextStyle(
                  fontSize: 10,
                  color: aguardandoLiberacao ? Colors.grey : const Color(0xFF6A0DAD),
                )),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${cupom.valorDesconto.toStringAsFixed(0)}% de desconto',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: aguardandoLiberacao ? Colors.grey : Colors.black87,
                  )),
                Text('${cupom.pontosNecessarios} pontos',
                  style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ],
            ),
          ),

          // botão de status
          _buildBotaoStatus(cupom, aguardandoLiberacao),
        ],
      ),
    );
  }

  Widget _buildBotaoStatus(CupomModel cupom, bool aguardandoLiberacao) {
    // aguardando liberação — loja já usou, espera 2 dias
    if (aguardandoLiberacao) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty, color: Colors.orange, size: 14),
            SizedBox(width: 4),
            Text('AGUARDANDO\nLIBERAÇÃO',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    // resgatado — pode ver o código
    if (cupom.resgatado) {
      return GestureDetector(
        onTap: () => _mostrarCupom(cupom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 14),
              SizedBox(width: 4),
              Text('RESGATADO', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    // disponível — pode resgatar
    return GestureDetector(
      onTap: () => _resgatar(cupom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6A0DAD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('RESGATAR',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}