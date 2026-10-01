import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import '../services/locale_aware_mixin.dart';
import '../l10n/strings.dart';

class Definicoes extends StatefulWidget {
  const Definicoes({super.key});

  @override
  State<Definicoes> createState() => _DefinicoesState();
}

class _DefinicoesState extends State<Definicoes> with LocaleAware<Definicoes> {
  bool _receberAlertas = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final valor = await PreferenciasAlerta.receberAlertas();
    if (!mounted) return;
    setState(() => _receberAlertas = valor);
  }

  Future<void> _alterarReceberAlertas(bool valor) async {
    setState(() => _receberAlertas = valor);
    await PreferenciasAlerta.definirReceberAlertas(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3F86),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(AppStrings.t('definicoes.titulo')),
        centerTitle: true,

        // Botão voltar (sempre volta para a tela anterior)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ====== ALERTAS ======
          _buildSection([
            _buildTile(
              icon: Icons.notifications,
              title: AppStrings.t('definicoes.receberAlertas'),
              subtitle: "Ativar/desativar som e vibração dos alertas.",
              trailing: Switch(value: _receberAlertas, onChanged: _alterarReceberAlertas),
              onTap: () => _alterarReceberAlertas(!_receberAlertas),
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              icon: Icons.volume_up,
              title: AppStrings.t('definicoes.somAlerta'),
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
              title: AppStrings.t('definicoes.frequencia'),
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
          Text(
            AppStrings.t('definicoes.secaoFiltro'),
            style: const TextStyle(
                color: Color.fromRGBO(98, 154, 183, 1),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSection([
            _buildTile(
              icon: Icons.handyman,
              title: AppStrings.t('definicoes.tipoMaterial'),
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
              title: AppStrings.t('definicoes.localizacao'),
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
          Text(
            AppStrings.t('definicoes.secaoConta'),
            style: const TextStyle(
                color: Color.fromRGBO(98, 154, 183, 1),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSection([
            _buildTile(
              icon: Icons.person,
              title: AppStrings.t('definicoes.perfilUtilizador'),
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
              title: AppStrings.t('definicoes.seguranca'),
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
