import 'package:flutter/material.dart';

class Somalerta extends StatefulWidget {
  const Somalerta({super.key});

  @override
  State<Somalerta> createState() => _SomalertaState();
}

enum SomAlerta { padrao, silencioso, vibrar, personalizado }

class _SomalertaState extends State<Somalerta> {
  SomAlerta _selecionado = SomAlerta.padrao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002855), // fundo azul escuro
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF004080),
        title: const Text("Som de Alerta"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<SomAlerta>(
              activeColor: Colors.blue,
              title: const Text("Padrão (recomendado)",
                  style: TextStyle(color: Colors.white)),
              value: SomAlerta.padrao,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            RadioListTile<SomAlerta>(
              activeColor: Colors.blue,
              title: const Text("Silencioso",
                  style: TextStyle(color: Colors.white)),
              value: SomAlerta.silencioso,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            RadioListTile<SomAlerta>(
              activeColor: Colors.blue,
              title: const Text("Vibrar",
                  style: TextStyle(color: Colors.white)),
              value: SomAlerta.vibrar,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            ListTile(
              title: const Text("Toque personalizado",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline)),
              onTap: () {
                // lógica para abrir seleção de toque
              },
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
              child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // salvar a preferência
                },
                child: const Text(
                  "Salvar preferência",
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
