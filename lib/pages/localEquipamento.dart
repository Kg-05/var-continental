import 'package:flutter/material.dart';
import '../models/alerta.dart' show EquipamentoResumo;
import '../services/equipamento_service.dart';
import '../services/preferencias_service.dart';
import '../services/api_client.dart';

class Localequipamento extends StatefulWidget {
  const Localequipamento({super.key});

  @override
  State<Localequipamento> createState() => _LocalequipamentoState();
}

class _LocalequipamentoState extends State<Localequipamento> {
  // true = mostrar alertas desta localização; começa tudo marcado (sem
  // filtro) até a preferência guardada ser carregada.
  final Map<String, bool> _areas = {};
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await Future.wait([
        EquipamentoService.listar(),
        PreferenciasAlerta.localizacoesFiltradas(),
      ]);
      final equipamentos = resultados[0] as List<EquipamentoResumo>;
      final selecionadas = resultados[1] as Set<String>;

      final localizacoes = <String>{};
      for (final equipamento in equipamentos) {
        final loc = equipamento.localizacao;
        if (loc != null && loc.trim().isNotEmpty) {
          localizacoes.add(loc);
        }
      }

      if (!mounted) return;
      setState(() {
        _areas
          ..clear()
          ..addEntries(localizacoes.map(
            // Vazio nas preferências = sem filtro = todas marcadas.
            (loc) => MapEntry(loc, selecionadas.isEmpty || selecionadas.contains(loc)),
          ));
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.message;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível carregar as localizações.';
        _carregando = false;
      });
    }
  }

  Future<void> _confirmar() async {
    final todasMarcadas = _areas.values.every((v) => v);
    // Se estão todas marcadas guardamos "sem filtro" (conjunto vazio), para
    // que um novo equipamento futuro apareça automaticamente sem o técnico
    // ter de voltar aqui marcá-lo manualmente.
    final selecionadas = todasMarcadas
        ? <String>{}
        : _areas.entries.where((e) => e.value).map((e) => e.key).toSet();

    await PreferenciasAlerta.definirLocalizacoesFiltradas(selecionadas);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtro de localização guardado.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002855), // fundo azul
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
      body: _corpo(),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(_erro!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    if (_areas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Sem equipamentos com localização registada.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Padding(
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
          Expanded(
            child: ListView(
              children: _areas.keys.map((area) {
                return CheckboxListTile(
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  title: Text(area, style: const TextStyle(color: Colors.white)),
                  value: _areas[area],
                  onChanged: (bool? value) {
                    setState(() {
                      _areas[area] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
    );
  }
}
