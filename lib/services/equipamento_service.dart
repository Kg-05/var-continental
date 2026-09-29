// lib/services/equipamento_service.dart
import 'api_client.dart';
import '../models/equipamento.dart';

class EquipamentoService {
  EquipamentoService._();

  static Future<ResumoEquipamentos> resumo() async {
    final resposta = await ApiClient.get('/equipamentos/resumo');
    return ResumoEquipamentos.fromJson(resposta['data'] as Map<String, dynamic>);
  }
}
