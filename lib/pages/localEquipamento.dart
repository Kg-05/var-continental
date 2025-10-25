import 'package:flutter/material.dart';

class Localequipamento extends StatefulWidget {
  const Localequipamento({super.key});

  @override
  State<Localequipamento> createState() => _LocalequipamentoState();
}

class _LocalequipamentoState extends State<Localequipamento> {
  // Lista de áreas monitoradas
  final Map<String, bool> areas = {
    "Escritório principal": true,
    "Subestação norte": false,
    "Armazém": false,
    "Corredor central": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF002855),// fundo azul
      appBar: AppBar(
        toolbarHeight: 80,
         backgroundColor: const Color(0xFF0D3F86),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Localização do Equipamento",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Áreas Monitoradas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de áreas com checkboxes
            Expanded(
              child: ListView(
                children: areas.keys.map((area) {
                  return CheckboxListTile(
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    title: Text(
                      area,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: areas[area],
                    onChanged: (bool? value) {
                      setState(() {
                        areas[area] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Adicionar nova localização
            GestureDetector(
              onTap: () {
                // ação para adicionar nova localização
              },
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.lightBlueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Adicionar nova localização",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botão confirmar
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
              child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
                  // ação confirmar
                  print("Selecionados: ${areas.entries.where((e) => e.value).map((e) => e.key).toList()}");
                },
                child: const Text(
                  "Confirmar Seleção",
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
