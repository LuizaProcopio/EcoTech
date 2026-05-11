import 'package:ecotech/src/models/user_model.dart';
import 'package:ecotech/src/services/user_service.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? erroMessage;
  UserModel? user;

  // --------------------------------------------------------
  // BUSCAR PERFIL
  // --------------------------------------------------------
  Future<void> carregarPerfil(int id) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      user = await UserService.getUser(id);
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // SALVAR FOTO
  // --------------------------------------------------------
  Future<bool> salvarFoto(int userId, String fotoBase64) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      final sucesso = await UserService.salvarFoto(userId, fotoBase64);
      return sucesso;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // ALTERAR NOME
  // --------------------------------------------------------
  Future<bool> alterarNome(int userId, String novoNome) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await UserService.alterarNome(userId, novoNome);
      return true;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // ALTERAR SENHA
  // --------------------------------------------------------
  Future<bool> alterarSenha({
    required int userId,
    required String senhaAtual,
    required String novaSenha,
  }) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await UserService.alterarSenha(
        userId: userId,
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );
      return true;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}