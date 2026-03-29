import 'package:ecotech/src/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:ecotech/src/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_fundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo + Nome do app
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.recycling,
                  color: Color(0xFF6B3FA0),
                  size: 50,
                ),
                SizedBox(width: 10),
                Text(
                  "EcoTech",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Texto de boas-vindas
            Text(
              "Bem Vindo!",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Faça login para entrar no sistema.",
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 50),
            // Botão de login
            ButtonWidget(
              texto: "LOGIN",
              onClik: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}