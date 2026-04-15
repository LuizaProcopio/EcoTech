class UserModel {
  final String token;
  final int userId;
  final String userName;

  UserModel({
    required this.token,
    required this.userId,
    required this.userName,
  });

  // converte o JSON que a API retorna em um objeto UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}