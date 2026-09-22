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
import 'package:var_continental/shell.dart';
import 'package:var_continental/splesh.dart';
import 'pages/login.dart'; // Adicione esta importação

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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