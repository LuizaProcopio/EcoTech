import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final String texto;
  final void Function() onClik;

  const ButtonWidget({
    required this.texto,
    required this.onClik,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF000000), width: 1.5),
        fixedSize: Size(220, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onClik,
      child: Text(
        texto,
        style: TextStyle(
          color: Color(0xFF000000),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}