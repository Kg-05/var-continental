import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 para sair do app
import 'pages/home.dart';
import 'pages/dashboard.dart';
import 'pages/alerts.dart';
import 'pages/profile.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  late PageController _pageController;

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            title: const Text("Sair do aplicativo"),
            content: const Text("Tens certeza que desejas sair?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop(); // fecha o app
                },
                child: const Text("Sair"),
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
              color: const Color(0xFF343C44),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  label: 'Casa',
                  icon: Icons.home_rounded,
                  onTap: () => onNavTap(0),
                  active: index == 0,
                ),
                _NavItem(
                  label: 'Dashboard',
                  icon: Icons.dashboard_rounded,
                  onTap: () => onNavTap(1),
                  active: index == 1,
                ),
                _NavItem(
                  label: 'Alertas',
                  icon: Icons.notifications_none_rounded,
                  onTap: () => onNavTap(2),
                  active: index == 2,
                ),
                _NavItem(
                  label: 'Perfil',
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
        child: Icon(icon, size: 24, color: Colors.white70),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3E74E8), Color(0xFF274EC7)],
          ),
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
