import 'package:flutter/material.dart';
import '../services/ranking_service.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

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
      body: FutureBuilder<List<RankingItem>>(
        future: RankingService.getRanking(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6A0DAD)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum dado encontrado"));
          }

          final ranking = snapshot.data!;

          return Column(
            children: [
              // banner do topo
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
                    Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                    SizedBox(height: 6),
                    Text(
                      'Ranking de Eco Pontos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Veja quem está descartando mais!',
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
                      SizedBox(width: 36),
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
                          'Pontos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Rank',
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

              // lista de usuarios
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    itemCount: ranking.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = ranking[index];
                      final isTop3 = item.posicao <= 3;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isTop3
                              ? Border.all(
                                  color: _getCorPosicao(item.posicao)
                                      .withOpacity(0.5),
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // medalha ou número
                            SizedBox(
                              width: 36,
                              child: _buildMedalha(item.posicao),
                            ),

                            // nome
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.nome,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isTop3
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            // pontos
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item.pontos} pts',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isTop3
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isTop3
                                      ? const Color(0xFF6A0DAD)
                                      : Colors.black54,
                                ),
                              ),
                            ),

                            // posição
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${item.posicao}°',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _getCorPosicao(item.posicao),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMedalha(int posicao) {
    switch (posicao) {
      case 1:
        return const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 24);
      case 2:
        return const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 24);
      case 3:
        return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 24);
      default:
        return Text(
          '$posicao',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black38,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  Color _getCorPosicao(int posicao) {
    switch (posicao) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.black54;
    }
  }
}