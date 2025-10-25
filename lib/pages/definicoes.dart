import 'package:flutter/material.dart';

class Definicoes extends StatelessWidget {
  const Definicoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3F86),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text("Definições"),
        centerTitle: true,

        // Botão voltar (sempre volta para a tela anterior)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        // Ícone do lado direito
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ====== ALERTAS ======
          _buildSection([
            _buildTile(
              icon: Icons.notifications,
              title: "Receber Alertas",
              subtitle: "Ativar/desativar recebimento de alertas.",
              trailing: Switch(value: true, onChanged: (v) {}),
              onTap: (){},
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              icon: Icons.volume_up,
              title: "Som de alerta",
              subtitle: "Escolher o som: Padrão, Vibrar, Silencioso.",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                    Navigator.of(context).pushNamed("/Somalarta");
                   },
                  
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              icon: Icons.update,
              title: "Frequência de Atualização",
              subtitle: "Ex.: A cada 5 min, 15 min, em tempo real.",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                    Navigator.of(context).pushNamed("/Frequenciaactualizacao");
                   },
            ),
          ]),

          const SizedBox(height: 24),

          // ====== FILTRO DE ALERTA ======
          const Text(
            "FILTRO DE ALERTA",
            style: TextStyle(
                color: Color.fromRGBO(98, 154, 183, 1),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSection([
            _buildTile(
              icon: Icons.handyman,
              title: "Tipo de Material",
              subtitle:
                  "Permitir escolher quais materiais deseja monitorar.",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                    Navigator.of(context).pushNamed("/Tipomaterial");
                   },
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              icon: Icons.place,
              title: "Localização do Equipamento",
              subtitle:
                  "Definir zonas/áreas para receber alertas específicos.",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                    Navigator.of(context).pushNamed("/Localequipamento");
                   },
            ),
          ]),

          const SizedBox(height: 24),

          // ====== CONTA ======
          const Text(
            "CONTA",
            style: TextStyle(
                color: Color.fromRGBO(98, 154, 183, 1),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSection([
            _buildTile(
              icon: Icons.person,
              title: "Perfil do Utilizador",
              subtitle: "Editar nome, email",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                      Navigator.of(context).pushNamed("/Editarperfil");
                   },
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              icon: Icons.lock,
              title: "Segurança",
              subtitle:
                  "Biometria, PIN ou autenticação em dois fatores (2FA)",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                   onTap: (){
                     Navigator.of(context).pushNamed("/Seguranca");
                   },
            ),
          ]),
        ],
      ),
    );
  }

  /// Construção de cada bloco (parecido com card agrupado)
  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF183A5B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  /// Cada item dentro da seção
  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
