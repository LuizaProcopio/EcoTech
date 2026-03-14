import 'package:ecotech/src/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppEcotech extends StatelessWidget {
  const AppEcotech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AppEcotech",
      routes:{
        "/": (_) => HomePage()
      }
    );
  }
}