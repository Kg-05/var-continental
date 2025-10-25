import 'package:flutter/material.dart';

class Editarperfil extends StatelessWidget {
  const Editarperfil({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        backgroundColor: const Color(0xFF0D3F86),
        toolbarHeight: 80,
        
        title: const Text("Editar Perfil"),
        centerTitle: true,

        // Botão voltar (sempre volta para a tela anterior)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

       
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
           _buildSection([
           
            
            _buildTile(
             
              title: "Nome do Utilizador",
              subtitle: "Editar o nome",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                  onTap: (){
                    Navigator.of(context).pushNamed("/Editutilizador");
                  },
                  
            ),
            const Divider(color: Color.fromRGBO(98, 154, 183, 1)),
            _buildTile(
              
              title: "Email",
              subtitle: "Editar email",
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
                  onTap: () {
                    Navigator.of(context).pushNamed("/Emailutilizador");
                  },
            ),
          ]),
        ],
      ),
    );
  }
}
  /// Construção de cada bloco (parecido com card agrupado)
  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF183A5B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  /// Cada item dentro da seção
  Widget _buildTile({
   
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: trailing,
      onTap: onTap,
    );
  }