// lib/services/som_service.dart
// Toca o som/vibração de alerta enquanto a app está aberta, usando apenas
// APIs nativas do Flutter (sem plugins extra). Um "ringtone" completo — que
// toca mesmo com a app fechada — depende de notificações push (Firebase),
// ainda por integrar; isto cobre o caso de a app estar em uso.
import 'package:flutter/services.dart';
import 'preferencias_service.dart';

class SomService {
  SomService._();

  static Future<void> tocarAlerta() async {
    if (!await PreferenciasAlerta.receberAlertas()) return;

    switch (await PreferenciasAlerta.somAlerta()) {
      case SomAlerta.padrao:
        await SystemSound.play(SystemSoundType.click);
        await HapticFeedback.mediumImpact();
        break;
      case SomAlerta.vibrar:
        await HapticFeedback.vibrate();
        break;
      case SomAlerta.silencioso:
        break;
    }
  }
}
