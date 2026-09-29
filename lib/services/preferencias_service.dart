// lib/services/preferencias_service.dart
// Preferências de alertas guardadas localmente no dispositivo (aba
// Definições > Receber Alertas / Som de alerta / Frequência de Atualização
// / Localização do Equipamento). Persistidas com SharedPreferences para
// sobreviver ao fecho da app — ao contrário do SessionStore (sessão), estas
// não têm dados sensíveis, por isso não há problema em manter entre sessões.
import 'package:shared_preferences/shared_preferences.dart';

enum SomAlerta { padrao, vibrar, silencioso }

/// Opções mostradas em "Frequência de Atualização", já convertidas para
/// segundos — é isto que o monitor de alertas em segundo plano (ver
/// shell.dart) usa para decidir de quanto em quanto tempo verificar se há
/// alertas novos.
enum FrequenciaAtualizacao {
  tempoReal(15, 'Tempo real (recomendado)'),
  cincoMin(300, 'A cada 5 minutos'),
  quinzeMin(900, 'A cada 15 minutos'),
  umaHora(3600, 'A cada 1 hora');

  final int segundos;
  final String rotulo;
  const FrequenciaAtualizacao(this.segundos, this.rotulo);
}

class PreferenciasAlerta {
  PreferenciasAlerta._();

  static const _chaveReceberAlertas = 'pref_receber_alertas';
  static const _chaveSomAlerta = 'pref_som_alerta';
  static const _chaveFrequencia = 'pref_frequencia_atualizacao';
  static const _chaveLocalizacoes = 'pref_filtro_localizacoes';
  static const _chaveMateriais = 'pref_filtro_materiais';

  static Future<bool> receberAlertas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveReceberAlertas) ?? true;
  }

  static Future<void> definirReceberAlertas(bool ativo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveReceberAlertas, ativo);
  }

  static Future<SomAlerta> somAlerta() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getString(_chaveSomAlerta);
    return SomAlerta.values.firstWhere(
      (e) => e.name == valor,
      orElse: () => SomAlerta.padrao,
    );
  }

  static Future<void> definirSomAlerta(SomAlerta som) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveSomAlerta, som.name);
  }

  static Future<FrequenciaAtualizacao> frequencia() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getString(_chaveFrequencia);
    return FrequenciaAtualizacao.values.firstWhere(
      (e) => e.name == valor,
      orElse: () => FrequenciaAtualizacao.tempoReal,
    );
  }

  static Future<void> definirFrequencia(FrequenciaAtualizacao frequencia) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveFrequencia, frequencia.name);
  }

  /// Conjunto de localizações (Equipamento.localizacao) a mostrar nos
  /// alertas — vazio significa "sem filtro" (mostra todas).
  static Future<Set<String>> localizacoesFiltradas() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_chaveLocalizacoes) ?? const []).toSet();
  }

  static Future<void> definirLocalizacoesFiltradas(Set<String> localizacoes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chaveLocalizacoes, localizacoes.toList());
  }

  /// Categorias de material selecionadas em "Tipo de Material" — guardadas
  /// para a app lembrar a escolha do técnico, mas ainda sem efeito sobre a
  /// lista de alertas: o backend não tem (ainda) um campo de categoria por
  /// equipamento para filtrar por aqui.
  static Future<Set<String>> materiaisFiltrados() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_chaveMateriais) ?? const []).toSet();
  }

  static Future<void> definirMateriaisFiltrados(Set<String> materiais) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chaveMateriais, materiais.toList());
  }
}
