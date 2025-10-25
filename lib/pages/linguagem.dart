import 'package:flutter/material.dart';

class Linguagem extends StatefulWidget {
  const Linguagem({super.key});

  @override
  State<Linguagem> createState() => _LinguagemState();
}

class _LinguagemState extends State<Linguagem> {
  String _idiomaSelecionado = "Português (Angola)";

  final List<String> idiomas = [
    "Português (Angola)",
    "Português (Portugal)",
    "Português (Brasil)",
    "Inglês (English)",
    "Espanhol (Español)",
    "Francês (Français)",
    "Alemão (Deutsch)",
    "Italiano (Italiano)",
    "Russo (Русский)",
    "Turco (Türkçe)",
    "Suaíli (Kiswahili)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text("Idioma da Aplicação"),
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Português (Angola)",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Idioma actual da interface",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: idiomas.map((idioma) {
                return RadioListTile<String>(
                  title: Text(idioma),
                  value: idioma,
                  groupValue: _idiomaSelecionado,
                  onChanged: (value) {
                    setState(() {
                      _idiomaSelecionado = value!;
                    });
                  },
                  activeColor: Colors.blue,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
