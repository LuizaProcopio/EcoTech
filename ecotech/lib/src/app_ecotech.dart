import 'package:ecotech/src/pages/login_page.dart';
import 'package:ecotech/src/pages/home_page.dart';
import 'package:ecotech/src/pages/create_account.dart';
import 'package:ecotech/src/viewmodel/login_view_model.dart';
import 'package:ecotech/src/viewmodel/cadastro_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppEcotech extends StatelessWidget {
  const AppEcotech({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // registra o ViewModel de login
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // registra o ViewModel de cadastro
        ChangeNotifierProvider(create: (_) => CadastroViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "AppEcotech",
        routes: {
          "/": (_) => HomePage(),
          "/login": (_) => LoginPage(),
          "/createAccount": (_) => CreateAccountPage(),
        },
      ),
    );
  }
}