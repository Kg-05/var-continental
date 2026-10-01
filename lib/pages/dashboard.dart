import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/alerta.dart';
import '../models/equipamento.dart';
import '../services/alerta_service.dart';
import '../services/equipamento_service.dart';
import '../services/api_client.dart';
import '../services/locale_aware_mixin.dart';
import '../l10n/strings.dart';

/// Dashboard com dados reais: estatísticas de equipamentos vêm de
/// GET /equipamentos/resumo e de alertas de GET /alertas/resumo — ambos já
/// filtrados no backend pela empresa do utilizador e, no caso de um
/// Técnico, apenas pelos equipamentos que lhe foram destacados.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with LocaleAware<DashboardPage> {
  ResumoEquipamentos? _equipamentos;
  ResumoAlertas? _alertas;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await Future.wait([
        EquipamentoService.resumo(),
        AlertaService.resumo(),
      ]);
      if (!mounted) return;
      setState(() {
        _equipamentos = resultados[0] as ResumoEquipamentos;
        _alertas = resultados[1] as ResumoAlertas;
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.message;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível carregar a dashboard.';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              alignment: Alignment.center,
              child: Text(AppStrings.t('dashboard.titulo'),
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Expanded(child: _corpo()),
          ],
        ),
      ),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
              const SizedBox(height: 12),
              Text(_erro!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregar,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final equipamentos = _equipamentos!;
    final alertas = _alertas!;
    final percentOperacional = equipamentos.percentOperacional;

    return RefreshIndicator(
      onRefresh: _carregar,
      color: AppColors.accent,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _cardLarge(
            value: '${equipamentos.total}',
            title: AppStrings.t('dashboard.totalEquipamentos'),
            progress: percentOperacional,
            trailing: '${(percentOperacional * 100).round()}% ${AppStrings.t('home.operacional')}',
          ),
          const SizedBox(height: 10),
          _cardLarge(
            value: '${equipamentos.comAlertasPorResolver}',
            title: AppStrings.t('dashboard.comAlertas'),
            progress: equipamentos.total == 0
                ? 0
                : equipamentos.comAlertasPorResolver / equipamentos.total,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _cardSmallIcon(
                  value: '${alertas.critico}',
                  title: AppStrings.t('dashboard.alertasCriticos'),
                  icon: Icons.report_problem_rounded,
                  accent: AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _cardSmallIcon(
                  value: '${alertas.naoLidos}',
                  title: AppStrings.t('dashboard.alertasNaoLidos'),
                  icon: Icons.mark_email_unread_rounded,
                  accent: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _cardMaintenance(equipamentos.manutencao),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.panelBorder),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.t('dashboard.distribuicaoEstado'),
                          style: const TextStyle(color: AppColors.textSecondary, height: 1.2)),
                      const Spacer(),
                      _legendaEstado(AppStrings.t('dashboard.operacional'), equipamentos.operacional, AppColors.success),
                      const SizedBox(height: 4),
                      _legendaEstado(AppStrings.t('dashboard.manutencao'), equipamentos.manutencao, AppColors.warning),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.panelBorder),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: _gaugeOperacional(percentOperacional),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendaEstado(String label, int valor, Color cor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ),
        Text('$valor', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _cardLarge({
    required String value,
    required String title,
    required double progress,
    String? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelBorder),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
              const Spacer(),
              if (trailing != null)
                Text(trailing,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 30),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, height: 1.1)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: progress,
                color: AppColors.accent,
                backgroundColor: AppColors.inputFill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSmallIcon({
    required String value,
    required String title,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelBorder),
      ),
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(color: AppColors.textSecondary, height: 1.1)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: accent, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _cardMaintenance(int equipamentosManutencao) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.build_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(AppStrings.t('dashboard.emManutencao'),
                style: const TextStyle(color: AppColors.textSecondary, height: 1.2)),
          ),
          const SizedBox(width: 8),
          Text('$equipamentosManutencao',
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _gaugeOperacional(double percent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 90,
          width: 90,
          child: CircularProgressIndicator(
            value: 1,
            strokeWidth: 10,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
        ),
        SizedBox(
          height: 90,
          width: 90,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            backgroundColor: Colors.transparent,
          ),
        ),
        Text('${(percent * 100).round()}%',
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
