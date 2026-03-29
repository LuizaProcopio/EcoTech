import 'package:ecotech/src/pages/login_page.dart';
import 'package:ecotech/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ecotech/src/pages/create_account.dart';
import 'package:ecotech/src/pages/forgot_password.dart';
import 'package:ecotech/src/pages/password_code.dart';

class AppEcotech extends StatelessWidget {
  const AppEcotech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AppEcotech",
      routes:{
        "/": (_) => HomePage(),
        "/login":(_)=> LoginPage(),
        "/createAccount": (_)=> CreateAccountPage(),
        "/forgotPassword": (_)=> ForgotPasswordPage(),
        "/passwordCode": (_)=> PasswordCodePage(),
      }
    );
  }
}