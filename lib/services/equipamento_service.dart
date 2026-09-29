// lib/services/equipamento_service.dart
import 'api_client.dart';
import '../models/equipamento.dart';
import '../models/alerta.dart' show EquipamentoResumo;

class EquipamentoService {
  EquipamentoService._();

  static Future<ResumoEquipamentos> resumo() async {
    final resposta = await ApiClient.get('/equipamentos/resumo');
    return ResumoEquipamentos.fromJson(resposta['data'] as Map<String, dynamic>);
  }

  /// Lista os equipamentos visíveis ao utilizador (já filtrados pelo
  /// backend por empresa/destaque do Técnico) — usado pelos filtros de
  /// alerta em Definições para mostrar localizações reais em vez de fixas.
  static Future<List<EquipamentoResumo>> listar() async {
    final resposta = await ApiClient.get('/equipamentos?limit=100');
    final lista = resposta['data'] as List<dynamic>;
    return lista.map((e) => EquipamentoResumo.fromJson(e as Map<String, dynamic>)).toList();
  }
}
