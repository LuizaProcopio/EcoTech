import 'package:ecotech/src/services/forgot_password_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordService _service = ForgotPasswordService();

  bool isLoading = false;
  String? erroMessage;

  // guarda o email e codigo para usar nas proximas telas
  String email = '';
  String codigo = '';

  // --------------------------------------------------------
  // TELA 1 — envia o código por email
  // --------------------------------------------------------
  Future<bool> enviarCodigo(String emailDigitado) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await _service.enviarCodigo(emailDigitado);
      email = emailDigitado;
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
  // TELA 2 — verifica o código
  // --------------------------------------------------------
  Future<bool> verificarCodigo(String codigoDigitado) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await _service.verificarCodigo(email, codigoDigitado);
      codigo = codigoDigitado;
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
  // TELA 3 — salva a nova senha
  // --------------------------------------------------------
  Future<bool> novaSenha(String novaSenha) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await _service.novaSenha(email, codigo, novaSenha);
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