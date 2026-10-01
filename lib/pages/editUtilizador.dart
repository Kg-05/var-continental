import 'package:flutter/material.dart';
import '../services/session_store.dart';
import '../services/usuario_service.dart';
import '../services/api_client.dart';
import '../models/usuario.dart';

class Editutilizador extends StatefulWidget {
  const Editutilizador({super.key});

  @override
  State<Editutilizador> createState() => _EditutilizadorState();
}

class _EditutilizadorState extends State<Editutilizador> {
  late final TextEditingController _nomeController;
  bool _salvando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: SessionStore.usuario?.nome ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final novoNome = _nomeController.text.trim();
    final usuario = SessionStore.usuario;
    if (novoNome.isEmpty || usuario == null) return;

    setState(() {
      _salvando = true;
      _erro = null;
    });
    try {
      final nomeAtualizado = await UsuarioService.atualizarNome(usuario.id, novoNome);
      SessionStore.usuario = Usuario(
        id: usuario.id,
        nome: nomeAtualizado,
        email: usuario.email,
        papel: usuario.papel,
        empresaId: usuario.empresaId,
        funcionario: usuario.funcionario,
        avatarUrl: usuario.avatarUrl,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome atualizado.')),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = 'Não foi possível atualizar o nome.');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002855), // azul escuro do fundo
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3F86),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Nome do Utilizador",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nome",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Digite o novo nome",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF002D6F), // cor da caixa de input
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            if (_erro != null) ...[
              const SizedBox(height: 10),
              Text(_erro!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
            ],
            const SizedBox(height: 10),
            const Text(
              "Depois desta alteração, só poderás voltar a atualizar o nome depois de 30 dias.",
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
              child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // azul do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: _salvando ? null : _confirmar,
                child: _salvando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        "Confirmar Alteração",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
              )
          ],
        ),
      ),
    );
  }
}
