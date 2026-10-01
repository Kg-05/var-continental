// lib/services/usuario_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'session_store.dart';

class UsuarioService {
  UsuarioService._();

  /// PATCH /usuarios/:id — qualquer utilizador pode alterar o próprio nome.
  static Future<String> atualizarNome(String id, String nome) async {
    final resposta = await ApiClient.patch('/usuarios/$id', {'nome': nome});
    final data = resposta['data'] as Map<String, dynamic>;
    return data['nome'] as String;
  }

  /// PATCH /usuarios/:id/avatar (multipart) — envia a nova foto de perfil
  /// e devolve o caminho relativo guardado no backend
  /// (ex: "/uploads/imagens/169...-123.jpg"). Usa ApiClient.urlFicheiro()
  /// para montar o URL completo a mostrar na app.
  static Future<String?> atualizarAvatar(String id, File ficheiro) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/usuarios/$id/avatar');
    final request = http.MultipartRequest('PATCH', uri);
    if (SessionStore.token != null) {
      request.headers['Authorization'] = 'Bearer ${SessionStore.token}';
    }
    request.files.add(await http.MultipartFile.fromPath('avatar', ficheiro.path));

    final http.StreamedResponse streamed;
    try {
      streamed = await request.send();
    } catch (_) {
      throw ApiException('Sem ligação ao servidor. Verifica a tua internet.');
    }
    final response = await http.Response.fromStream(streamed);

    dynamic parsed;
    try {
      parsed = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    } catch (_) {
      throw ApiException('Resposta inválida do servidor (${response.statusCode}).');
    }

    if (parsed is Map<String, dynamic> && parsed['success'] == false) {
      throw ApiException(parsed['message'] as String? ?? 'Erro ao atualizar a foto de perfil.');
    }
    if (response.statusCode >= 400) {
      throw ApiException('Erro ao atualizar a foto de perfil (${response.statusCode}).');
    }

    final data = (parsed as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return data['avatarUrl'] as String?;
  }
}
