// --- FILE: lib/view/product_list_screen.dart ---
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../model/model_product.dart';
import 'cart_page.dart';
import 'detail_product.dart';
import 'user_list_page.dart';
import 'product_form_page.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ModelProduct>> futureProducts;
  final ApiService apiService = ApiService();

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureProducts = apiService.getProducts();
    });
  }

  void _deleteData(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: whitePure,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text('Hapus Produk?', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)),
        content: const Text('Data akan dihapus permanen dari katalog.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      bool success = await apiService.deleteProduct(id);
      if (success) {
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Produk berhasil dihapus'), backgroundColor: goldDark),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus produk'), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  void addToCart(ModelProduct product, int quantity) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Menambahkan ke keranjang...'),
        backgroundColor: goldMain,
        duration: const Duration(milliseconds: 500),
      ),
    );
    try {
      bool success = await apiService.addItemToCart(product, quantity);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} (x$quantity) berhasil ditambahkan'),
            backgroundColor: goldDark,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan item.'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void showAddToCartDialog(ModelProduct product) {
    final TextEditingController qtyController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whitePure,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text('Beli ${product.name}', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Jumlah',
            labelStyle: TextStyle(color: goldMain),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: goldMain, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldMain,
              foregroundColor: whitePure,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              int qty = int.tryParse(qtyController.text) ?? 1;
              Navigator.pop(context);
              addToCart(product, qty);
            },
            child: const Text('Tambahkan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Katalog Produk', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserListPage())),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: goldMain,
        elevation: 6,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
        onPressed: () async {
          bool? refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductFormPage()));
          if (refresh == true) _loadData();
        },
      ),
      body: RefreshIndicator(
        color: goldMain,
        onRefresh: _loadData,
        child: FutureBuilder<List<ModelProduct>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: goldMain));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada produk tersedia.', style: TextStyle(color: goldDark, fontSize: 16)));
            }

            final products = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: whitePure,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: goldMain.withOpacity(0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                    border: Border.all(color: goldMain.withOpacity(0.1), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGE PLACEHOLDER GOLD
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [goldMain.withOpacity(0.2), goldBg],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: goldMain.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.inventory_2_outlined, size: 50, color: goldMain),
                        ),
                        const SizedBox(width: 16),
                        // CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: goldDark),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.edit_outlined, color: Colors.orange, size: 22),
                                        onPressed: () async {
                                          bool? refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductFormPage(product: p)));
                                          if (refresh == true) _loadData();
                                        },
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                                        onPressed: () => _deleteData(p.id ?? 0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(p.description, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              Text('Rp ${p.price}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: goldMain)),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(product: p)));
                                        _loadData();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: goldDark,
                                        side: BorderSide(color: goldMain, width: 1.5),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => showAddToCartDialog(p),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: goldMain,
                                        foregroundColor: whitePure,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text('Beli', style: TextStyle(fontWeight: FontWeight.bold)),
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
              },
            );
          },
        ),
      ),
    );
  }
}