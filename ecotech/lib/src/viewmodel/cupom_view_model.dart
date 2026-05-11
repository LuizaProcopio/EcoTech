import 'package:ecotech/src/services/cupom_service.dart';
import 'package:flutter/material.dart';

class CupomViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? erroMessage;
  List<CupomModel> cupons = [];

  // --------------------------------------------------------
  // LISTAR CUPONS
  // --------------------------------------------------------
  Future<void> listarCupons(int idUsuario) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      cupons = await CupomService.listarCupons(idUsuario);
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // RESGATAR CUPOM
  // --------------------------------------------------------
  Future<bool> resgatarCupom({
    required int idUsuario,
    required int idCupom,
  }) async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      await CupomService.resgatarCupom(
        idUsuario: idUsuario,
        idCupom: idCupom,
      );
      // recarrega a lista depois de resgatar
      await listarCupons(idUsuario);
      return true;
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}