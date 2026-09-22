import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                    value: '230',
                    title: 'Total de Equipamentos\nMonitorados',
                    progress: 0.75,
                  ),
                  const SizedBox(height: 10),
                  _cardLarge(
                    value: '180',
                    title: 'Equipamentos\nInspecionados pela IA',
                    progress: 0.55,
                    trailing: '15',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _cardSmallIcon(
                          value: '24',
                          title: 'Alertas\nRegistradas',
                          icon: Icons.show_chart,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _cardSmallIcon(
                          value: '8',
                          title: 'Falhas\nConfirmadas',
                          icon: Icons.warning_amber_rounded,
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
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Uptime Médio\nGeral (%)',
                                style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
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
                          child: _gauge96(),
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
                        color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
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
            child: Icon(icon, color: AppColors.accent, size: 22),
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
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Equipamentos\nem Manutenção',
                style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
          ),
          const SizedBox(width: 8),
          const Text('10',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _gauge96() {
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
        const SizedBox(
          height: 90,
          width: 90,
          child: CircularProgressIndicator(
            value: 0.96,
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            backgroundColor: Colors.transparent,
          ),
        ),
        const Text('96%',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
