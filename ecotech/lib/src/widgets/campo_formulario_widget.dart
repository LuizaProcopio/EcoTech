import 'package:flutter/material.dart';

class CampoFormularioWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final bool obscure;

  const CampoFormularioWidget({
    required this.label,
    required this.controller,
    required this.obscure,
    this.icon,
    super.key});


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
    );
  }
}