import 'package:ecotech/src/services/loja_service.dart';
import 'package:flutter/material.dart';

class LojaViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? erroMessage;
  List<LojaModel> lojas = [];
  Map<String, dynamic>? resultadoCupom;

  // --------------------------------------------------------
  // LISTAR LOJAS
  // --------------------------------------------------------
  Future<void> listarLojas(int idUsuario) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      lojas = await LojaService.listarLojas(idUsuario);
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // CRIAR LOJA
  // --------------------------------------------------------
  Future<bool> criarLoja({
    required int idUsuario,
    required String nome,
    required String email,
    required String senha,
  }) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await LojaService.criarLoja(
        idUsuario: idUsuario,
        nome: nome,
        email: email,
        senha: senha,
      );
      await listarLojas(idUsuario);
      return true;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --------------------------------------------------------
  // VERIFICAR CUPOM
  // --------------------------------------------------------
  Future<bool> verificarCupom({
    required String codigoCupom,
    required double valorCompra,
    required int idLoja,
  }) async {
    isLoading = true;
    erroMessage = null;
    resultadoCupom = null;
    notifyListeners();

    try {
      resultadoCupom = await LojaService.verificarCupom(
        codigoCupom: codigoCupom,
        valorCompra: valorCompra,
        idLoja: idLoja,
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

  // limpa o resultado do cupom
  void limparCupom() {
    resultadoCupom = null;
    erroMessage = null;
    notifyListeners();
  }
}