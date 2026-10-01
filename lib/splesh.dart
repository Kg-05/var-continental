import 'dart:math';
import 'package:flutter/material.dart';
import 'package:var_continental/pages/login.dart';
import 'package:var_continental/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Anel de pontos a "processar" à volta do logo — gira continuamente
  // enquanto a sessão é preparada, sem estar ligado a nenhum progresso real.
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // ⏳ depois de 3s vai para a LoginPage com transição suave
    Future.delayed(const Duration(seconds: 5), () {
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
    _controller.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _dotsController,
                  builder: (context, _) => _DotRing(animationValue: _dotsController.value),
                ),
                ClipOval(
                  child: Image.asset(
                    "assets/images/var_2.png",
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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
