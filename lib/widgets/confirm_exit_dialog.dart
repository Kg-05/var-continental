import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/session_store.dart';

/// Mostra o diálogo de confirmação de saída e, se confirmado, navega
/// para o login. Antes estava copiado em 3 ecrãs diferentes.
Future<void> confirmarSaida(BuildContext context) async {
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.panel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Sair do sistema', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Tem certeza que deseja sair do sistema?',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Sim, sair',
            style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  if (confirm == true && context.mounted) {
    SessionStore.clear();
    Navigator.of(context).pushReplacementNamed('/LoginPage');
  }
}

/// Botão de saída consistente, usado no cabeçalho dos ecrãs principais.
class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => confirmarSaida(context),
      icon: const Icon(Icons.exit_to_app),
      color: AppColors.danger,
      iconSize: 28,
    );
  }
}
