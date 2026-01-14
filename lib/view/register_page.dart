// --- FILE: lib/view/register_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService apiService = ApiService();
  bool _isLoading = false;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      ModelUser newUser = ModelUser(
        id: 0,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: 'customer',
      );

      try {
        ModelUser? createdUser = await apiService.addUser(newUser);

        if (mounted) setState(() => _isLoading = false);

        if (createdUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Registrasi Berhasil!'), backgroundColor: goldDark),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email sudah terdaftar! Gunakan email lain.'), backgroundColor: Colors.orange),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Koneksi Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("Tutup", style: TextStyle(color: goldMain, fontWeight: FontWeight.bold))
                ),
              ],
            ),
          );
        }
      }
    }
  }

  // Dekorasi Input Premium Gold
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: goldDark, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: goldMain),
      filled: true,
      fillColor: goldBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: goldMain.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: goldMain, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Daftar Akun Baru', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // HEADER ICON GOLD STYLE
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: whitePure,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldMain.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(color: goldMain.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 10))
                  ],
                ),
                child: Icon(Icons.person_add_alt_1_rounded, size: 65, color: goldMain),
              ),
              const SizedBox(height: 35),

              // CONTAINER CARD FORM MEWAH
              Container(
                decoration: BoxDecoration(
                  color: whitePure,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Buat Akun",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: goldDark),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Silakan lengkapi data diri Anda",
                          style: TextStyle(color: Colors.grey[600], fontSize: 15),
                        ),
                        const SizedBox(height: 35),

                        // INPUT NAMA
                        TextFormField(
                          controller: _nameController,
                          decoration: _buildInputDecoration('Nama Lengkap', Icons.person_outline_rounded),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 20),

                        // INPUT EMAIL
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildInputDecoration('Email', Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          validator: (v) => !v!.contains('@') ? 'Masukkan email yang valid' : null,
                        ),
                        const SizedBox(height: 35),

                        // TOMBOL DAFTAR PREMIUM
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldMain,
                              foregroundColor: whitePure,
                              elevation: 8,
                              shadowColor: goldMain.withOpacity(0.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                                : const Text(
                                "DAFTAR SEKARANG",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // LINK KEMBALI KE LOGIN
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(color: goldDark, fontSize: 15),
                    children: [
                      TextSpan(
                        text: "Login di sini",
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