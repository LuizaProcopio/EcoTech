import 'package:ecotech/src/pages/login_page.dart';
import 'package:ecotech/src/pages/home_page.dart';
import 'package:ecotech/src/pages/create_account.dart';
import 'package:ecotech/src/pages/forgot_password_page.dart';
import 'package:ecotech/src/pages/verify_code_page.dart';
import 'package:ecotech/src/pages/new_password_page.dart';
import 'package:ecotech/src/pages/password_changed_page.dart';
import 'package:ecotech/src/viewmodel/login_view_model.dart';
import 'package:ecotech/src/viewmodel/cadastro_view_model.dart';
import 'package:ecotech/src/viewmodel/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppEcotech extends StatelessWidget {
  const AppEcotech({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CadastroViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "AppEcotech",
        routes: {
          "/": (_) => HomePage(),
          "/login": (_) => LoginPage(),
          "/createAccount": (_) => CreateAccountPage(),
          "/forgotPassword": (_) => ForgotPasswordPage(),
          "/verifyCode": (_) => VerifyCodePage(),
          "/newPassword": (_) => NewPasswordPage(),
          "/passwordChanged": (_) => PasswordChangedPage(),
        },
      ),
    );
  }
}