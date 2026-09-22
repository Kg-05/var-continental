import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com logo, título e engrenagem
            Container(
              decoration: const BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ExitButton(),
                      const Text('Início',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
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
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text('Análises recentes',
                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                            cursorColor: AppColors.accent,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                              hintText: "Pesquisar...",
                              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            onSubmitted: (value) {
                              // TODO: ligar à pesquisa real quando o app for integrado com a API
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: ClipOval(
                          child: Image.asset("assets/images/var_2.png", fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chip('Todos'),
                      const SizedBox(width: 10),
                      _chip('Hoje'),
                      const SizedBox(width: 10),
                      _chip('Ontem'),
                      const SizedBox(width: 10),
                      _chip('Semana'),
                    ],
                  ),
                ],
              ),
            ),

            // Conteúdo (exemplo)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                children: [
                  _alertCard('Material danificado identificado',
                      'A IA detectou uma falha no equipamento A32', '19:30'),
                  _alertCard('Material danificado identificado',
                      'A IA detectou uma falha no equipamento A32', '19:25'),
                  _alertCard('Material danificado identificado',
                      'A IA detectou uma falha no equipamento A32', '19:25'),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.panel,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.panelBorder),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.sensors_rounded, size: 16, color: AppColors.textSecondary),
                                  SizedBox(width: 6),
                                  Text('Equipamentos\nMonitorados',
                                      style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 140,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        strokeWidth: 10,
                                        backgroundColor: Colors.white.withOpacity(0.06),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator(
                                        value: 0.62,
                                        strokeWidth: 10,
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: 2.2,
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator(
                                          value: 0.23,
                                          strokeWidth: 10,
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('185',
                                            style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800)),
                                        SizedBox(height: 2),
                                        Text('Equipamentos',
                                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.inputFill,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('Hoje',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 112,
                              decoration: BoxDecoration(
                                color: AppColors.panel,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.panelBorder),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('11',
                                        style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 6),
                                    Text('Falhas\nde Hoje',
                                        style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 112,
                              decoration: BoxDecoration(
                                color: AppColors.panel,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.panelBorder),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('6',
                                        style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 6),
                                    Text('Alertas\nde Hoje',
                                        style: TextStyle(color: AppColors.textSecondary, height: 1.2)),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
      );

  Widget _alertCard(String title, String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
        title: Text(title,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ),
    );
  }
}
