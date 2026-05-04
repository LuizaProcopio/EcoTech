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
    // resposta do login
    if (json.containsKey('userId')) {
      return UserModel(
        userId: json['userId'] ?? 0,
        userName: json['userName'] ?? "Sem nome",
        email: '',
        points: 0,
        fotoPerfil: null,
      );
    }

    // resposta do perfil
    final pontosRaw = json['pontos_totais'];
    final pontos = pontosRaw is int
        ? pontosRaw
        : int.tryParse(pontosRaw.toString()) ?? 0;

    return UserModel(
      userId: json['id_usuario'] ?? 0,
      userName: json['nome'] ?? "Sem nome",
      email: json['email'] ?? '',
      points: pontos,
      fotoPerfil: json['foto_perfil'],
    );
  }
}