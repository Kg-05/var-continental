// lib/models/alerta.dart
// Espelha o model Alerta do backend (ver prisma/schema.prisma e
// AlertaService.buscarPorId/listar).

class EquipamentoResumo {
  final String id;
  final String nome;
  final String? localizacao;

  const EquipamentoResumo({
    required this.id,
    required this.nome,
    this.localizacao,
  });

  factory EquipamentoResumo.fromJson(Map<String, dynamic> json) => EquipamentoResumo(
        id: json['id'] as String,
        nome: json['nome'] as String,
        localizacao: json['localizacao'] as String?,
      );
}

/// Valores possíveis de Alerta.status no backend.
class StatusAlerta {
  static const aberto = 'Aberto';
  static const emCurso = 'EmCurso';
  static const aguardaApoio = 'AguardaApoio';
  static const resolvido = 'Resolvido';

  static const todos = [aberto, emCurso, aguardaApoio, resolvido];

  static String rotulo(String status) {
    switch (status) {
      case emCurso:
        return 'Em curso';
      case aguardaApoio:
        return 'A aguardar apoio';
      case resolvido:
        return 'Resolvido';
      default:
        return 'Aberto';
    }
  }
}

class Alerta {
  final String id;
  final String descricao;
  final String nivel;
  final String status;
  final String? notaTecnico;
  final DateTime? lidoEm;
  final DateTime criadoEm;
  final EquipamentoResumo equipamento;

  const Alerta({
    required this.id,
    required this.descricao,
    required this.nivel,
    required this.status,
    this.notaTecnico,
    this.lidoEm,
    required this.criadoEm,
    required this.equipamento,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
        id: json['id'] as String,
        descricao: json['descricao'] as String,
        nivel: json['nivel'] as String,
        status: (json['status'] as String?) ?? StatusAlerta.aberto,
        notaTecnico: json['notaTecnico'] as String?,
        // O backend devolve as datas em UTC (termina em "Z") — .toLocal()
        // converte para a hora do dispositivo antes de qualquer ecrã as
        // formatar, senão mostram sempre a hora UTC (ex: 1h atrasada em
        // Angola, UTC+1).
        lidoEm: json['lidoEm'] != null ? DateTime.tryParse(json['lidoEm'] as String)?.toLocal() : null,
        criadoEm: DateTime.parse(json['criadoEm'] as String).toLocal(),
        equipamento: EquipamentoResumo.fromJson(json['equipamento'] as Map<String, dynamic>),
      );
}

/// Espelha o retorno de GET /alertas/resumo (AlertaService.resumo no backend).
class ResumoAlertas {
  final int total;
  final int naoLidos;
  final int razoavel;
  final int medio;
  final int critico;

  const ResumoAlertas({
    required this.total,
    required this.naoLidos,
    required this.razoavel,
    required this.medio,
    required this.critico,
  });

  factory ResumoAlertas.fromJson(Map<String, dynamic> json) {
    final porNivel = (json['porNivel'] as Map<String, dynamic>?) ?? const {};
    return ResumoAlertas(
      total: json['total'] as int? ?? 0,
      naoLidos: json['naoLidos'] as int? ?? 0,
      razoavel: porNivel['razoavel'] as int? ?? 0,
      medio: porNivel['medio'] as int? ?? 0,
      critico: porNivel['critico'] as int? ?? 0,
    );
  }
}
