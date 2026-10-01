// lib/services/locale_service.dart
// Controlador do idioma da app — persistido localmente e observável, para
// que trocar de idioma em Definições > Idioma se reflita de imediato em
// toda a app (MaterialApp escuta isto e reconstrói quando muda).
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Códigos com tradução real disponível — qualquer outro valor guardado
/// (dos restantes idiomas listados em Definições > Idioma) cai para
/// Português em AppStrings.t() até ser traduzido.
const idiomasTraduzidos = {'pt', 'en'};

class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const _chave = 'pref_idioma';

  String _codigo = 'pt';
  String get codigo => _codigo;

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    _codigo = prefs.getString(_chave) ?? 'pt';
    notifyListeners();
  }

  Future<void> definir(String codigo) async {
    if (_codigo == codigo) return;
    _codigo = codigo;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, codigo);
  }
}
