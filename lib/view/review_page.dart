// --- FILE: lib/view/review_page.dart ---
import 'package:flutter/material.dart';
import '../API/api_service.dart';
import '../model/model_review.dart';

class ReviewPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ReviewPage({super.key, required this.productId, required this.productName});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ApiService apiService = ApiService();
  late Future<List<ModelReview>> _reviewsFuture;

  // DEFINISI WARNA GOLD PREMIUM
  final Color goldBg = const Color(0xFFFAF9F6); // Putih tulang premium
  final Color goldMain = const Color(0xFFD4AF37); // Gold Metallic
  final Color goldDark = const Color(0xFF996515); // Golden Brown untuk teks
  final Color whitePure = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    setState(() {
      _reviewsFuture = apiService.getReviewsByProductId(widget.productId);
    });
  }

  void _submitReview(String content, int rating) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => Center(child: CircularProgressIndicator(color: goldMain))
    );

    final newReview = ModelReview(
      id: 0,
      productId: widget.productId,
      review: content,
      rating: rating,
    );

    bool success = await apiService.addReview(newReview);

    if (mounted) Navigator.pop(context); // Tutup loading

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Review berhasil ditambahkan'), backgroundColor: goldDark)
        );
        Navigator.pop(context); // Tutup dialog form
        _loadReviews(); // Refresh list
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengirim review'), backgroundColor: Colors.redAccent)
        );
      }
    }
  }

  void _addReviewDialog() {
    final reviewController = TextEditingController();
    double ratingValue = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: whitePure,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              title: Text('Review ${widget.productName}',
                  style: TextStyle(color: goldDark, fontWeight: FontWeight.bold, fontSize: 18)
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Tulis ulasan Anda',
                      labelStyle: TextStyle(color: goldMain),
                      filled: true,
                      fillColor: goldBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: goldMain, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rating:', style: TextStyle(color: goldDark, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: goldBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: goldMain.withOpacity(0.3)),
                        ),
                        child: DropdownButton<double>(
                          value: ratingValue,
                          underline: const SizedBox(),
                          dropdownColor: whitePure,
                          icon: Icon(Icons.arrow_drop_down, color: goldMain),
                          items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(
                              value: e.toDouble(),
                              child: Text("$e Bintang", style: TextStyle(color: goldDark, fontWeight: FontWeight.w600))
                          )).toList(),
                          onChanged: (v) {
                            if (v != null) setStateDialog(() => ratingValue = v);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal', style: TextStyle(color: Colors.grey[600]))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldMain,
                    foregroundColor: whitePure,
                    elevation: 4,
                    shadowColor: goldMain.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (reviewController.text.isNotEmpty) {
                      _submitReview(reviewController.text, ratingValue.toInt());
                    }
                  },
                  child: const Text('Kirim Review', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReviewItem(ModelReview review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: whitePure,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: goldMain.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: goldMain.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [goldMain, goldDark]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: goldMain.withOpacity(0.3), blurRadius: 8)],
          ),
          child: Center(
            child: Text(
                review.rating.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
            ),
          ),
        ),
        title: Text(
          review.review,
          style: TextStyle(fontWeight: FontWeight.w600, color: goldDark, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: List.generate(5, (index) => Icon(
                index < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: goldMain, size: 22
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goldBg,
      appBar: AppBar(
        title: const Text('Ulasan Pelanggan', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: goldMain,
        foregroundColor: whitePure,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: FutureBuilder<List<ModelReview>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: goldMain));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined, size: 80, color: goldMain.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  Text('Belum ada ulasan untuk produk ini.',
                      style: TextStyle(color: goldDark, fontSize: 16, fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            );
          }

          final reviews = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: reviews.length,
            itemBuilder: (context, index) => _buildReviewItem(reviews[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReviewDialog,
        label: const Text('TULIS ULASAN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        icon: const Icon(Icons.add_comment_rounded),
        backgroundColor: goldDark,
        foregroundColor: whitePure,
        elevation: 6,
      ),
    );
  }
}