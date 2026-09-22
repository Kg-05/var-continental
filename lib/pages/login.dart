import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 importa para usar SystemNavigator
import '../components/customInput.dart';
import '../theme/app_colors.dart';

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
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (codigo == codigoCorreto && senha == senhaCorreta) {
      Navigator.of(context).pushReplacementNamed("/shell"); // 🔥 não volta mais

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("👋 Bem-vindo ao sistema!"),
            backgroundColor: AppColors.accent,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código ou senha incorretos!"),
          backgroundColor: AppColors.dangerDark,
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
                AppColors.background,
                AppColors.backgroundGradientEnd,
              ],
            ),
          ),
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: screenWidth * 0.55,
                    height: screenHeight * 0.22,
                    child: Image.asset("assets/images/var.png"),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    "Bem-vindo",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Entra com o teu código de técnico",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.01,
                    ),
                    child: CustomInput(
                      controller: codigoController,
                      suffixIcon: const Icon(Icons.badge_outlined),
                      visibility: true,
                      text: "Digite o teu código",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.01,
                    ),
                    child: CustomInput(
                      controller: senhaController,
                      suffixIcon: const Icon(Icons.lock_outline),
                      visibility: false,
                      text: "Digite a tua senha",
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Entrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
