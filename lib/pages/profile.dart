import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======== CABEÇALHO ========
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D3F86), Color(0xFF2A75D2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Ícones de canto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {
                      Navigator.of(context).pushNamed("/Definicoes");
                    }, 
                    icon: Icon(Icons.settings), 
                    color: Colors.white, iconSize: 35,),

                      IconButton(onPressed: () {
                        Navigator.of(context).pushNamed("/Editarperfil");
                      }, 
                    icon: Icon(Icons.edit), 
                    color: Colors.white, iconSize: 35,)
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Foto de perfil
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage("assets/images/var_2.png"),
                  ),
                  const SizedBox(height: 16),

                  // Nome
                  const Text(
                    "Mutombo Pedro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Profissão
                  const Text(
                    "Desenvolvedor Júnior",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ======== INFORMAÇÕES ========
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Nome"),
                    subtitle: Text("Mutombo Pedro"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text("Função"),
                    subtitle: Text("Desenvolvedor Júnior"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text("Email"),
                    subtitle: Text("mtbpedro17@gmail.com"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ======== PREFERÊNCIAS ========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[300],
              child: const Text(
                "Preferência",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  
                   ListTile(
                    leading: Icon(Icons.language),
                    title: Text("Linguagem"),
                    trailing: Text("Português"),
                    onTap: (){
                      Navigator.of(context).pushNamed("/Linguagem");
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text("Informações"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap:() {
                      Navigator.of(context).pushNamed("/Privacidade");
                    } 
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text("Modo escuro"),
                    value: false,
                    onChanged: (v) {},
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications),
                    title: const Text("Notificações"),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
