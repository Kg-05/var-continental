// lib/services/usuario_service.dart
import 'api_client.dart';

class UsuarioService {
  UsuarioService._();

  /// PATCH /usuarios/:id — qualquer utilizador pode alterar o próprio nome.
  static Future<String> atualizarNome(String id, String nome) async {
    final resposta = await ApiClient.patch('/usuarios/$id', {'nome': nome});
    final data = resposta['data'] as Map<String, dynamic>;
    return data['nome'] as String;
  }
}
