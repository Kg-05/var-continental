import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Color get _panel2 => const Color(0xFF1C2A3A);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header azul com logo, título e engrenagem
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0D3F86),
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
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F5FB7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text('Análises recentes',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
  child: Container(
    height: 40,
    decoration: BoxDecoration(
      color: const Color(0xFF184C8E),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: TextField(
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        icon: Icon(Icons.search, color: Colors.white70, size: 20),
        hintText: "Pesquisar...",
        hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 14)
      ),
      onSubmitted: (value) {
        print("Pesquisando por: $value"); // ação da pesquisa
      },
    ),
  ),
),

                    const SizedBox(width: 10),
                    SizedBox(
                      height: 45,
                      width: 45,
                      
                      child: ClipOval(
                        child: Image.asset("assets/images/var_2.png", fit: BoxFit.cover,),
                      ),
                      
                      
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _chip('Todos'),
                    const SizedBox(width: 20,),
                    _chip('Hoje'),
                    const SizedBox(width: 20,),
                    _chip('Ontem'),
                    const SizedBox(width: 20,),
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
                          color: _panel2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.sensors_rounded,
                                    size: 16, color: Colors.white70),
                                SizedBox(width: 6),
                                Text('Equipamentos\nMonitorados',
                                    style: TextStyle(
                                        color: Colors.white,
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
                                      backgroundColor:
                                          Colors.white.withOpacity(0.06),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.transparent),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator(
                                      value: 0.62,
                                      strokeWidth: 10,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF5E56D6)),
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
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2970FF)),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('185',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800)),
                                      SizedBox(height: 2),
                                      Text('Equipamentos',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0E2337),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('Hoje',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
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
                              color: _panel2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('11',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 6),
                                  Text('Falhas\nde Hoje',
                                      style: TextStyle(
                                          color: Colors.white70, height: 1.2)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 112,
                            decoration: BoxDecoration(
                              color: _panel2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('6',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 6),
                                  Text('Alertas\nde Hoje',
                                      style: TextStyle(
                                          color: Colors.white70, height: 1.2)),
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
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF2A3946),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );

  Widget _alertCard(String title, String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded,
            color: Color(0xFFFFD400), size: 28),
        title: Text(title,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.black.withOpacity(0.6)))),
    );
    
  }
}