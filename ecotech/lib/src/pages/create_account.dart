import 'package:ecotech/src/viewmodel/cadastro_view_model.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountPage> {
  final personController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPassWordController = TextEditingController(); // ← novo

  void _createAccount() async {
    // validação dos campos antes de chamar a API
    if (personController.text.isEmpty ||
        emailController.text.isEmpty ||
        passWordController.text.isEmpty ||
        confirmPassWordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // validação se as senhas são iguais
    if (passWordController.text != confirmPassWordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // pega o ViewModel
    final viewModel = context.read<CadastroViewModel>();

    // chama a API
    final user = await viewModel.cadastro(
      personController.text,
      emailController.text,
      passWordController.text,
    );

    // se o cadastro foi bem sucedido navega para o login
    if (user != null && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Conta criada com sucesso! Faça seu login."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CadastroViewModel>();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),

                Text(
                  "Crie sua Conta!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                SizedBox(height: 10),

                Image.asset(
                  "assets/images/img_criacao_senha.png",
                  height: 200,
                ),

                SizedBox(height: 20),

                CampoFormularioWidget(
                  label: "NOME",
                  controller: personController,
                  obscure: false,
                  icon: Icons.person,
                ),

                SizedBox(height: 15),

                CampoFormularioWidget(
                  label: "E-MAIL",
                  controller: emailController,
                  obscure: false,
                  icon: Icons.email,
                ),

                SizedBox(height: 15),

                CampoFormularioWidget(
                  label: "SENHA",
                  controller: passWordController,
                  obscure: true,
                  icon: Icons.lock,
                ),

                SizedBox(height: 15),

                // ← campo novo de confirmar senha
                CampoFormularioWidget(
                  label: "CONFIRMAR SENHA",
                  controller: confirmPassWordController,
                  obscure: true,
                  icon: Icons.lock_outline,
                ),

                SizedBox(height: 15),

                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
                    : ButtonAppWidget(
                        onclick: _createAccount,
                        title: "CADASTRAR",
                      ),

                SizedBox(height: 15),

                Visibility(
                  visible: viewModel.erroMessage != null,
                  child: Text(
                    viewModel.erroMessage ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}