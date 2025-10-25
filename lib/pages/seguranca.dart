import 'package:flutter/material.dart';

class Seguranca extends StatefulWidget {
  const Seguranca({super.key});

  @override
  State<Seguranca> createState() => _SegurancaState();
}

class _SegurancaState extends State<Seguranca> {
  bool pinSelected = true;
  bool biometriaSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F), // Fundo azul escuro
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(0xFF004080),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // botão de voltar
          },
        ),
        title: const Text(
          "Segurança da conta",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              value: pinSelected,
              onChanged: (value) {
                setState(() {
                  pinSelected = value ?? false;
                });
              },
              title: const Text(
                "PIN",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.lightBlue,
              checkColor: Colors.white,
            ),
            CheckboxListTile(
              value: biometriaSelected,
              onChanged: (value) {
                setState(() {
                  biometriaSelected = value ?? false;
                });
              },
              title: const Text(
                "Biometria",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.lightBlue,
              checkColor: Colors.white,
            ),
            const Spacer(),
           Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
            child:  SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
                  // ação ao clicar em "Avançar"
                },
                child: const Text(
                  "Avançar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
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
