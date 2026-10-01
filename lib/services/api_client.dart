// lib/services/api_client.dart
// Cliente HTTP centralizado, mesmo papel do lib/api.ts do var-frontend:
// injeta o token JWT em cada pedido e trata respostas 401 limpando a
// sessão guardada.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'session_store.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();

  // Backend em produção (Railway).
  static const String baseUrl = 'https://var-mvp-continental.up.railway.app/api/v1';

  // Ficheiros estáticos (avatares, etc.) são servidos na raiz do servidor,
  // fora do prefixo /api/v1 — ex: avatarUrl "/uploads/imagens/x.jpg" vira
  // "https://var-mvp-continental.up.railway.app/uploads/imagens/x.jpg".
  static String urlFicheiro(String caminhoRelativo) {
    final raiz = baseUrl.replaceFirst('/api/v1', '');
    return '$raiz$caminhoRelativo';
  }

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (SessionStore.token != null) 'Authorization': 'Bearer ${SessionStore.token}',
      };

  static Future<Map<String, dynamic>> get(String path) async {
    final http.Response res;
    try {
      res = await http.get(Uri.parse('$baseUrl$path'), headers: _headers());
    } catch (e, st) {
      // Log da exceção real — visível com `flutter run` (ou `adb logcat`)
      // mesmo em release. O utilizador só vê a mensagem genérica abaixo.
      debugPrint('[ApiClient.get] $path falhou: $e\n$st');
      throw ApiException('Sem ligação ao servidor. Verifica a tua internet.');
    }
    return _handle(res);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final http.Response res;
    try {
      res = await http.post(Uri.parse('$baseUrl$path'), headers: _headers(), body: jsonEncode(body));
    } catch (e, st) {
      debugPrint('[ApiClient.post] $path falhou: $e\n$st');
      throw ApiException('Sem ligação ao servidor. Verifica a tua internet.');
    }
    return _handle(res);
  }

  static Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) async {
    final http.Response res;
    try {
      res = await http.patch(Uri.parse('$baseUrl$path'), headers: _headers(), body: jsonEncode(body));
    } catch (e, st) {
      debugPrint('[ApiClient.patch] $path falhou: $e\n$st');
      throw ApiException('Sem ligação ao servidor. Verifica a tua internet.');
    }
    return _handle(res);
  }

  static Map<String, dynamic> _handle(http.Response res) {
    if (res.statusCode == 401) {
      SessionStore.clear();
    }

    dynamic parsed;
    try {
      parsed = res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body);
    } catch (_) {
      throw ApiException('Resposta inválida do servidor (${res.statusCode}).');
    }

    if (parsed is Map<String, dynamic> && parsed['success'] == false) {
      throw ApiException(parsed['message'] as String? ?? 'Erro ao comunicar com o servidor.');
    }
    if (res.statusCode >= 400) {
      throw ApiException('Erro ao comunicar com o servidor (${res.statusCode}).');
    }
    return parsed as Map<String, dynamic>;
  }
}
