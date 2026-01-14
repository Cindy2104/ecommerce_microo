// --- FILE: lib/view/cart_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<ModelCart> futureCart;
  final ApiService apiService = ApiService();

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  void _loadCartData() {
    setState(() {
      futureCart = apiService.getCart();
    });
  }

  void _deleteItem(int id) async {
    try {
      bool success = await apiService.deleteCartItem(id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Item berhasil dihapus'), backgroundColor: goldDark)
          );
        }
        _loadCartData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menghapus item'), backgroundColor: Colors.redAccent)
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg, // Background Gold Muda
      appBar: AppBar(
        title: const Text('Keranjang Saya', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _loadCartData),
        ],
      ),
      body: FutureBuilder<ModelCart>(
        future: futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: goldMain));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold))
            );
          }
          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: goldMain.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  Text('Keranjang masih kosong.',
                      style: TextStyle(fontSize: 18, color: goldDark, fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            );
          }

          final cart = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: whitePure,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: goldMain.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                        border: Border.all(color: goldMain.withOpacity(0.1), width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [goldMain, goldDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: goldMain.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${item.quantity}x',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(fontWeight: FontWeight.bold, color: goldDark, fontSize: 17),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Rp ${item.price}',
                            style: TextStyle(color: goldMain, fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 28),
                          onPressed: () => _deleteItem(item.id),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // TOTAL SECTION LAYOUT DENGAN DESAIN MEWAH
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: whitePure,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    )
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${cart.total}',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: goldDark
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Logika checkout tetap tersedia di sini
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldMain,
                          foregroundColor: whitePure,
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 8,
                          shadowColor: goldMain.withOpacity(0.4),
                        ),
                        child: const Text('CHECKOUT',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.5)
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}