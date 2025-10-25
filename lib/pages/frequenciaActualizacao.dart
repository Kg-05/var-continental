import 'package:flutter/material.dart';

class Frequenciaactualizacao extends StatefulWidget {
  const Frequenciaactualizacao({super.key});

  @override
  State<Frequenciaactualizacao> createState() => _FrequenciaactualizacaoState();
}

enum Frequencia { tempoReal, cincoMin, quinzeMin, umaHora }

class _FrequenciaactualizacaoState extends State<Frequenciaactualizacao> {
  Frequencia _selecionado = Frequencia.tempoReal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002855), // fundo azul escuro
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF004080),
        title: const Text("Frequência de atualização"),
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
            RadioListTile<Frequencia>(
              activeColor: Colors.blue,
              title: const Text("Tempo real (recomendado)",
                  style: TextStyle(color: Colors.white)),
              value: Frequencia.tempoReal,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            RadioListTile<Frequencia>(
              activeColor: Colors.blue,
              title: const Text("A cada 5 minutos",
                  style: TextStyle(color: Colors.white)),
              value: Frequencia.cincoMin,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            RadioListTile<Frequencia>(
              activeColor: Colors.blue,
              title: const Text("A cada 15 minutos",
                  style: TextStyle(color: Colors.white)),
              value: Frequencia.quinzeMin,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            RadioListTile<Frequencia>(
              activeColor: Colors.blue,
              title: const Text("A cada 1 hora",
                  style: TextStyle(color: Colors.white)),
              value: Frequencia.umaHora,
              groupValue: _selecionado,
              onChanged: (value) {
                setState(() {
                  _selecionado = value!;
                });
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
            ),
          ],
        ),
      ),
    );
  }
}
