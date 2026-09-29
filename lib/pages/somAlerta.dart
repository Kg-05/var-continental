import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import '../services/som_service.dart';

class Somalerta extends StatefulWidget {
  const Somalerta({super.key});

  @override
  State<Somalerta> createState() => _SomalertaState();
}

class _SomalertaState extends State<Somalerta> {
  SomAlerta _selecionado = SomAlerta.padrao;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final valor = await PreferenciasAlerta.somAlerta();
    if (!mounted) return;
    setState(() {
      _selecionado = valor;
      _carregando = false;
    });
  }

  Future<void> _salvar() async {
    await PreferenciasAlerta.definirSomAlerta(_selecionado);
    // Deixa o técnico ouvir/sentir de imediato o que acabou de escolher.
    await SomService.tocarAlerta();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferência de som guardada.')),
    );
    Navigator.pop(context);
  }

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
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
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
                  ListTile(
                    title: const Text("Toque personalizado",
                        style: TextStyle(
                            color: Colors.white54,
                            decoration: TextDecoration.underline)),
                    subtitle: const Text(
                      "Disponível quando as notificações push forem ativadas.",
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve.')),
                      );
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                        onPressed: _salvar,
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
