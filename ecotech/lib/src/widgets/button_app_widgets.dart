import 'package:flutter/material.dart';

class ButtonAppWidget extends StatelessWidget {
  // 1. Mude de 'texto' para 'title'
  final String title; 
  // 2. Mude de 'onClik' (com um 'c') para 'onclick' (tudo minúsculo)
  final void Function() onclick; 

  const ButtonAppWidget({
    required this.title,
    required this.onclick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Color(0xFF6B3FA0),
        fixedSize: const Size(220, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onclick,
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}