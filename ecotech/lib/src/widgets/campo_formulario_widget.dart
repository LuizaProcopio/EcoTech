import 'package:flutter/material.dart';

class CampoFormularioWidget extends StatefulWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final bool obscure;

  const CampoFormularioWidget({
    required this.label,
    required this.controller,
    required this.obscure,
    this.icon,
    super.key,
  });

  @override
  State<CampoFormularioWidget> createState() => _CampoFormularioWidgetState();
}

class _CampoFormularioWidgetState extends State<CampoFormularioWidget> {
  // controla se a senha está visível ou não
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      // se for campo de senha, usa o _senhaVisivel para controlar
      // se não for campo de senha, nunca esconde
      obscureText: widget.obscure ? !_senhaVisivel : false,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(widget.icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

        // só mostra o botão do olho se for campo de senha
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _senhaVisivel = !_senhaVisivel;
                  });
                },
              )
            : null,
      ),
    );
  }
}