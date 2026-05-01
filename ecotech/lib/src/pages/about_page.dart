// import 'package:flutter/material.dart';
// import 'package:ecotech/src/widgets/button_app_widgets.dart';

// class AboutPage extends StatelessWidget {
//   const AboutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6C4FCF),
//         foregroundColor: Colors.white,
//         title: const Text('Sobre o Descarte'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(25),
//               child: Column(
//                 children: [
//                   // Imagem principal
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       'assets/images/img_sobre.png',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
                  
//                   // Texto simples e direto
//                   const Text(
//                     'O descarte correto preserva o solo e a água. '
//                     'Separar o lixo reciclável e eletrônicos evita a poluição '
//                     'e ajuda a saúde de todos.\n\n'
//                     'Com o EcoTech, você registra suas ações e ajuda o planeta.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Botão inferior centralizado
//           Padding(
//             padding: const EdgeInsets.only(bottom: 40),
//             child: ButtonAppWidget(
//               title: "ENTENDER MAIS",
//               onclick: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // banner roxo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF6A0DAD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.recycling, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'A Importância do Descarte Correto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'O descarte incorreto de lixo é uma das maiores causas de poluição do planeta. '
                    'Cada resíduo jogado no lugar errado pode contaminar o solo, a água e o ar, '
                    'afetando a saúde de pessoas, animais e ecossistemas inteiros.\n\n'
                    'Separar e descartar corretamente o lixo ajuda na reciclagem, '
                    'reduz o desperdício e contribui para um futuro mais sustentável. '
                    'Com o EcoTech, cada descarte correto vale pontos e faz diferença!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD4C8F7),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // titulo das categorias
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tipos de Lixo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // cards clicáveis por tipo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _tiposLixo.map((tipo) {
                  return _buildTipoCard(context, tipo);
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoCard(BuildContext context, Map<String, dynamic> tipo) {
    return GestureDetector(
      onTap: () => _mostrarDetalhes(context, tipo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (tipo['cor'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                tipo['icone'] as IconData,
                color: tipo['cor'] as Color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipo['nome'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tipo['subtitulo'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context, Map<String, dynamic> tipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icone e titulo
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: (tipo['cor'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            tipo['icone'] as IconData,
                            color: tipo['cor'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          tipo['nome'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildInfo('Exemplos', tipo['exemplos'] as String),
                    _buildInfo('Como descartar', tipo['descarte'] as String),
                    _buildInfo('Tempo de degradação', tipo['degradacao'] as String),
                    _buildInfo('Impacto se descartado errado', tipo['impacto'] as String),
                    _buildInfo('Curiosidade', tipo['curiosidade'] as String),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String titulo, String conteudo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A0DAD),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            conteudo,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// dados dos tipos de lixo
const List<Map<String, dynamic>> _tiposLixo = [
  {
    'nome': 'Plástico',
    'subtitulo': 'Garrafas, embalagens, sacolas',
    'icone': Icons.local_drink_outlined,
    'cor': Color(0xFF2196F3),
    'exemplos': 'Garrafas PET, sacolas, embalagens, copos descartáveis, tampas.',
    'descarte': 'Descarte na lixeira AZUL de coleta seletiva. Limpe as embalagens antes de descartar.',
    'degradacao': 'Entre 100 e 400 anos dependendo do tipo de plástico.',
    'impacto': 'Contamina rios e oceanos, mata animais marinhos e entra na cadeia alimentar humana.',
    'curiosidade': 'O Brasil produz mais de 11 milhões de toneladas de plástico por ano, mas recicla menos de 2%.',
  },
  {
    'nome': 'Vidro',
    'subtitulo': 'Garrafas, potes, frascos',
    'icone': Icons.wine_bar_outlined,
    'cor': Color(0xFF4CAF50),
    'exemplos': 'Garrafas de bebidas, potes de conserva, frascos de perfume.',
    'descarte': 'Descarte na lixeira VERDE de coleta seletiva. Não misture com espelhos ou vidros de janela.',
    'degradacao': 'O vidro demora mais de 1 milhão de anos para se decompor.',
    'impacto': 'Vidros quebrados podem ferir pessoas e animais. Não reciclados, ocupam espaço por milênios.',
    'curiosidade': 'O vidro pode ser reciclado infinitas vezes sem perder qualidade.',
  },
  {
    'nome': 'Metal / Lata',
    'subtitulo': 'Latinhas, latas de alimento',
    'icone': Icons.kitchen_outlined,
    'cor': Color(0xFFFF9800),
    'exemplos': 'Latas de refrigerante, cerveja, latas de alimentos, tampas metálicas.',
    'descarte': 'Descarte na lixeira AMARELA de coleta seletiva. Amasse as latas para economizar espaço.',
    'degradacao': 'Uma lata de alumínio leva até 200 anos para se decompor.',
    'impacto': 'O alumínio jogado no meio ambiente libera substâncias tóxicas no solo.',
    'curiosidade': 'Reciclar uma lata de alumínio economiza energia suficiente para deixar uma TV ligada por 3 horas.',
  },
  {
    'nome': 'Papel e Papelão',
    'subtitulo': 'Jornais, caixas, revistas',
    'icone': Icons.newspaper_outlined,
    'cor': Color(0xFF795548),
    'exemplos': 'Jornais, revistas, caixas de papelão, folhas de papel, cadernos.',
    'descarte': 'Descarte na lixeira VERMELHA de coleta seletiva. Mantenha o papel seco e limpo.',
    'degradacao': 'O papel pode levar de 3 meses a 6 meses para se decompor.',
    'impacto': 'Papel molhado ou sujo de gordura não pode ser reciclado e vai para aterros.',
    'curiosidade': 'Reciclar 1 tonelada de papel salva 20 árvores e economiza 100 litros de água.',
  },
  {
    'nome': 'Orgânico',
    'subtitulo': 'Restos de comida, cascas',
    'icone': Icons.eco_outlined,
    'cor': Color(0xFF8BC34A),
    'exemplos': 'Cascas de frutas e legumes, restos de comida, borra de café, folhas.',
    'descarte': 'Descarte na lixeira MARROM ou orgânica. Pode ser usado para compostagem.',
    'degradacao': 'Entre 1 semana e 6 meses dependendo do material.',
    'impacto': 'Quando misturado ao lixo seco, dificulta a reciclagem e gera gases de efeito estufa.',
    'curiosidade': 'O lixo orgânico representa quase 50% do lixo doméstico brasileiro e pode virar adubo.',
  },
  {
    'nome': 'Eletrônico',
    'subtitulo': 'Celulares, pilhas, cabos',
    'icone': Icons.devices_outlined,
    'cor': Color(0xFF9C27B0),
    'exemplos': 'Celulares, computadores, pilhas, baterias, carregadores, TVs.',
    'descarte': 'Leve a pontos de coleta específicos em lojas, supermercados ou ecopontos. NUNCA jogue no lixo comum.',
    'degradacao': 'Componentes eletrônicos podem levar centenas de anos para se decompor.',
    'impacto': 'Contém metais pesados como chumbo e mercúrio que contaminam o solo e a água.',
    'curiosidade': 'O Brasil é o 5° maior gerador de lixo eletrônico do mundo, produzindo 2,1 milhões de toneladas por ano.',
  },
  {
    'nome': 'Perigoso',
    'subtitulo': 'Produtos químicos, remédios',
    'icone': Icons.warning_amber_outlined,
    'cor': Color(0xFFF44336),
    'exemplos': 'Tintas, solventes, remédios vencidos, pesticidas, pilhas alcalinas.',
    'descarte': 'Leve a farmácias, postos de saúde ou ecopontos especializados. NUNCA jogue no esgoto ou lixo comum.',
    'degradacao': 'Varia muito, mas os compostos químicos podem persistir por décadas.',
    'impacto': 'Contamina mananciais de água potável e pode causar doenças graves em humanos e animais.',
    'curiosidade': 'Jogar remédios no vaso sanitário é crime ambiental no Brasil.',
  },
];