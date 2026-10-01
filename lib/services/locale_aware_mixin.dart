// lib/services/locale_aware_mixin.dart
// Mistura num State<T> para que o ecrã reconstrua sozinho quando o idioma
// mudar em Definições > Idioma — sem isto, um ecrã já aberto (ex: dentro
// do PageView do Shell) só mostraria o novo idioma depois de reaberto.
import 'package:flutter/widgets.dart';
import 'locale_service.dart';

mixin LocaleAware<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    LocaleController.instance.addListener(_aoMudarIdiomaLocaleAware);
  }

  @override
  void dispose() {
    LocaleController.instance.removeListener(_aoMudarIdiomaLocaleAware);
    super.dispose();
  }

  void _aoMudarIdiomaLocaleAware() {
    if (mounted) setState(() {});
  }
}
