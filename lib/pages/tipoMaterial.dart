import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';

/// Categorias fixas — o backend ainda não tem um campo de categoria por
/// equipamento, por isso a seleção aqui é guardada (para o técnico não a
/// perder), mas não filtra a lista de alertas enquanto esse campo não
/// existir no modelo de Equipamento.
const _categorias = ['Cabos', 'Disjuntores', 'Sensores', 'Fios expostos'];

class Tipomaterial extends StatefulWidget {
  const Tipomaterial({super.key});

  @override
  State<Tipomaterial> createState() => _TipomaterialState();
}

class _TipomaterialState extends State<Tipomaterial> {
  Set<String> _selecionados = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final salvos = await PreferenciasAlerta.materiaisFiltrados();
    if (!mounted) return;
    setState(() {
      // Vazio (nunca configurado) = tudo marcado por omissão.
      _selecionados = salvos.isEmpty ? _categorias.toSet() : salvos;
      _carregando = false;
    });
  }

  Future<void> _confirmar() async {
    await PreferenciasAlerta.definirMateriaisFiltrados(_selecionados);
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
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF004080),
        title: const Text("Tipo de Material Monitorado"),
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
                  for (final categoria in _categorias)
                    CheckboxListTile(
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      title: Text(categoria, style: const TextStyle(color: Colors.white)),
                      value: _selecionados.contains(categoria),
                      onChanged: (val) {
                        setState(() {
                          if (val ?? false) {
                            _selecionados.add(categoria);
                          } else {
                            _selecionados.remove(categoria);
                          }
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    "Este filtro ainda não afeta a lista de alertas — o "
                    "backend não regista a categoria de material por "
                    "equipamento.",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
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
                        onPressed: _confirmar,
                        child: const Text(
                          "Confirmar Seleção",
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
