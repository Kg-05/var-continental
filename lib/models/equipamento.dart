// lib/models/equipamento.dart
// Espelha o retorno de GET /equipamentos/resumo (EquipamentoService.resumo
// no backend) — usado pelas dashboards (Início e Dashboard) para mostrar
// contagens reais em vez de valores fictícios.

class ResumoEquipamentos {
  final int total;
  final int operacional;
  final int manutencao;
  final int comAlertasPorResolver;

  const ResumoEquipamentos({
    required this.total,
    required this.operacional,
    required this.manutencao,
    required this.comAlertasPorResolver,
  });

  factory ResumoEquipamentos.fromJson(Map<String, dynamic> json) => ResumoEquipamentos(
        total: json['total'] as int? ?? 0,
        operacional: json['operacional'] as int? ?? 0,
        manutencao: json['manutencao'] as int? ?? 0,
        comAlertasPorResolver: json['comAlertasPorResolver'] as int? ?? 0,
      );

  double get percentOperacional => total == 0 ? 0 : operacional / total;
}
