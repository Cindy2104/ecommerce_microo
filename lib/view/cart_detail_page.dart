// --- FILE: lib/view/cart_detail_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_cart.dart';

class CartDetailPage extends StatelessWidget {
  final int itemId;
  const CartDetailPage({super.key, required this.itemId});

  // DEFINISI WARNA GOLD LUXURY
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang (Off-white)
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFFB8860B); // Dark Goldenrod untuk teks/aksen
  final Color whitePure = Colors.white;

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: goldBg, // Background Gold Muda
      appBar: AppBar(
        title: Text('Detail Item #$itemId', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: FutureBuilder<ModelCartItem?>(
        future: apiService.getCartItem(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: goldMain));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: goldDark)));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Item tidak ditemukan.', style: TextStyle(color: goldDark)));
          }

          final item = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // CONTAINER CARD MODERN GOLD STYLE
                Container(
                  decoration: BoxDecoration(
                    color: whitePure,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: goldMain.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ICON BAGIAN ATAS DENGAN LINGKARAN EMAS
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: goldBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: goldMain, width: 2),
                          ),
                          child: Icon(Icons.shopping_bag_outlined, size: 65, color: goldMain),
                        ),
                        const SizedBox(height: 24),
                        // NAMA PRODUK
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: goldDark,
                              letterSpacing: 1.1
                          ),
                        ),
                        const SizedBox(height: 15),
                        Divider(thickness: 1, color: goldMain.withOpacity(0.2)),
                        const SizedBox(height: 15),

                        // INFORMASI HARGA & JUMLAH
                        _buildRow("Harga Satuan", "Rp ${item.price}"),
                        _buildRow("Jumlah Pesanan", "${item.quantity} Unit"),

                        const SizedBox(height: 25),
                        // SUB-TOTAL BOX DENGAN AKSEN EMAS
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [goldMain.withOpacity(0.1), goldBg],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: goldMain.withOpacity(0.3)),
                          ),
                          child: _buildRow(
                              "Subtotal",
                              "Rp ${(item.price * item.quantity)}",
                              isTotal: true
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // TOMBOL KEMBALI TEMA EMAS
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldMain,
                      foregroundColor: whitePure,
                      elevation: 4,
                      shadowColor: goldMain.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('KEMBALI KE KERANJANG',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0)
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isTotal ? goldDark : Colors.grey[700],
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              )
          ),
          Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 24 : 18,
                fontWeight: FontWeight.bold,
                color: isTotal ? goldDark : Colors.black87,
              )
          ),
        ],
      ),
    );
  }
}