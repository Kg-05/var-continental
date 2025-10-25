import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 importa para usar SystemNavigator
import '../components/customInput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final String codigoCorreto = "12345";
  final String senhaCorreta = "var2025";

  bool _isLoading = false;

  void _login() async {
  String codigo = codigoController.text.trim();
  String senha = senhaController.text.trim();

  if (codigo.isEmpty || senha.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Preencha todos os campos!"),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);
  await Future.delayed(const Duration(seconds: 2));
  setState(() => _isLoading = false);

  if (codigo == codigoCorreto && senha == senhaCorreta) {
    Navigator.of(context).pushReplacementNamed("/shell"); // 🔥 não volta mais

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("👋 Bem-vindo ao sistema!"),
          backgroundColor: Colors.blueAccent,
          duration: Duration(seconds: 3),
        ),
      );
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Código ou senha incorretos!"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return WillPopScope(
      // 🔥 intercepta o botão "voltar" do Android
      onWillPop: () async {
        SystemNavigator.pop(); // fecha o app
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF00B0FF),
                Color(0xFF00C853),
              ],
            ),
          ),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  child: Image.asset("assets/images/var.png"),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.07,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.01,
                  ),
                  child: customInput(
                    controller: codigoController,
                    suffixIcon: const Icon(Icons.edit),
                    visibility: true,
                    text: "Digite seu código",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.01,
                  ),
                  child: customInput(
                    controller: senhaController,
                    suffixIcon: const Icon(Icons.lock),
                    visibility: false,
                    text: "Digite a sua senha",
                    obscureText: true,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.3,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Acessar",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
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
