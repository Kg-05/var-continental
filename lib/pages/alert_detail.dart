// lib/pages/alert_detail.dart
// Ecrã de detalhe do alerta — dá ao Técnico liberdade para redefinir o
// nível, mudar o estado do tratamento (incluindo pedir apoio à Central)
// e deixar uma nota, tudo via PATCH /alertas/:id.

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/alerta.dart';
import '../services/alerta_service.dart';
import '../services/api_client.dart';

class AlertDetailPage extends StatefulWidget {
  final String alertaId;
  const AlertDetailPage({super.key, required this.alertaId});

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  Alerta? _alerta;
  bool _carregando = true;
  bool _salvando = false;
  String? _erroCarregamento;

  late String _nivelSelecionado;
  late String _statusSelecionado;
  final TextEditingController _notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erroCarregamento = null;
    });
    try {
      final alerta = await AlertaService.buscarPorId(widget.alertaId);
      if (!mounted) return;
      setState(() {
        _alerta = alerta;
        _nivelSelecionado = alerta.nivel;
        _statusSelecionado = alerta.status;
        _notaController.text = alerta.notaTecnico ?? '';
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = e.message;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = 'Não foi possível carregar o alerta.';
        _carregando = false;
      });
    }
  }

  Future<void> _guardar() async {
    final alerta = _alerta;
    if (alerta == null) return;

    setState(() => _salvando = true);
    try {
      final atualizado = await AlertaService.atualizar(
        alerta.id,
        nivel: _nivelSelecionado,
        status: _statusSelecionado,
        notaTecnico: _notaController.text.trim().isEmpty ? null : _notaController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _alerta = atualizado);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alerta atualizado.'), backgroundColor: AppColors.success),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerDark),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível guardar as alterações.'),
          backgroundColor: AppColors.dangerDark,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
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
        title: const Text('Detalhe do alerta', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _erroCarregamento != null
              ? _erro(_erroCarregamento!)
              : _conteudo(_alerta!),
    );
  }

  Widget _erro(String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
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

  Widget _conteudo(Alerta alerta) {
    final cor = AppColors.nivelAlerta(alerta.nivel);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alerta.equipamento.nome,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                if (alerta.equipamento.localizacao != null) ...[
                  const SizedBox(height: 2),
                  Text(alerta.equipamento.localizacao!,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ],
                const SizedBox(height: 10),
                Text(alerta.descricao, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Redefinir nível',
              style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['razoavel', 'medio', 'critico'].map((nivel) {
              final selecionado = _nivelSelecionado == nivel;
              final corNivel = AppColors.nivelAlerta(nivel);
              return ChoiceChip(
                label: Text(_labelNivel(nivel)),
                selected: selecionado,
                onSelected: (_) => setState(() => _nivelSelecionado = nivel),
                backgroundColor: AppColors.inputFill,
                selectedColor: corNivel.withOpacity(0.25),
                labelStyle: TextStyle(color: selecionado ? corNivel : AppColors.textSecondary, fontWeight: FontWeight.w600),
                side: BorderSide(color: selecionado ? corNivel : AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          const Text('Estado do tratamento',
              style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: StatusAlerta.todos.map((status) {
              final selecionado = _statusSelecionado == status;
              return ChoiceChip(
                label: Text(StatusAlerta.rotulo(status)),
                selected: selecionado,
                onSelected: (_) => setState(() => _statusSelecionado = status),
                backgroundColor: AppColors.inputFill,
                selectedColor: AppColors.accent.withOpacity(0.25),
                labelStyle: TextStyle(color: selecionado ? AppColors.accent : AppColors.textSecondary, fontWeight: FontWeight.w600),
                side: BorderSide(color: selecionado ? AppColors.accent : AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Escolhe "A aguardar apoio" para sinalizar à Central que precisas de ajuda para resolver este alerta.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Nota',
              style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _notaController,
              maxLines: 4,
              style: const TextStyle(color: AppColors.textPrimary),
              cursorColor: AppColors.accent,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
                hintText: 'Descreve o que já foi feito ou o que falta para resolver o alerta...',
                hintStyle: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _salvando ? null : _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _salvando
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text('Guardar alterações',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
