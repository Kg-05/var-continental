import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';

class Frequenciaactualizacao extends StatefulWidget {
  const Frequenciaactualizacao({super.key});

  @override
  State<Frequenciaactualizacao> createState() => _FrequenciaactualizacaoState();
}

class _FrequenciaactualizacaoState extends State<Frequenciaactualizacao> {
  FrequenciaAtualizacao _selecionado = FrequenciaAtualizacao.tempoReal;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final valor = await PreferenciasAlerta.frequencia();
    if (!mounted) return;
    setState(() {
      _selecionado = valor;
      _carregando = false;
    });
  }

  Future<void> _salvar() async {
    await PreferenciasAlerta.definirFrequencia(_selecionado);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferência guardada.')),
    );
    Navigator.pop(context);
  }

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
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final opcao in FrequenciaAtualizacao.values)
                    RadioListTile<FrequenciaAtualizacao>(
                      activeColor: Colors.blue,
                      title: Text(opcao.rotulo, style: const TextStyle(color: Colors.white)),
                      value: opcao,
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
