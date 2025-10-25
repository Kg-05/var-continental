import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Color get _header => const Color(0xFF0D3F86);
  Color get _card => const Color(0xFF123A69);
  Color get _cardDark => const Color(0xFF0F3156);
  Color get _track => const Color(0xFF1F5AA0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: _header,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                      onPressed: () async {
                        final bool? confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Sair do sistema"),
                              content: const Text(
                                  "Tem certeza que deseja sair do sistema?"),
                              actions: [
                                TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text(
                                  "Sim, sair",
                                  style: TextStyle(
                                    color: Colors.red, // vermelho para o botão de sair
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text(
                                  "Não, cancelar",
                                  style: TextStyle(
                                    color: Colors.blue, // azul para cancelar (ou pode usar Colors.grey)
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          // Redireciona para Login
                          Navigator.of(context)
                              .pushReplacementNamed("/LoginPage");
                        }
                      },
                      icon: const Icon(Icons.exit_to_app),
                      color: Colors.red,
                      iconSize: 35,
                    ),
                const Text('Dashboard',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                 IconButton(onPressed: () {
                      Navigator.of(context).pushNamed("/Definicoes");
                    }, 
                    icon: Icon(Icons.settings), 
                    color: Colors.white, iconSize: 35,)
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
                          color: _cardDark,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Uptime Médio\nGeral (%)',
                              style: TextStyle(
                                  color: Colors.white70, height: 1.2)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: _cardDark,
                          borderRadius: BorderRadius.circular(14),
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
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              if (trailing != null)
                Text(trailing,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 30),
          Text(title,
              style: const TextStyle(color: Colors.white70, height: 1.1)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: progress,
                color: const Color(0xFF2B7BFF),
                backgroundColor: _track,
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
        color: _cardDark,
        borderRadius: BorderRadius.circular(14),
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(title,
                    style:
                        const TextStyle(color: Colors.white70, height: 1.1)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: const Color(0xFF2B7BFF), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _cardMaintenance() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Color(0xFF2B7BFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Equipamentos\nem Manutenção',
                style: TextStyle(color: Colors.white70, height: 1.2)),
          ),
          const SizedBox(width: 8),
          const Text('10',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
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
            valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
        ),
        SizedBox(
          height: 90,
          width: 90,
          child: CircularProgressIndicator(
            value: 0.96,
            strokeWidth: 10,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF2B7BFF)),
            backgroundColor: Colors.transparent,
          ),
        ),
        const Text('96%',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}