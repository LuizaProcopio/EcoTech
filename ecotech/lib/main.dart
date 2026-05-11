import 'package:ecotech/src/app_ecotech.dart';
import 'package:ecotech/src/helpers/auth_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  // necessário para usar async antes do runApp
  WidgetsFlutterBinding.ensureInitialized();

  // verifica se já tem usuário logado
  final userId = await AuthStorage.getUserId();

  runApp(AppEcotech(initialUserId: userId));
}