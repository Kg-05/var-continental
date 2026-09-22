// lib/services/alerta_service.dart
import 'api_client.dart';
import '../models/alerta.dart';

class AlertaService {
  AlertaService._();

  static Future<List<Alerta>> listar() async {
    final resposta = await ApiClient.get('/alertas');
    final lista = resposta['data'] as List<dynamic>;
    return lista.map((e) => Alerta.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Alerta> buscarPorId(String id) async {
    final resposta = await ApiClient.get('/alertas/$id');
    return Alerta.fromJson(resposta['data'] as Map<String, dynamic>);
  }

  /// Redefine nível, muda o status do tratamento (inclui pedir apoio à
  /// Central) e/ou deixa uma nota — mesmos campos aceites pelo
  /// PATCH /alertas/:id no backend. Todos os parâmetros são opcionais,
  /// mas pelo menos um deve ser passado.
  static Future<Alerta> atualizar(
    String id, {
    String? nivel,
    String? status,
    String? notaTecnico,
  }) async {
    final body = <String, dynamic>{};
    if (nivel != null) body['nivel'] = nivel;
    if (status != null) body['status'] = status;
    if (notaTecnico != null) body['notaTecnico'] = notaTecnico;

    final resposta = await ApiClient.patch('/alertas/$id', body);
    return Alerta.fromJson(resposta['data'] as Map<String, dynamic>);
  }
}
