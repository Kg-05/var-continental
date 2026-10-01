import 'package:flutter/material.dart';
import 'package:var_continental/theme/app_colors.dart';
import 'package:var_continental/pages/definicoes.dart';
import 'package:var_continental/pages/editUtilizador.dart';
import 'package:var_continental/pages/editarPerfil.dart';
import 'package:var_continental/pages/emailUtilizador.dart';
import 'package:var_continental/pages/frequenciaActualizacao.dart';
import 'package:var_continental/pages/linguagem.dart';
import 'package:var_continental/pages/localEquipamento.dart';
import 'package:var_continental/pages/privacidade.dart';
import 'package:var_continental/pages/seguranca.dart';
import 'package:var_continental/pages/somAlerta.dart';
import 'package:var_continental/pages/tipoMaterial.dart';
import 'package:var_continental/services/locale_service.dart';
import 'package:var_continental/shell.dart';
import 'package:var_continental/splesh.dart';
import 'pages/login.dart'; // Adicione esta importação

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Carrega o idioma guardado e reconstrói a app quando o utilizador o
    // trocar em Definições > Idioma — é isto que faz a troca "sentir-se"
    // em toda a app, em vez de só no próprio ecrã de idioma.
    LocaleController.instance.addListener(_aoMudarIdioma);
    LocaleController.instance.carregar();
  }

  @override
  void dispose() {
    LocaleController.instance.removeListener(_aoMudarIdioma);
    super.dispose();
  }

  void _aoMudarIdioma() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.panel,
        ),
      ),
      initialRoute: "/SplashPage",
      routes: {
        "/SplashPage":(context)=> SplashPage(),
        "/LoginPage": (context) => LoginPage(),
        "/shell": (context) => Shell(),
        "/Definicoes": (context) => Definicoes(),
        "/Somalarta":(context) => Somalerta(),
        "/Editarperfil":(context)=> Editarperfil(),
        "/Frequenciaactualizacao":(context)=> Frequenciaactualizacao(),
        "/Tipomaterial":(context)=> Tipomaterial(),
        "/Localequipamento":(context)=> Localequipamento(),
         "/Seguranca":(context)=> Seguranca(),
         "/Linguagem":(context)=>Linguagem(),
         "/Editutilizador":(context)=>Editutilizador(),
         "/Emailutilizador":(context)=>Emailutilizador(),
         "/Privacidade":(context)=>Privacidade(),


        
      }, // Altere para iniciar com LoginPage
    );
  }
}