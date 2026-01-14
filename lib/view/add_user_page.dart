// --- FILE: lib/view/add_user_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_user.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isLoading = false;
  final ApiService apiService = ApiService();

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang (Off-white)
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFFB8860B); // Dark Goldenrod untuk teks/aksen
  final Color whitePure = Colors.white;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      ModelUser newUser = ModelUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _roleController.text.trim(),
      );

      try {
        ModelUser? createdUser = await apiService.addUser(newUser);

        if (mounted) {
          setState(() => _isLoading = false);
        }

        if (createdUser != null) {
          if (mounted) Navigator.pop(context, true);
        } else {
          if (mounted) _showErrorSnackBar('Gagal menambahkan user. Cek data input.');
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showErrorSnackBar('Terjadi kesalahan server: $e');
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  // DEKORASI INPUT DENGAN TEMA GOLD
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: goldDark, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: goldMain),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: goldMain.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: goldMain, width: 2),
      ),
      filled: true,
      fillColor: whitePure,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Tambah User Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          children: [
            // HEADER ICON PREMIUM
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whitePure,
                shape: BoxShape.circle,
                border: Border.all(color: goldMain, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: goldMain.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(Icons.person_add_alt_1_rounded, size: 50, color: goldMain),
            ),
            const SizedBox(height: 15),
            Text(
              "Registrasi User",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: goldDark,
                  letterSpacing: 1.2
              ),
            ),
            const SizedBox(height: 35),

            // FORM CARD
            Container(
              decoration: BoxDecoration(
                color: whitePure,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Nama Lengkap', Icons.badge_outlined),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Nama wajib diisi' : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
                        if (!value.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _roleController,
                      decoration: _inputDecoration('Role (Admin / Customer)', Icons.verified_user_outlined),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Role wajib diisi' : null,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                    const SizedBox(height: 40),

                    // TOMBOL SIMPAN
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldMain,
                          foregroundColor: whitePure,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          shadowColor: goldMain.withOpacity(0.4),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                            : const Text(
                            'DAFTARKAN USER',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}