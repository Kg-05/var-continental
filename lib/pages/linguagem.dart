import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/locale_service.dart';

const _codigosPorIdioma = {
  "Português (Angola)": "pt",
  "Português (Portugal)": "pt",
  "Português (Brasil)": "pt",
  "Inglês (English)": "en",
  "Espanhol (Español)": "es",
  "Francês (Français)": "fr",
  "Alemão (Deutsch)": "de",
  "Italiano (Italiano)": "it",
  "Russo (Русский)": "ru",
  "Turco (Türkçe)": "tr",
  "Suaíli (Kiswahili)": "sw",
};

const _chaveIdiomaLabel = 'pref_idioma_label';

class Linguagem extends StatefulWidget {
  const Linguagem({super.key});

  @override
  State<Linguagem> createState() => _LinguagemState();
}

class _LinguagemState extends State<Linguagem> {
  String _idiomaSelecionado = "Português (Angola)";

  final List<String> idiomas = _codigosPorIdioma.keys.toList();

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getString(_chaveIdiomaLabel);
    if (!mounted || guardado == null || !idiomas.contains(guardado)) return;
    setState(() => _idiomaSelecionado = guardado);
  }

  Future<void> _selecionar(String idioma) async {
    setState(() => _idiomaSelecionado = idioma);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveIdiomaLabel, idioma);

    final codigo = _codigosPorIdioma[idioma] ?? 'pt';
    await LocaleController.instance.definir(codigo);

    if (!idiomasTraduzidos.contains(codigo) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$idioma ainda não tem tradução — a app continua em Português.')),
      );
    }
  }

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_idiomaSelecionado,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("Idioma actual da interface",
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
                    if (value != null) _selecionar(value);
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
