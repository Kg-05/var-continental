// lib/services/auth_service.dart
import 'api_client.dart';
import 'session_store.dart';
import '../models/usuario.dart';

class AuthService {
  AuthService._();

  /// Faz login com email/senha (POST /auth/login). Em sucesso, guarda o
  /// token e o perfil do utilizador em SessionStore. Lança ApiException
  /// com uma mensagem já pronta para mostrar ao utilizador em caso de
  /// falha (credenciais inválidas, sem ligação, etc).
  static Future<void> login(String email, String senha) async {
    final resposta = await ApiClient.post('/auth/login', {
      'email': email,
      'senha': senha,
    });
    final data = resposta['data'] as Map<String, dynamic>;

    if (data['totpRequerido'] == true) {
      throw ApiException(
        'Esta conta tem verificação em duas etapas ativada — ainda não suportada nesta app.',
      );
    }

    final token = data['token'] as String;
    final usuario = Usuario.fromJson(data['usuario'] as Map<String, dynamic>);
    SessionStore.set(token, usuario);
  }
}
