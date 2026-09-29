import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Privacidade extends StatelessWidget {
  const Privacidade({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 👈 duas abas
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Informações", style: TextStyle(color: AppColors.textPrimary)),
          backgroundColor: AppColors.panel,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: "Política"),
              Tab(text: "Sobre Nós"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ✅ Aba Política de Privacidade & Termos
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titulo("Política de Privacidade"),
                  const SizedBox(height: 8),
                  _paragrafo(
                    "A KG Kituxi Tech garante a proteção dos dados pessoais dos utilizadores da aplicação VAR. "
                    "Os dados recolhidos são utilizados para gerir o acesso, prevenir uso indevido e enviar informações relevantes. "
                    "Todos os dados são essenciais para o funcionamento da aplicação, sendo conservados apenas durante o período de uso "
                    "ou conforme exigido por lei. O utilizador tem direito de acesso, correção e eliminação dos seus dados.",
                  ),
                  const SizedBox(height: 16),
                  _titulo("Termos e Condições"),
                  const SizedBox(height: 8),
                  _paragrafo(
                    "A aplicação VAR é uma solução de monitoramento desenvolvida pela KG Kituxi Tech. "
                    "O acesso requer contrato com a empresa e a autenticação é feita via PIN. "
                    "O utilizador é responsável por manter a confidencialidade das suas credenciais. "
                    "Qualquer uso indevido ou transmissão dessas informações é de sua responsabilidade.",
                  ),
                ],
              ),
            ),

            // ✅ Aba Sobre Nós
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titulo("Sobre Nós"),
                  const SizedBox(height: 8),
                  _paragrafo(
                    "A KG Kituxi Tech é uma empresa angolana de base tecnológica que atua com inteligência artificial, "
                    "monitoramento e automação. Inspirada pelo nome 'Kituxi', que significa rapidez em Kimbundu, "
                    "tem como objetivo oferecer soluções modernas e eficientes para Angola e África.",
                  ),
                  const SizedBox(height: 16),
                  _subtitulo("Missão"),
                  _paragrafo("Fornecer soluções inteligentes que promovam segurança, eficiência e transformação digital."),
                  const SizedBox(height: 16),
                  _subtitulo("Visão"),
                  _paragrafo("Ser referência em inovação tecnológica em Angola e África, com soluções sustentáveis e de impacto positivo."),
                  const SizedBox(height: 16),
                  _subtitulo("Valores"),
                  _paragrafo("• Inovação\n• Rapidez\n• Transparência\n• Impacto Social\n• Colaboração"),
                  const SizedBox(height: 16),
                  _subtitulo("Contactos"),
                  _paragrafo("📍 Talatona, Luanda – Angola\n📞 +244 925 680 514\n📧 kituxigroup2024@gmail.com\n🆔 NIF: 5002497344"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) => Text(
        texto,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      );

  Widget _subtitulo(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      );

  Widget _paragrafo(String texto) => Text(
        texto,
        style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
      );
}
