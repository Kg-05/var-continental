import 'dart:math';
import 'package:flutter/material.dart';
import 'package:var_continental/pages/login.dart';
import 'package:var_continental/theme/app_colors.dart';

// Tamanhos do logo nas duas fases e durações de cada etapa — tudo num só
// sítio para ser fácil de afinar sem caçar números pelo ficheiro todo.
const double _tamanhoLogoInicial = 190;
const double _tamanhoLogoReduzido = 140;
const Duration _duracaoEntrada = Duration(milliseconds: 400);
// Tempo extra parado só com o logo, depois do fade-in — entrada + espera
// = 1.8s com o logo sozinho no ecrã, como pedido.
const Duration _duracaoEspera = Duration(milliseconds: 1400);
const Duration _duracaoReducao = Duration(milliseconds: 500);
const Duration _duracaoComPontos = Duration(milliseconds: 2500);

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  // Fase 1: logo a aparecer (fade + scale-in), sozinho, sem pontos.
  late final AnimationController _entradaController;
  late final Animation<double> _entrada;

  // Fase 2: logo reduz de tamanho enquanto o anel de pontos aparece —
  // as duas coisas ligadas ao mesmo controlador para ficarem sincronizadas.
  late final AnimationController _reducaoController;
  late final Animation<double> _tamanhoLogo;

  // Fase 3: anel de pontos "a processar", em loop contínuo.
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _entradaController = AnimationController(vsync: this, duration: _duracaoEntrada);
    _entrada = CurvedAnimation(parent: _entradaController, curve: Curves.easeOut);

    _reducaoController = AnimationController(vsync: this, duration: _duracaoReducao);
    _tamanhoLogo = Tween<double>(begin: _tamanhoLogoInicial, end: _tamanhoLogoReduzido)
        .animate(CurvedAnimation(parent: _reducaoController, curve: Curves.easeInOut));

    _dotsController = AnimationController(vsync: this, duration: _duracaoComPontos);

    _entradaController.forward().whenComplete(() {
      if (!mounted) return;
      Future.delayed(_duracaoEspera, () {
        if (!mounted) return;
        _reducaoController.forward().whenComplete(() {
          if (!mounted) return;
          _dotsController.repeat();
        });
      });
    });

    final duracaoTotal = _duracaoEntrada + _duracaoEspera + _duracaoReducao + _duracaoComPontos;
    Future.delayed(duracaoTotal, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _reducaoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _entrada,
          child: ScaleTransition(
            scale: _entrada,
            child: SizedBox(
              width: 260,
              height: 260,
              child: AnimatedBuilder(
                animation: Listenable.merge([_reducaoController, _dotsController]),
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // O anel só aparece a partir da fase de redução —
                      // a opacidade acompanha o mesmo progresso do encolher
                      // do logo, para a transição ser uma coisa só.
                      Opacity(
                        opacity: _reducaoController.value,
                        child: _DotRing(animationValue: _dotsController.value),
                      ),
                      ClipOval(
                        child: Image.asset(
                          "assets/images/var_2.png",
                          width: _tamanhoLogo.value,
                          height: _tamanhoLogo.value,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pontos dispostos em círculo à volta do logo, cada um a acender e
/// apagar em sequência (efeito "a processar") conforme [animationValue]
/// (0..1, repete em loop).
class _DotRing extends StatelessWidget {
  final double animationValue;
  final int dotCount;
  final double radius;
  final double dotSize;

  const _DotRing({
    required this.animationValue,
    this.dotCount = 12,
    this.radius = 110,
    this.dotSize = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(dotCount, (i) {
        final angulo = 2 * pi * i / dotCount;
        final dx = radius * cos(angulo);
        final dy = radius * sin(angulo);

        // Fase individual de cada ponto — cria o efeito de "perseguição"
        // em volta do anel em vez de piscarem todos ao mesmo tempo.
        final fase = (animationValue - i / dotCount) % 1.0;
        final opacidade = (1.0 - fase).clamp(0.15, 1.0);

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(
            opacity: opacidade,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
