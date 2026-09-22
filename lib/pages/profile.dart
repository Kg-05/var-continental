import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ======== CABEÇALHO ========
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/Definicoes");
                          },
                          icon: const Icon(Icons.settings),
                          color: AppColors.textPrimary,
                          iconSize: 28,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/Editarperfil");
                          },
                          icon: const Icon(Icons.edit),
                          color: AppColors.textPrimary,
                          iconSize: 26,
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.inputFill,
                      backgroundImage: AssetImage("assets/images/var_2.png"),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mutombo Pedro",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Técnico de Equipamentos",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ======== INFORMAÇÕES ========
              _sectionCard([
                _infoTile(icon: Icons.person, title: "Nome", subtitle: "Mutombo Pedro"),
                _divider(),
                _infoTile(icon: Icons.work, title: "Função", subtitle: "Técnico de Equipamentos"),
                _divider(),
                _infoTile(icon: Icons.email, title: "Email", subtitle: "mtbpedro17@gmail.com"),
              ]),

              const SizedBox(height: 16),

              // ======== PREFERÊNCIAS ========
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "PREFERÊNCIAS",
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              _sectionCard([
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.textSecondary),
                  title: const Text("Linguagem", style: TextStyle(color: AppColors.textPrimary)),
                  trailing: const Text("Português", style: TextStyle(color: AppColors.textMuted)),
                  onTap: () {
                    Navigator.of(context).pushNamed("/Linguagem");
                  },
                ),
                _divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.textSecondary),
                  title: const Text("Informações", style: TextStyle(color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.of(context).pushNamed("/Privacidade");
                  },
                ),
                _divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: AppColors.textSecondary),
                  title: const Text("Modo escuro", style: TextStyle(color: AppColors.textPrimary)),
                  activeColor: AppColors.accent,
                  value: true,
                  onChanged: (v) {},
                ),
                _divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications, color: AppColors.textSecondary),
                  title: const Text("Notificações", style: TextStyle(color: AppColors.textPrimary)),
                  activeColor: AppColors.accent,
                  value: true,
                  onChanged: (v) {},
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => const Divider(color: AppColors.panelBorder, height: 1);

  Widget _infoTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
    );
  }
}
