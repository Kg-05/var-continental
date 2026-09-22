import 'package:flutter/material.dart';

/// Paleta partilhada, alinhada com o design do var-frontend (web).
/// Nunca uses cores literais soltas nos ecrãs — usa sempre estes tokens,
/// para manter a app consistente e fácil de re-temáticar no futuro.
class AppColors {
  AppColors._();

  // Fundo
  static const background = Color(0xFF040928);
  static const backgroundGradientEnd = Color(0xFF0E1A3A);

  // Painéis / cartões
  static const panel = Color(0xFF0E1A2B);
  static const panelBorder = Color(0xFF1F2A44);

  // Bordas e campos de formulário
  static const border = Color(0xFF050E4C);
  static const inputFill = Color(0xFF03031B);

  // Acento (ações principais)
  static const accent = Color(0xFF2563EB); // blue-600
  static const accentDark = Color(0xFF1D4ED8); // blue-700

  // Texto
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF9CA3AF); // gray-400
  static const textMuted = Color(0xFF6B7280); // gray-500

  // Estados / severidade
  static const success = Color(0xFF22C55E); // green-500
  static const warning = Color(0xFFEAB308); // yellow-500
  static const danger = Color(0xFFEF4444); // red-500
  static const dangerDark = Color(0xFFDC2626); // red-600

  /// Cor associada ao nível de um alerta (mesma convenção do backend:
  /// razoavel | medio | critico).
  static Color nivelAlerta(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'critico':
        return danger;
      case 'medio':
        return warning;
      default:
        return accent;
    }
  }
}
