import 'package:ecotech/src/services/ranking_service.dart';
import 'package:flutter/material.dart';

class RankingViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? erroMessage;
  List<RankingItem> ranking = [];

  // --------------------------------------------------------
  // BUSCAR RANKING
  // --------------------------------------------------------
  Future<void> carregarRanking() async {
    isLoading = true;
    erroMessage = null;
    notifyListeners();

    try {
      ranking = await RankingService.getRanking();
    } catch (e) {
      erroMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}