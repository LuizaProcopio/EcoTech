import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'package:ecotech/src/widgets/button_navigator.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int userId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: FutureBuilder<UserModel?>(
        future: UserService.getUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Erro ao carregar usuário"));
          }

          final user = snapshot.data!;

          return SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, user),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPointsCard(user),
                        const SizedBox(height: 16),
                        _buildNavigationGrid(context, userId),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, UserModel user) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        "/profilePage",
        arguments: user,
      ),
      child: Container(
        color: const Color(0xFF6A0DAD),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _buildAvatar(user),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Olá, ${user.userName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    // se tiver foto mostra a foto, senao mostra as iniciais
    if (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: MemoryImage(base64Decode(user.fotoPerfil!)),
      );
    }

    final initials = user.userName.contains(" ")
        ? "${user.userName.split(' ')[0][0]}${user.userName.split(' ')[1][0]}".toUpperCase()
        : user.userName.substring(0, 2).toUpperCase();

    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFC0B4F0),
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFF3C3489),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPointsCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF6A0DAD),
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
            '${user.points} pts',
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

  Widget _buildNavigationGrid(BuildContext context, int userId) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ButtonNavigator(
                label: 'Registrar\nDescarte',
                icon: Icons.inbox_outlined,
                onTap: () => Navigator.of(context).pushNamed("/disposalRegistration",arguments: userId,),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ButtonNavigator(
                label: 'Recompensas',
                icon: Icons.card_giftcard_outlined,
                onTap: () => Navigator.of(context).pushNamed("/recompensasPage",arguments: userId,),
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
                onTap: () => Navigator.of(context).pushNamed("/rankingPage"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ButtonNavigator(
                label: 'Sobre',
                icon: Icons.info_outline,
                onTap: () => Navigator.of(context).pushNamed("/aboutPage"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ButtonNavigator(
          label: 'Suporte',
          icon: Icons.chat_bubble_outline,
          onTap: () => Navigator.of(context).pushNamed("/suportePage"),
          fullWidth: true,
        ),
      ],
    );
  }
}