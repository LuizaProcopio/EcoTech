// class UserModel {
//   final String userName;
//   final int points;

//   UserModel({
//     required this.userName,
//     required this.points,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       userName: json['nome'] ?? "Sem nome",
//       points: json['pontos'] ?? 0,
//     );
//   }
// }

class UserModel {
  final int userId;
  final String userName;
  final int points;

  UserModel({
    required this.userId,
    required this.userName,
    required this.points,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('userId')) {
      return UserModel(
        userId: json['userId'] ?? 0,
        userName: json['userName'] ?? "Sem nome",
        points: 0,
      );
    }

    // pontos_totais vem como string da API, então converte para int
    final pontosRaw = json['pontos_totais'];
    final pontos = pontosRaw is int 
        ? pontosRaw 
        : int.tryParse(pontosRaw.toString()) ?? 0;

    return UserModel(
      userId: json['id_usuario'] ?? 0,
      userName: json['nome'] ?? "Sem nome",
      points: pontos,
    );
  }
}