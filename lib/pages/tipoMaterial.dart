import 'package:flutter/material.dart';

class Tipomaterial extends StatefulWidget {
  const Tipomaterial({super.key});

  @override
  State<Tipomaterial> createState() => _TipomaterialState();
}

class _TipomaterialState extends State<Tipomaterial> {
  // Estados dos checkboxes
  bool cabos = true;
  bool disjuntores = false;
  bool sensores = false;
  bool fiosExpostos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002855), // fundo azul escuro
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF004080),
        title: const Text("Tipo de Material Monitorado"),
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
            CheckboxListTile(
              activeColor: Colors.blue,
              checkColor: Colors.white,
              title: const Text("Cabos", style: TextStyle(color: Colors.white)),
              value: cabos,
              onChanged: (val) {
                setState(() => cabos = val!);
              },
            ),
            CheckboxListTile(
              activeColor: Colors.blue,
              checkColor: Colors.white,
              title:
                  const Text("Disjuntores", style: TextStyle(color: Colors.white)),
              value: disjuntores,
              onChanged: (val) {
                setState(() => disjuntores = val!);
              },
            ),
            CheckboxListTile(
              activeColor: Colors.blue,
              checkColor: Colors.white,
              title:
                  const Text("Sensores", style: TextStyle(color: Colors.white)),
              value: sensores,
              onChanged: (val) {
                setState(() => sensores = val!);
              },
            ),
            CheckboxListTile(
              activeColor: Colors.blue,
              checkColor: Colors.white,
              title: const Text("Fios expostos",
                  style: TextStyle(color: Colors.white)),
              value: fiosExpostos,
              onChanged: (val) {
                setState(() => fiosExpostos = val!);
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // lógica para adicionar nova localização
              },
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.lightBlue),
                  SizedBox(width: 8),
                  Text(
                    "Adicionar nova\nlocalização",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
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
                  // confirmar seleção
                  debugPrint("Cabos: $cabos, Disjuntores: $disjuntores, Sensores: $sensores, Fios expostos: $fiosExpostos");
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
