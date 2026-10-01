import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';
import '../models/alerta.dart';
import '../models/equipamento.dart';
import '../services/alerta_service.dart';
import '../services/equipamento_service.dart';
import '../services/api_client.dart';
import '../services/locale_aware_mixin.dart';
import '../l10n/strings.dart';
import 'alert_detail.dart';

/// Início com dados reais: estatísticas e os 3 alertas mais recentes vêm da
/// API (GET /alertas, /alertas/resumo e /equipamentos/resumo), já filtrados
/// no backend pela empresa/equipamentos destacados do utilizador.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with LocaleAware<HomePage> {
  ResumoEquipamentos? _equipamentos;
  ResumoAlertas? _alertasResumo;
  List<Alerta> _todosAlertas = [];
  List<Alerta> _exibidos = [];
  bool _carregando = true;
  String? _erro;

  // 'todos' | 'criticos' | 'naoLidos'
  String _filtroChip = 'todos';
  String _termoPesquisa = '';

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
        _todosAlertas = resultados[2] as List<Alerta>;
        _exibidos = _aplicarFiltros();
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

  /// Sem filtro nenhum ativo mostramos só os 3 mais recentes (vista rápida);
  /// assim que um chip ou a pesquisa estiverem ativos, mostramos tudo o que
  /// corresponder, sem limite artificial.
  List<Alerta> _aplicarFiltros() {
    var lista = _todosAlertas;

    if (_filtroChip == 'criticos') {
      lista = lista.where((a) => a.nivel == 'critico').toList();
    } else if (_filtroChip == 'naoLidos') {
      lista = lista.where((a) => a.lidoEm == null).toList();
    }

    final termo = _termoPesquisa.trim().toLowerCase();
    if (termo.isNotEmpty) {
      lista = lista.where((a) {
        return a.descricao.toLowerCase().contains(termo) ||
            a.equipamento.nome.toLowerCase().contains(termo);
      }).toList();
    }

    final semFiltro = _filtroChip == 'todos' && termo.isEmpty;
    return semFiltro ? lista.take(3).toList() : lista;
  }

  void _selecionarChip(String chip) {
    setState(() {
      _filtroChip = chip;
      _exibidos = _aplicarFiltros();
    });
  }

  void _pesquisar(String termo) {
    setState(() {
      _termoPesquisa = termo;
      _exibidos = _aplicarFiltros();
    });
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
                      Text(AppStrings.t('nav.inicio'),
                          style: const TextStyle(
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
                      child: Text(AppStrings.t('home.alertasRecentes'),
                          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500)),
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
                            onChanged: _pesquisar,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                              hintText: AppStrings.t('home.pesquisar'),
                              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: _carregando ? null : _carregar,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          height: 44,
                          width: 44,
                          child: _carregando
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: AppColors.accent),
                                )
                              : ClipOval(
                                  child: Image.asset("assets/images/var_2.png", fit: BoxFit.cover),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chip(AppStrings.t('home.chip.todos'), 'todos'),
                      const SizedBox(width: 10),
                      _chip(AppStrings.t('home.chip.criticos'), 'criticos'),
                      const SizedBox(width: 10),
                      _chip(AppStrings.t('home.chip.naoLidos'), 'naoLidos'),
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
          if (_exibidos.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.panelBorder),
              ),
              child: Center(
                child: Text(
                  _filtroChip == 'todos' && _termoPesquisa.trim().isEmpty
                      ? AppStrings.t('home.semAlertas')
                      : AppStrings.t('home.nenhumEncontrado'),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ..._exibidos.map(_alertCard),
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
                      Row(
                        children: [
                          const Icon(Icons.sensors_rounded, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(AppStrings.t('home.equipamentosOperacionais'),
                              style: const TextStyle(
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
                                Text('${(percentOperacional * 100).round()}% ${AppStrings.t('home.operacional')}',
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
                        child: Text(AppStrings.t('home.hoje'),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
                            Text(AppStrings.t('home.alertasCriticos'),
                                style: const TextStyle(color: AppColors.textSecondary, height: 1.2)),
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
                            Text(AppStrings.t('home.alertasNaoLidos'),
                                style: const TextStyle(color: AppColors.textSecondary, height: 1.2)),
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

  Widget _chip(String texto, String valor) {
    final selecionado = _filtroChip == valor;
    return InkWell(
      onTap: () => _selecionarChip(valor),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent.withOpacity(0.2) : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selecionado ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado ? AppColors.accent : AppColors.textSecondary,
            fontWeight: selecionado ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

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
