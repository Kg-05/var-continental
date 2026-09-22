import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';
import '../models/alerta.dart' as api;
import '../services/alerta_service.dart';
import '../services/api_client.dart';
import 'alert_detail.dart';

/// Ainda usado pela Home para os "alertas recentes" (ver home.dart) —
/// a lista desta página já usa o model real (models/alerta.dart).
/// Espelha o modelo Alerta do backend: descricao, nivel
/// (razoavel|medio|critico), equipamento associado e lidoEm (null = não lido).
/// Os valores aqui continuam fictícios — a estrutura é que é real.
class AlertaMock {
  final String descricao;
  final String nivel;
  final String equipamento;
  final String criadoEm;
  final bool lido;

  const AlertaMock({
    required this.descricao,
    required this.nivel,
    required this.equipamento,
    required this.criadoEm,
    this.lido = false,
  });
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<api.Alerta> alertas = [];
  List<api.Alerta> alertasFiltrados = [];
  bool _mostrandoCampoPesquisa = false;
  String _termoPesquisa = "";
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
      final lista = await AlertaService.listar();
      if (!mounted) return;
      setState(() {
        alertas = lista;
        alertasFiltrados = _aplicarFiltro(lista, _termoPesquisa);
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
        _erro = 'Não foi possível carregar os alertas.';
        _carregando = false;
      });
    }
  }

  List<api.Alerta> _aplicarFiltro(List<api.Alerta> lista, String termo) {
    if (termo.isEmpty) return lista;
    return lista.where((a) {
      return a.descricao.toLowerCase().contains(termo) ||
          a.equipamento.nome.toLowerCase().contains(termo);
    }).toList();
  }

  void _filtrarAlertas(String termo) {
    setState(() {
      _termoPesquisa = termo.toLowerCase();
      alertasFiltrados = _aplicarFiltro(alertas, _termoPesquisa);
    });
  }

  String _labelNivel(String nivel) {
    switch (nivel) {
      case 'critico':
        return 'Crítico';
      case 'medio':
        return 'Médio';
      default:
        return 'Razoável';
    }
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _abrirDetalhe(api.Alerta alerta) async {
    final atualizou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AlertDetailPage(alertaId: alerta.id)),
    );
    if (atualizou == true) _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.panel,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: _mostrandoCampoPesquisa
            ? TextField(
                autofocus: true,
                onChanged: _filtrarAlertas,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                cursorColor: AppColors.accent,
                decoration: const InputDecoration(
                  hintText: "Pesquisar alertas...",
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppColors.textSecondary),
                ),
              )
            : const Text("Alertas", style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
        leading: const ExitButton(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _mostrandoCampoPesquisa = !_mostrandoCampoPesquisa;
                if (!_mostrandoCampoPesquisa) {
                  alertasFiltrados = alertas;
                  _termoPesquisa = "";
                }
              });
            },
            icon: Icon(_mostrandoCampoPesquisa ? Icons.close : Icons.search),
            color: AppColors.textPrimary,
            iconSize: 26,
          ),
        ],
      ),
      body: _corpo(),
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
    if (alertasFiltrados.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum alerta encontrado",
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _carregar,
      color: AppColors.accent,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: alertasFiltrados.length,
        itemBuilder: (context, index) {
          final alerta = alertasFiltrados[index];
          final cor = AppColors.nivelAlerta(alerta.nivel);
          final lido = alerta.lidoEm != null;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: lido ? AppColors.panelBorder : cor.withOpacity(0.5),
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: lido ? Colors.transparent : cor,
                  shape: BoxShape.circle,
                  border: lido ? Border.all(color: AppColors.panelBorder) : null,
                ),
              ),
              title: Text(
                alerta.equipamento.nome,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(alerta.descricao, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: cor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _labelNivel(alerta.nivel),
                          style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          api.StatusAlerta.rotulo(alerta.status),
                          style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Text(
                _formatarHora(alerta.criadoEm),
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              onTap: () => _abrirDetalhe(alerta),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
