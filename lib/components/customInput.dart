import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomInput extends StatefulWidget {
  final Icon suffixIcon;
  final bool visibility;
  final String text;
  final bool obscureText; // 🔥 define se é senha
  final TextEditingController controller;

  const CustomInput({
    super.key,
    required this.suffixIcon,
    required this.visibility,
    required this.text,
    required this.controller,
    this.obscureText = false, // por padrão não é senha
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // inicia com o valor recebido
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.visibility,
      obscureText: _obscureText, // 🔥 controla se mostra ou não
      style: const TextStyle(color: AppColors.textPrimary),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: IconTheme(
          data: const IconThemeData(color: AppColors.textSecondary),
          child: widget.suffixIcon,
        ),

        // 🔥 se for senha → mostra botão de visibilidade
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,

        hintText: widget.text,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
