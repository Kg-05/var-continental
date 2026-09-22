import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';

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
  final List<AlertaMock> alertas = const [
    AlertaMock(
      descricao: "A IA detectou uma falha no Equipamento 32",
      nivel: "critico",
      equipamento: "Gerador Portuário GP-07",
      criadoEm: "12:30",
    ),
    AlertaMock(
      descricao: "Necessária manutenção preventiva no Setor 5",
      nivel: "medio",
      equipamento: "Esteira de Contentores EC-02",
      criadoEm: "Ontem",
    ),
    AlertaMock(
      descricao: "Novo firmware disponível para o equipamento",
      nivel: "razoavel",
      equipamento: "Sistema de Pesagem SP-03",
      criadoEm: "08:00",
      lido: true,
    ),
    AlertaMock(
      descricao: "O sensor de temperatura foi desligado",
      nivel: "medio",
      equipamento: "Compressor Industrial CI-08",
      criadoEm: "09:15",
    ),
    AlertaMock(
      descricao: "Acesso não autorizado detectado na área restrita",
      nivel: "critico",
      equipamento: "Cofre Eletrónico CE-01",
      criadoEm: "07:45",
    ),
    AlertaMock(
      descricao: "O equipamento voltou a funcionar normalmente",
      nivel: "razoavel",
      equipamento: "Empilhadeira Industrial EI-04",
      criadoEm: "Anteontem",
      lido: true,
    ),
    AlertaMock(
      descricao: "Perda de comunicação com o servidor central",
      nivel: "critico",
      equipamento: "Servidor Core SRV-03",
      criadoEm: "13:20",
    ),
    AlertaMock(
      descricao: "O tanque de armazenamento atingiu 95% da capacidade",
      nivel: "medio",
      equipamento: "Tanque de Armazenamento TQ-15",
      criadoEm: "14:00",
    ),
  ];

  List<AlertaMock> alertasFiltrados = [];
  bool _mostrandoCampoPesquisa = false;
  String _termoPesquisa = "";

  @override
  void initState() {
    super.initState();
    alertasFiltrados = alertas;
  }

  void _filtrarAlertas(String termo) {
    setState(() {
      _termoPesquisa = termo.toLowerCase();
      alertasFiltrados = alertas.where((a) {
        return a.descricao.toLowerCase().contains(_termoPesquisa) ||
            a.equipamento.toLowerCase().contains(_termoPesquisa);
      }).toList();
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
      body: alertasFiltrados.isEmpty
          ? const Center(
              child: Text(
                "Nenhum alerta encontrado",
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: alertasFiltrados.length,
              itemBuilder: (context, index) {
                final alerta = alertasFiltrados[index];
                final cor = AppColors.nivelAlerta(alerta.nivel);
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: alerta.lido ? AppColors.panelBorder : cor.withOpacity(0.5),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: alerta.lido ? Colors.transparent : cor,
                        shape: BoxShape.circle,
                        border: alerta.lido ? Border.all(color: AppColors.panelBorder) : null,
                      ),
                    ),
                    title: Text(
                      alerta.equipamento,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(alerta.descricao, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
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
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      alerta.criadoEm,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    onTap: () {
                      // TODO: abrir detalhe do alerta quando o app for integrado com a API
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
    );
  }
}
