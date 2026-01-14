// --- FILE: lib/view/detail_product.dart ---
import 'package:flutter/material.dart';
import '../model/model_product.dart';
import '../api/api_service.dart';
import 'review_page.dart';
import 'cart_page.dart';
import 'product_form_page.dart';

class DetailProductPage extends StatefulWidget {
  final ModelProduct product;
  const DetailProductPage({super.key, required this.product});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final ApiService apiService = ApiService();

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  late ModelProduct currentProduct;
  double averageRating = 0.0;
  int reviewCount = 0;

  @override
  void initState() {
    super.initState();
    currentProduct = widget.product;
    _loadReviews();
  }

  void _loadReviews() async {
    final reviews = await apiService.getReviewsByProductId(currentProduct.id ?? 0);
    if (reviews.isNotEmpty) {
      double total = reviews.fold(0, (sum, r) => sum + r.rating);
      if (mounted) {
        setState(() {
          averageRating = total / reviews.length;
          reviewCount = reviews.length;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          averageRating = 0.0;
          reviewCount = 0;
        });
      }
    }
  }

  void _addToCart(int quantity) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: const Text('Menambahkan ke keranjang...'),
          backgroundColor: goldMain,
          duration: const Duration(milliseconds: 500)),
    );

    bool success = await apiService.addItemToCart(currentProduct, quantity);

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currentProduct.name} berhasil ditambahkan'),
            backgroundColor: goldDark,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan ke keranjang'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _showAddToCartDialog() {
    final TextEditingController qtyController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: whitePure,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Jumlah Pesanan', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Kuantitas',
            labelStyle: TextStyle(color: goldMain),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: goldMain, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: goldMain.withOpacity(0.5)),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldMain,
              foregroundColor: whitePure,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              shadowColor: goldMain.withOpacity(0.5),
            ),
            onPressed: () {
              int qty = int.tryParse(qtyController.text) ?? 1;
              Navigator.pop(ctx);
              _addToCart(qty);
            },
            child: const Text('TAMBAH', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: currentProduct),
      ),
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < fullStars) return const Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 30);
        if (index == fullStars && halfStar) return const Icon(Icons.star_half_rounded, color: Color(0xFFD4AF37), size: 30);
        return Icon(Icons.star_border_rounded, color: Colors.grey[400], size: 30);
      }),
    );
  }

  void _openReviewPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
            productId: currentProduct.id ?? 0,
            productName: currentProduct.name
        ),
      ),
    );
    _loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Detail Produk', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit_note_rounded, size: 28), onPressed: _editProduct),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 24),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CartPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // HEADER ICON GOLD STYLE
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: whitePure,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldMain.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(color: goldMain.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 10))
                  ]
              ),
              child: Icon(Icons.redeem_rounded, size: 85, color: goldMain),
            ),
            const SizedBox(height: 30),

            // CARD INFORMASI PRODUK
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: whitePure,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: goldMain.withOpacity(0.1), width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))
                  ]
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      currentProduct.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: goldDark, letterSpacing: 0.5)
                  ),
                  const SizedBox(height: 12),
                  Text(
                      "Rp ${currentProduct.price}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: goldMain)
                  ),
                  const SizedBox(height: 25),

                  // Rating Section
                  _buildRatingStars(averageRating),
                  const SizedBox(height: 10),
                  Text(
                    reviewCount > 0
                        ? "${averageRating.toStringAsFixed(1)} / 5.0 ($reviewCount ulasan)"
                        : "Belum ada ulasan",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 25),
                  Divider(color: goldBg, thickness: 3),
                  const SizedBox(height: 25),

                  // Deskripsi
                  Text("Tentang Produk", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: goldDark)),
                  const SizedBox(height: 14),
                  Text(
                      currentProduct.description,
                      style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[700], letterSpacing: 0.2)
                  ),
                  const SizedBox(height: 35),

                  // TOMBOL AKSI
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                          label: const Text("ULASAN"),
                          onPressed: _openReviewPage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: goldDark,
                            side: BorderSide(color: goldMain, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text("BELI"),
                          onPressed: _showAddToCartDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldMain,
                            foregroundColor: whitePure,
                            elevation: 8,
                            shadowColor: goldMain.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}