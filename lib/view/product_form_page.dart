// --- FILE: lib/view/product_form_page.dart ---
import 'package:flutter/material.dart';
import '../model/model_product.dart';
import '../api/api_service.dart';

class ProductFormPage extends StatefulWidget {
  final ModelProduct? product; // Null = Tambah, Ada isi = Edit

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString().replaceAll(RegExp(r'\.0$'), '');
      _descController.text = widget.product!.description;
    }
  }

  Future<void> _submitData() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final productData = ModelProduct(
      id: widget.product?.id,
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descController.text,
    );

    bool success;
    if (widget.product == null) {
      success = await _apiService.addProduct(productData);
    } else {
      success = await _apiService.updateProduct(widget.product!.id!, productData);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Berhasil menyimpan data'), backgroundColor: goldDark),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // Helper Custom Decoration (Tema Gold Premium)
  InputDecoration _buildInputDecoration(String label, IconData icon, {String? prefixText}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: goldDark, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: goldMain),
      prefixText: prefixText,
      prefixStyle: TextStyle(color: goldMain, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: goldMain.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: goldMain, width: 2),
      ),
      filled: true,
      fillColor: whitePure,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.product != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: goldBg,
        appBar: AppBar(
          title: Text(
            isEditing ? 'Edit Produk' : 'Tambah Produk',
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          centerTitle: true,
          backgroundColor: goldMain,
          foregroundColor: whitePure,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Column(
            children: [
              // --- HEADER ICON DENGAN EFEK EMAS ---
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: whitePure,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldMain.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: goldMain.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8)
                    )
                  ],
                ),
                child: Icon(
                  isEditing ? Icons.auto_fix_high_rounded : Icons.add_business_rounded,
                  size: 65,
                  color: goldMain,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                isEditing ? "Perbarui informasi produk" : "Tambahkan produk baru ke toko",
                textAlign: TextAlign.center,
                style: TextStyle(color: goldDark, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
              const SizedBox(height: 35),

              // --- FORM AREA ---
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration('Nama Produk', Icons.shopping_bag_outlined),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      validator: (val) => val!.isEmpty ? 'Nama produk wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _priceController,
                      decoration: _buildInputDecoration('Harga Jual', Icons.payments_outlined, prefixText: 'Rp '),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Harga wajib diisi';
                        if (double.tryParse(val) == null) return 'Harga harus berupa angka';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _descController,
                      decoration: _buildInputDecoration('Deskripsi Produk', Icons.notes_rounded),
                      maxLines: 4,
                      minLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      validator: (val) => val!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 40),

                    // TOMBOL SIMPAN MEWAH
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: _isLoading
                          ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldMain.withOpacity(0.7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                      )
                          : ElevatedButton.icon(
                        onPressed: _submitData,
                        icon: const Icon(Icons.save_rounded, color: Colors.white),
                        label: Text(
                          isEditing ? 'SIMPAN PERUBAHAN' : 'TAMBAH PRODUK',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldMain,
                          foregroundColor: whitePure,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 6,
                          shadowColor: goldMain.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}