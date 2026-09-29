import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';
import '../models/alerta.dart';
import '../models/equipamento.dart';
import '../services/alerta_service.dart';
import '../services/equipamento_service.dart';
import '../services/api_client.dart';
import 'alert_detail.dart';

/// Início com dados reais: estatísticas e os 3 alertas mais recentes vêm da
/// API (GET /alertas, /alertas/resumo e /equipamentos/resumo), já filtrados
/// no backend pela empresa/equipamentos destacados do utilizador.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ResumoEquipamentos? _equipamentos;
  ResumoAlertas? _alertasResumo;
  List<Alerta> _recentes = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await Future.wait([
        EquipamentoService.resumo(),
        AlertaService.resumo(),
        AlertaService.listar(),
      ]);
      if (!mounted) return;
      setState(() {
        _equipamentos = resultados[0] as ResumoEquipamentos;
        _alertasResumo = resultados[1] as ResumoAlertas;
        // Já vem ordenado por nível (desc) e depois por data (desc) do backend.
        _recentes = (resultados[2] as List<Alerta>).take(3).toList();
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.message;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível carregar os dados.';
        _carregando = false;
      });
    }
  }

  Future<void> _abrirDetalhe(Alerta alerta) async {
    final atualizou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AlertDetailPage(alertaId: alerta.id)),
    );
    if (atualizou == true) _carregar();
  }

  String _formatarHora(DateTime data) =>
      '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

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
                      child: const Text('Alertas recentes',
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
                              hintText: "Pesquisar equipamento ou alerta...",
                              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            onSubmitted: (value) {
                              // A pesquisa detalhada já existe no ecrã de Alertas;
                              // aqui mostramos apenas o resumo dos mais recentes.
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
                      _chip('Críticos'),
                      const SizedBox(width: 10),
                      _chip('Não lidos'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _corpo()),
          ],
        ),
      ),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
              const SizedBox(height: 12),
              Text(_erro!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregar,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final equipamentos = _equipamentos!;
    final alertasResumo = _alertasResumo!;
    final percentOperacional = equipamentos.percentOperacional;

    return RefreshIndicator(
      onRefresh: _carregar,
      color: AppColors.accent,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        children: [
          if (_recentes.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.panelBorder),
              ),
              child: const Center(
                child: Text('Sem alertas recentes',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ..._recentes.map(_alertCard),
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
                          Text('Equipamentos\nOperacionais',
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
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(Colors.transparent),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                value: percentOperacional,
                                strokeWidth: 10,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${equipamentos.total}',
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 2),
                                Text('${(percentOperacional * 100).round()}% operacional',
                                    style: const TextStyle(
                                        color: AppColors.textSecondary, fontSize: 12)),
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${alertasResumo.critico}',
                                style: const TextStyle(
                                    color: AppColors.danger,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            const Text('Alertas\nCríticos',
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${alertasResumo.naoLidos}',
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            const Text('Alertas\nNão Lidos',
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

  Widget _alertCard(Alerta alerta) {
    final cor = AppColors.nivelAlerta(alerta.nivel);
    final lido = alerta.lidoEm != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: lido ? AppColors.panelBorder : cor.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Icon(Icons.warning_amber_rounded, color: cor, size: 28),
        title: Text(alerta.equipamento.nome,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        subtitle: Text(alerta.descricao, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Text(_formatarHora(alerta.criadoEm),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        onTap: () => _abrirDetalhe(alerta),
      ),
    );
  }
}
