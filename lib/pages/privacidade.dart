import 'package:flutter/material.dart';

class Privacidade extends StatelessWidget {
  const Privacidade({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 👈 duas abas
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Informações"),
          backgroundColor: const Color(0xFF003366),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Política"),
              Tab(text: "Sobre Nós"),
            ],
          ),
        ),
        body:
        
         const TabBarView(
          children: [
            // ✅ Aba Política de Privacidade & Termos
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Política de Privacidade",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A KG Kituxi Tech garante a proteção dos dados pessoais dos utilizadores da aplicação VAR. "
                    "Os dados recolhidos são utilizados para gerir o acesso, prevenir uso indevido e enviar informações relevantes. "
                    "Todos os dados são essenciais para o funcionamento da aplicação, sendo conservados apenas durante o período de uso "
                    "ou conforme exigido por lei. O utilizador tem direito de acesso, correção e eliminação dos seus dados.",
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Termos e Condições",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sobre Nós",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A KG Kituxi Tech é uma empresa angolana de base tecnológica que atua com inteligência artificial, "
                    "monitoramento e automação. Inspirada pelo nome 'Kituxi', que significa rapidez em Kimbundu, "
                    "tem como objetivo oferecer soluções modernas e eficientes para Angola e África.",
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Missão",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Fornecer soluções inteligentes que promovam segurança, eficiência e transformação digital.",
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Visão",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Ser referência em inovação tecnológica em Angola e África, com soluções sustentáveis e de impacto positivo.",
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Valores",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("• Inovação\n• Rapidez\n• Transparência\n• Impacto Social\n• Colaboração"),
                  SizedBox(height: 16),
                  Text(
                    "Contactos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("📍 Talatona, Luanda – Angola\n📞 +244 925 680 514\n📧 kituxigroup2024@gmail.com\n🆔 NIF: 5002497344"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
