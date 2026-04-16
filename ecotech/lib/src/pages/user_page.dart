import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/button_navigator.dart';

class UserModel {
  final String name;
  final int points;
  final String? avatarUrl;

  const UserModel({
    required this.name,
    required this.points,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }
}

// ─── Tela principal ──────────────────────────────────────────────────────────

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  // Teste de nome de usuario e pontuação
  final UserModel _user = const UserModel(
    name: 'Ana Maria',
    points: 50,
    avatarUrl: null,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPointsCard(),
                    const SizedBox(height: 16),
                    _buildNavigationGrid(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cabeçalho ─────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      color: Color(0xFF6A0DAD),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Olá, ${_user.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (_user.avatarUrl != null) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(_user.avatarUrl!),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFC0B4F0),
      child: Text(
        _user.initials,
        style: const TextStyle(
          color: Color(0xFF3C3489),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  // ── Card de pontuação ─────────────────────────────────────────────────────

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF6A0DAD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Seus Eco Pontos',
            style: TextStyle(
              color: Color(0xFFD4C8F7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_user.points} pts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'CONTINUE DESCARTANDO CORRETAMENTE\nPARA GANHAR RECOMPENSAS!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC0B0F2),
              fontSize: 10,
              letterSpacing: 0.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Grade de navegação ────────────────────────────────────────────────────

  Widget _buildNavigationGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ButtonNavigator(
                label: 'Registrar\nDescarte',
                icon: Icons.inbox_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed("/disposalRegistrationPage");
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ButtonNavigator(
                label: 'Recompensas',
                icon: Icons.card_giftcard_outlined,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ButtonNavigator(
                label: 'Ranking',
                icon: Icons.bar_chart_outlined,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ButtonNavigator(
                label: 'Sobre',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.of(context).pushNamed("/aboutPage");
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ButtonNavigator(
          label: 'Suporte',
          icon: Icons.chat_bubble_outline,
          onTap: () {},
          fullWidth: true,
        ),
      ],
    );
  }
}