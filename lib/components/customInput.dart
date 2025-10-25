import 'package:flutter/material.dart';

class customInput extends StatefulWidget {
  final Icon suffixIcon;
  final bool visibility;
  final String text;
  final bool obscureText; // 🔥 define se é senha
  final TextEditingController controller;

  const customInput({
    super.key,
    required this.suffixIcon,
    required this.visibility,
    required this.text,
    required this.controller,
    this.obscureText = false, // por padrão não é senha
  });

  @override
  State<customInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<customInput> {
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(216, 216, 216, 1),
        prefixIcon: widget.suffixIcon,

        // 🔥 se for senha → mostra botão de visibilidade
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
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
          color: Colors.black54,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
