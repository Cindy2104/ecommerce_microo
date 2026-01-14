// --- FILE: lib/view/login_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_user.dart';
import 'product_list_screen.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  void _handleLogin() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);

    // Cek ke Database PostgreSQL
    ModelUser? user = await _apiService.login(email);

    setState(() => _isLoading = false);

    if (user != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Halo, ${user.name}!"),
              backgroundColor: goldDark
          )
      );

      // Masuk ke Aplikasi Utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductListScreen()),
      );
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Gagal Login"),
          content: const Text("Email tidak ditemukan. Silakan daftar dulu."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: goldMain))
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg, // Background Gold Muda
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ICON LOGO GOLD STYLE
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: whitePure,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldMain.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: goldMain.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Icon(Icons.shopping_basket_rounded, size: 85, color: goldMain),
              ),
              const SizedBox(height: 35),

              // JUDUL APLIKASI
              Text(
                "TUGAS AKHIR",
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                    color: goldMain
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "MICRO SERVICE BY RAHMI",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: goldDark,
                    letterSpacing: 0.5
                ),
              ),
              const SizedBox(height: 45),

              // CARD LOGIN MEWAH
              Container(
                decoration: BoxDecoration(
                  color: whitePure,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(color: goldDark, fontWeight: FontWeight.w500),
                          prefixIcon: Icon(Icons.email_outlined, color: goldMain),
                          filled: true,
                          fillColor: goldBg,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: goldMain.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: goldMain, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldMain,
                            foregroundColor: whitePure,
                            elevation: 8,
                            shadowColor: goldMain.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                              : const Text(
                              "SIGN IN",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // LINK DAFTAR
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: RichText(
                  text: TextSpan(
                    text: "Belum punya akun? ",
                    style: TextStyle(color: goldDark, fontSize: 15),
                    children: [
                      TextSpan(
                        text: "Daftar disini",
                        style: TextStyle(
                          color: goldMain,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}