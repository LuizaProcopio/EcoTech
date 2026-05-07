class UserModel {
  final int userId;
  final String userName;
  final String email;
  final int points;
  final String? fotoPerfil;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.points,
    this.fotoPerfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // resposta do perfil
    if (json.containsKey('id_usuario')) {
      final pontosRaw = json['pontos_totais'];
      final pontos = pontosRaw is int
          ? pontosRaw
          : int.tryParse(pontosRaw.toString()) ?? 0;

      return UserModel(
        userId: json['id_usuario'] ?? 0,
        userName: json['nome'] ?? '',
        email: json['email'] ?? '',
        points: pontos,
        fotoPerfil: json['foto_perfil'],
      );
    }

    // resposta do login
    return UserModel(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      email: '',
      points: 0,
      fotoPerfil: null,
    );
  }
}