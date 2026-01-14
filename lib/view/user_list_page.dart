// --- FILE: lib/view/user_list_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_user.dart';
import 'add_user_page.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService apiService = ApiService();
  late Future<List<ModelUser>> futureUsers;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      futureUsers = apiService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg, // BACKGROUND GOLD PREMIUM
      appBar: AppBar(
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserPage()),
          );

          if (result == true) {
            _loadUsers();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("User berhasil ditambahkan"),
                    backgroundColor: goldDark,
                  )
              );
            }
          }
        },
        label: const Text('Tambah User', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        icon: const Icon(Icons.person_add_rounded),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        elevation: 6,
      ),
      body: FutureBuilder<List<ModelUser>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: goldMain));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)
                )
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off_rounded, size: 80, color: goldMain.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  Text('Tidak ada data pengguna.', style: TextStyle(color: goldDark, fontSize: 16)),
                ],
              ),
            );
          }

          final users = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: whitePure,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: goldMain.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: goldMain.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: goldMain.withOpacity(0.5), width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: goldBg,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: goldMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                      user.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: goldDark, fontSize: 17)
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: goldMain.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ROLE: ${user.role.toUpperCase()}',
                            style: TextStyle(color: goldDark, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: goldBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.chevron_right_rounded, color: goldMain, size: 30),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetailPage(userId: user.id!))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}