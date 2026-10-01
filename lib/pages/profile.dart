import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../services/session_store.dart';
import '../services/usuario_service.dart';
import '../services/api_client.dart';
import '../models/usuario.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _enviandoFoto = false;

  Future<void> _escolherFonteEEnviar() async {
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: AppColors.textPrimary),
              title: const Text('Tirar foto', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.textPrimary),
              title: const Text('Escolher da galeria', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (origem == null) return;

    final usuario = SessionStore.usuario;
    if (usuario == null) return;

    try {
      final XFile? ficheiro = await ImagePicker().pickImage(
        source: origem,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (ficheiro == null) return;

      setState(() => _enviandoFoto = true);

      final novoAvatarUrl = await UsuarioService.atualizarAvatar(usuario.id, File(ficheiro.path));

      SessionStore.usuario = Usuario(
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        papel: usuario.papel,
        empresaId: usuario.empresaId,
        funcionario: usuario.funcionario,
        avatarUrl: novoAvatarUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada.'), backgroundColor: AppColors.success),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerDark),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a foto de perfil.'),
          backgroundColor: AppColors.dangerDark,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviandoFoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = SessionStore.usuario;
    final funcionario = usuario?.funcionario;
    final avatarUrl = usuario?.avatarUrl;

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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.inputFill,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(ApiClient.urlFicheiro(avatarUrl))
                              : const AssetImage("assets/images/var_2.png") as ImageProvider,
                        ),
                        if (_enviandoFoto)
                          const Positioned.fill(
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.black45,
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: GestureDetector(
                            onTap: _enviandoFoto ? null : _escolherFonteEEnviar,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.panel, width: 2),
                              ),
                              child: const Icon(Icons.photo_camera, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      usuario?.nome ?? "—",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      funcionario?.cargo ?? "Técnico",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ======== INFORMAÇÕES ========
              // Campos alinhados ao Funcionario do backend: nome, cargo,
              // email, telefone e status (Ativo | Inativo | Pendente) —
              // vêm da resposta de POST /auth/login guardada em SessionStore.
              _sectionCard([
                _infoTile(icon: Icons.person, title: "Nome", subtitle: usuario?.nome ?? "—"),
                _divider(),
                _infoTile(icon: Icons.work, title: "Cargo", subtitle: funcionario?.cargo ?? "—"),
                _divider(),
                _infoTile(icon: Icons.email, title: "Email", subtitle: usuario?.email ?? "—"),
                _divider(),
                _infoTile(icon: Icons.phone, title: "Telefone", subtitle: funcionario?.telefone ?? "Não informado"),
                _divider(),
                _statusTile(status: funcionario?.status ?? "Ativo"),
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

  /// Cor por estado, mesma convenção do var-frontend: Ativo = verde,
  /// Pendente = amarelo, Inativo = vermelho.
  Widget _statusTile({required String status}) {
    final cor = switch (status) {
      "Ativo" => AppColors.success,
      "Pendente" => AppColors.warning,
      _ => AppColors.danger,
    };
    return ListTile(
      leading: const Icon(Icons.verified_user_outlined, color: AppColors.textSecondary),
      title: const Text("Estado", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      subtitle: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(status, style: TextStyle(color: cor, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
