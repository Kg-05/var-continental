// lib/services/session_store.dart
// Guarda a sessão do utilizador autenticado em memória, para a duração
// da app — sem persistência entre reinícios (o login é sempre refeito
// ao abrir a app de novo, como acontecia antes com o código fixo).

import '../models/usuario.dart';

class SessionStore {
  SessionStore._();

  static String? token;
  static Usuario? usuario;

  static void set(String novoToken, Usuario novoUsuario) {
    token = novoToken;
    usuario = novoUsuario;
  }

  static void clear() {
    token = null;
    usuario = null;
  }

  static bool get autenticado => token != null;
}
