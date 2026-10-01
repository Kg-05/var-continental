import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 para sair do app
import 'pages/home.dart';
import 'pages/dashboard.dart';
import 'pages/alerts.dart';
import 'pages/profile.dart';
import 'theme/app_colors.dart';
import 'services/alerta_service.dart';
import 'services/som_service.dart';
import 'services/preferencias_service.dart';
import 'services/locale_aware_mixin.dart';
import 'l10n/strings.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with LocaleAware<Shell> {
  int index = 0;
  late PageController _pageController;

  bool _monitorAtivo = true;
  int? _ultimoNaoLidos;

  final pages = const [
    HomePage(),
    DashboardPage(),
    AlertsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: index);
    _monitorarAlertas();
  }

  @override
  void dispose() {
    _monitorAtivo = false;
    _pageController.dispose();
    super.dispose();
  }

  /// Verifica periodicamente se surgiram alertas novos e, nesse caso, toca
  /// o som/vibração escolhido em Definições > Som de alerta. O intervalo é
  /// lido de novo a cada ciclo, para reagir logo que o técnico mude a
  /// Frequência de Atualização, sem precisar de reiniciar a app. A primeira
  /// leitura só define o ponto de partida — não toca som ao abrir a app com
  /// alertas por ler já existentes.
  Future<void> _monitorarAlertas() async {
    try {
      _ultimoNaoLidos = (await AlertaService.resumo()).naoLidos;
    } catch (_) {
      // Sem ligação neste arranque — tenta de novo no próximo ciclo.
    }

    while (_monitorAtivo) {
      final frequencia = await PreferenciasAlerta.frequencia();
      await Future.delayed(Duration(seconds: frequencia.segundos));
      if (!_monitorAtivo) return;

      try {
        final naoLidos = (await AlertaService.resumo()).naoLidos;
        if (_ultimoNaoLidos != null && naoLidos > _ultimoNaoLidos!) {
          await SomService.tocarAlerta();
        }
        _ultimoNaoLidos = naoLidos;
      } catch (_) {
        // Falha pontual de rede — tenta de novo no próximo ciclo.
      }
    }
  }

  void onPageChanged(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void onNavTap(int newIndex) {
    setState(() {
      index = newIndex;
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<bool> _onWillPop() async {
    // Mostra alerta antes de sair
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.panel,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Sair do aplicativo", style: TextStyle(color: AppColors.textPrimary)),
            content: const Text(
              "Tens certeza que desejas sair?",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancelar",
                    style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop(); // fecha o app
                },
                child: const Text("Sair",
                    style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // 👈 intercepta botão voltar
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: pages,
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.panelBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  label: AppStrings.t('nav.inicio'),
                  icon: Icons.home_rounded,
                  onTap: () => onNavTap(0),
                  active: index == 0,
                ),
                _NavItem(
                  label: AppStrings.t('nav.dashboard'),
                  icon: Icons.dashboard_rounded,
                  onTap: () => onNavTap(1),
                  active: index == 1,
                ),
                _NavItem(
                  label: AppStrings.t('nav.alertas'),
                  icon: Icons.notifications_none_rounded,
                  onTap: () => onNavTap(2),
                  active: index == 2,
                ),
                _NavItem(
                  label: AppStrings.t('nav.perfil'),
                  icon: Icons.person,
                  onTap: () => onNavTap(3),
                  active: index == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return InkResponse(
        onTap: onTap,
        radius: 28,
        child: Icon(icon, size: 24, color: AppColors.textSecondary),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.accent,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
