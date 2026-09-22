import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_exit_dialog.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final List<Map<String, String>> notificacoes = [
    {
      "titulo": "Material Identificado!",
      "mensagem": "A IA detectou uma falha no Equipamento 32",
      "data": "12:30"
    },
    {
      "titulo": "Aviso Urgente",
      "mensagem": "Necessária manutenção preventiva no Setor 5",
      "data": "Ontem"
    },
    {
      "titulo": "Atualização",
      "mensagem": "Novo firmware disponível para o Equipamento 10",
      "data": "08:00"
    },
    {
      "titulo": "Sensor Desativado",
      "mensagem": "O sensor de temperatura do Setor 3 foi desligado",
      "data": "09:15"
    },
    {
      "titulo": "Alerta de Segurança",
      "mensagem": "Acesso não autorizado detectado na área restrita",
      "data": "07:45"
    },
    {
      "titulo": "Manutenção Concluída",
      "mensagem": "O Equipamento 21 voltou a funcionar normalmente",
      "data": "Anteontem"
    },
    {
      "titulo": "Falha de Conexão",
      "mensagem": "Perda de comunicação com o servidor central",
      "data": "13:20"
    },
    {
      "titulo": "Capacidade Máxima",
      "mensagem": "O tanque de armazenamento atingiu 95% da capacidade",
      "data": "14:00"
    },
    {
      "titulo": "Energia Restabelecida",
      "mensagem": "A energia elétrica foi restabelecida no Setor 8",
      "data": "Hoje"
    },
    {
      "titulo": "Nova Tarefa",
      "mensagem": "Você recebeu uma nova ordem de serviço para verificar cabos",
      "data": "Ontem, 18:45"
    },
  ];

  List<Map<String, String>> notificacoesFiltradas = [];
  bool _mostrandoCampoPesquisa = false;
  String _termoPesquisa = "";

  @override
  void initState() {
    super.initState();
    notificacoesFiltradas = notificacoes;
  }

  void _filtrarNotificacoes(String termo) {
    setState(() {
      _termoPesquisa = termo.toLowerCase();
      notificacoesFiltradas = notificacoes.where((notificacao) {
        final titulo = notificacao["titulo"]!.toLowerCase();
        final mensagem = notificacao["mensagem"]!.toLowerCase();
        final data = notificacao["data"]!.toLowerCase();

        return titulo.contains(_termoPesquisa) ||
            mensagem.contains(_termoPesquisa) ||
            data.contains(_termoPesquisa);
      }).toList();
    });
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
                onChanged: _filtrarNotificacoes,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                cursorColor: AppColors.accent,
                decoration: const InputDecoration(
                  hintText: "Pesquisar notificações...",
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
                  notificacoesFiltradas = notificacoes;
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
      body: notificacoesFiltradas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma notificação encontrada",
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: notificacoesFiltradas.length,
              itemBuilder: (context, index) {
                final notificacao = notificacoesFiltradas[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.panelBorder),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 32,
                    ),
                    title: Text(
                      notificacao["titulo"]!,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      notificacao["mensagem"]!,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Text(
                      notificacao["data"]!,
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
