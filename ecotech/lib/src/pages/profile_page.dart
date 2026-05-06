import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _salvandoFoto = false;

  // funciona tanto no web quanto no celular usando bytes diretamente
  Future<void> _editarFoto(UserModel user) async {
    final picker = ImagePicker();

    final XFile? imagem = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
      maxWidth: 400,
      maxHeight: 400,
    );

    if (imagem == null) return;

    setState(() => _salvandoFoto = true);

    try {
      // usa readAsBytes() diretamente do XFile — funciona no web e celular
      final bytes = await imagem.readAsBytes();
      final base64 = base64Encode(bytes);

      final sucesso = await UserService.salvarFoto(user.userId, base64);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sucesso
                ? "Foto atualizada com sucesso!"
                : "Erro ao salvar foto!"),
            backgroundColor: sucesso ? Colors.green : Colors.redAccent,
          ),
        );

        if (sucesso) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao processar a foto: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvandoFoto = false);
    }
  }

  void _alterarNome(UserModel user) {
    final nomeController = TextEditingController(text: user.userName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Alterar Nome"),
        content: TextField(
          controller: nomeController,
          decoration: const InputDecoration(
            labelText: "Novo nome",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              if (nomeController.text.isEmpty) return;
              Navigator.of(context).pop();

              try {
                await UserService.alterarNome(user.userId, nomeController.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nome atualizado com sucesso!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao alterar nome: $e"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Text(
              "Salvar",
              style: TextStyle(color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sair da Conta"),
        content: const Text("Tem certeza que deseja sair?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/",
                (route) => false,
              );
            },
            child: const Text(
              "Sair",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;

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
          children: [
            // banner roxo com foto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF6A0DAD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _buildFoto(user),
                      GestureDetector(
                        onTap: _salvandoFoto ? null : () => _editarFoto(user),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _salvandoFoto
                              ? const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF6A0DAD),
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Color(0xFF6A0DAD),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Editar foto de perfil',
                    style: TextStyle(
                      color: Color(0xFFD4C8F7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // nome clicável para alterar
                  _buildInfoCardEditavel(
                    icon: Icons.person_outline,
                    label: 'Nome',
                    value: user.userName,
                    onTap: () => _alterarNome(user),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoCard(Icons.email_outlined, 'E-mail', user.email),

                  const SizedBox(height: 20),

                  const Text(
                    'Segurança',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.lock_outline,
                    label: 'Alterar Senha',
                    onTap: () => Navigator.of(context).pushNamed(
                      "/alterPasswordPage",
                      arguments: user.userId,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Lojas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.store_outlined,
                    label: 'Gerenciar Lojas',
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),

                  // botão sair da conta
                  GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'SAIR DA CONTA',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoto(UserModel user) {
    if (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: MemoryImage(base64Decode(user.fotoPerfil!)),
      );
    }

    final initials = user.userName.contains(" ")
        ? "${user.userName.split(' ')[0][0]}${user.userName.split(' ')[1][0]}".toUpperCase()
        : user.userName.substring(0, 2).toUpperCase();

    return CircleAvatar(
      radius: 55,
      backgroundColor: const Color(0xFFC0B4F0),
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFF3C3489),
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: Colors.black45)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardEditavel({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black45)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined,
                size: 16, color: Color(0xFF6A0DAD)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6A0DAD), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}