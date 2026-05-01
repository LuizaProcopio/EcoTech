import 'package:flutter/material.dart';
import 'package:ecotech/src/widgets/campo_formulario_widget.dart';
import 'package:ecotech/src/widgets/button_app_widgets.dart';

class PasswordCodePage extends StatefulWidget {
  const PasswordCodePage({super.key});

  @override
  State<PasswordCodePage> createState() => _PasswordCodeState();
}

class _PasswordCodeState extends State<PasswordCodePage> {
  // Controller específico para o campo de código
  final codeController = TextEditingController();

  void _passwordCode() {
    // 1. Validação: Verifica se o campo está vazio
    if (codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, digite o código de verificação!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Interrompe a execução aqui
    }

    // 2. Lógica para navegar para a próxima tela (ex: Redefinir Senha)
    // Navigator.of(context).pushNamed("/resetPassword");
    print("Verificando código: ${codeController.text}");
  }

  void _resendCode() {
    // Lógica para reenviar o código
    print("Reenviando código para o e-mail...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Código reenviado com sucesso!"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD), // Roxo EcoTech
        iconTheme: const IconThemeData(color: Colors.white), // Seta de voltar branca
        title: const Text(
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
                const SizedBox(height: 10),

                // Título idêntico ao da primeira tela
                const Text(
                  "Esqueceu sua senha",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),

                const SizedBox(height: 25),

                // --- QUADRADO COM CONTORNO (Igual à imagem) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Digite o código",
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      
                      const SizedBox(height: 15),

                      // Row para colocar o campo de CÓDIGO e o botão REENVIAR lado a lado
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Alinha verticalmente ao centro
                        children: [
                          // Expanded faz o campo de texto ocupar o máximo de espaço disponível na Row
                          Expanded(
                            child: CampoFormularioWidget(
                              label: "CÓDIGO",
                              controller: codeController,
                              obscure: false,
                              icon: Icons.lock_open,
                            ),
                          ),
                          
                          const SizedBox(width: 15), // Espaço entre o campo e o botão

                          // Botão Reenviar (estilo pílula roxa, como na imagem)
                          ElevatedButton(
                            onPressed: _resendCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A0DAD),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            child: const Text(
                              "REENVIAR",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "ENVIAMOS UM CÓDIGO POR E-MAIL PARA VERIFICAR SEU NÚMERO DE E-MAIL.\nANAMARIA@GMAIL.COM",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // ----------------------------------------------

                const SizedBox(height: 40),

                // Botão principal de ação (grande)
                ButtonAppWidget(
                  onclick: _passwordCode, 
                  title: "ALTERAR SUA SENHA",
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}