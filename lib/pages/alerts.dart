import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3F86),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: _mostrandoCampoPesquisa
            ? TextField(
                autofocus: true,
                onChanged: _filtrarNotificacoes,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Pesquisar notificações...",
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white70),
                ),
              )
            : const Text("Notificações"),
        centerTitle: true,
        leading:  IconButton(
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
            iconSize: 30,
          ),
        ],
      ),
      body: notificacoesFiltradas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma notificação encontrada",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: notificacoesFiltradas.length,
              itemBuilder: (context, index) {
                final notificacao = notificacoesFiltradas[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.yellow,
                      size: 50,
                    ),
                    title: Text(
                      notificacao["titulo"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notificacao["mensagem"]!),
                    trailing: Text(
                      notificacao["data"]!,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // Ação ao clicar
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 5),
            ),
    );
  }
}
