import 'package:flutter/material.dart';

class Emailutilizador extends StatelessWidget {
  const Emailutilizador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFF002855), // azul escuro do fundo
      appBar: AppBar(
       backgroundColor: const Color(0xFF0D3F86),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Email do Utilizador",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Digite o novo email",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF002D6F), // cor da caixa de input
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Depois desta alteração, só poderás voltar a atualizar o nome depois de 30 dias.",
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
              child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // azul do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
                  // ação de confirmar
                },
                child: const Text(
                  "Confirmar Alteração",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
              )
          ],
        ),
      ),
    );
  }
}
