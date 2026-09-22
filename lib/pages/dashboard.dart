import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';

/// Valores fictícios (ainda sem ligação à API), mas agora mapeados aos
/// campos reais do backend: Equipamento.status (Operacional|Manutencao),
/// Alerta.nivel (razoavel|medio|critico) e Alerta.lidoEm.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const int totalEquipamentos = 38;
  static const int equipamentosOperacionais = 31;
  static const int equipamentosManutencao = 4;
  static const int equipamentosComAlertas = 9;
  static const int alertasCriticos = 3;
  static const int alertasNaoLidos = 5;

  @override
  Widget build(BuildContext context) {
    final percentOperacional = equipamentosOperacionais / totalEquipamentos;

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ExitButton(),
                  const Text('Dashboard',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/Definicoes");
                    },
                    icon: const Icon(Icons.settings),
                    color: AppColors.textPrimary,
                    iconSize: 28,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _cardLarge(
                    value: '$totalEquipamentos',
                    title: 'Total de Equipamentos\nMonitorados',
                    progress: percentOperacional,
                    trailing: '${(percentOperacional * 100).round()}% operacional',
                  ),
                  const SizedBox(height: 10),
                  _cardLarge(
                    value: '$equipamentosComAlertas',
                    title: 'Equipamentos com\nAlertas por Resolver',
                    progress: equipamentosComAlertas / totalEquipamentos,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _cardSmallIcon(
                          value: '$alertasCriticos',
                          title: 'Alertas\nCríticos',
                          icon: Icons.report_problem_rounded,
                          accent: AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _cardSmallIcon(
                          value: '$alertasNaoLidos',
                          title: 'Alertas\nNão Lidos',
                          icon: Icons.mark_email_unread_rounded,
                          accent: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _cardMaintenance(),
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
                              const Text('Distribuição\npor Estado',
                                  style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
                              const Spacer(),
                              _legendaEstado('Operacional', equipamentosOperacionais, AppColors.success),
                              const SizedBox(height: 4),
                              _legendaEstado('Manutenção', equipamentosManutencao, AppColors.warning),
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
            ),
          ],
        ),
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

  Widget _cardMaintenance() {
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
          const Expanded(
            child: Text('Equipamentos\nem Manutenção',
                style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
          ),
          const SizedBox(width: 8),
          const Text('$equipamentosManutencao',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
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
