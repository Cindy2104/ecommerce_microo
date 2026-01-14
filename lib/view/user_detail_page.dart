// --- FILE: lib/view/user_detail_page.dart ---
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../model/model_user.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ApiService apiService = ApiService();
  late Future<ModelUser> futureUser;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    futureUser = apiService.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Profil Pengguna', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: FutureBuilder<ModelUser>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: goldMain));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Gagal memuat data: ${snapshot.error}',
                    style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)
                )
            );
          }
          if (!snapshot.hasData) {
            return Center(child: Text('User tidak ditemukan.', style: TextStyle(color: goldDark)));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // HEADER AVATAR DENGAN GOLD RING
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: goldMain,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: goldMain.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: whitePure,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: goldBg,
                      child: Icon(Icons.person_rounded, size: 80, color: goldMain),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // CARD INFORMASI PREMIUM
                Container(
                  decoration: BoxDecoration(
                    color: whitePure,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: goldMain.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildDetailItem(Icons.badge_outlined, 'ID Pengguna', user.id.toString()),
                        Divider(color: goldBg, thickness: 2),
                        _buildDetailItem(Icons.person_outline_rounded, 'Nama Lengkap', user.name),
                        Divider(color: goldBg, thickness: 2),
                        _buildDetailItem(Icons.email_outlined, 'Email', user.email),
                        Divider(color: goldBg, thickness: 2),
                        _buildDetailItem(Icons.admin_panel_settings_outlined, 'Role / Jabatan', user.role.toUpperCase()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // TOMBOL KEMBALI GOLD OUTLINE
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: goldDark,
                      side: BorderSide(color: goldMain, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('KEMBALI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [goldMain.withOpacity(0.2), goldMain.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: goldDark, size: 26),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: goldDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}