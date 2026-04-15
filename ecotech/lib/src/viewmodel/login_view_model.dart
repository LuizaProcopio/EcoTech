import 'package:ecotech/src/models/user_model.dart';
import 'package:ecotech/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? erroMessage;

  Future<UserModel?> login(String email, String senha) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, senha);
      final user = UserModel.fromJson(response);
      return user;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}