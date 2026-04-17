import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';

class PasswordChangedPage extends StatelessWidget {
  const PasswordChangedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0DAD),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "EcoTech",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // imagem de sucesso
              Image.asset(
                "assets/images/img_senha_alterada.png",
                height: 250,
              ),

              SizedBox(height: 30),

              // titulo
              Text(
                "senha alterada com sucesso!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A0DAD),
                ),
              ),

              SizedBox(height: 10),

              // subtitulo
              Text(
                "Você alterou sua senha com sucesso.\nPor favor, use a nova senha ao fazer login.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: 30),

              // botão para voltar ao login
              ButtonAppWidget(
                onclick: () {
                  // volta para a tela de login e limpa todas as telas anteriores
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/login",
                    (route) => false,
                  );
                },
                title: "OK",
              ),
            ],
          ),
        ),
      ),
    );
  }
}