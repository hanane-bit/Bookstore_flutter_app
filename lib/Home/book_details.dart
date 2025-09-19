import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/models/models.dart';
import 'package:projet_final/models/providers.dart';
import 'wishlist.dart';


void showBookDetails(BuildContext context, Books book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return SizedBox(
        height: screenHeight * 0.9,
        child: BookDetails(book: book),
      );
    },
  );
}

class BookDetails extends ConsumerStatefulWidget {
  final Books book;
  const BookDetails({super.key, required this.book});

  @override
  ConsumerState<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends ConsumerState<BookDetails> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    final wishlist = ref.read(wishlistProvider).value ?? [];
    isLiked = wishlist.any((w) => w.book_id == widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.9,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 160,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(widget.book.book_image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.book.book_title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final controller = ref.read(wishlistProvider.notifier);
                    if (isLiked) {
                      await controller.removeFromWishlist(widget.book.id);
                    } else {
                      await controller.addToWishlist(widget.book);
                    }
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isLiked ? Colors.purple : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.book.vendor_image.isNotEmpty)
              Image.network(widget.book.vendor_image, height: 50),
            const SizedBox(height: 12),
            Text(widget.book.book_description, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 20),
            const Text("Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < widget.book.book_rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "(${widget.book.book_rating.toDouble().toStringAsFixed(1)})",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(widget.book.book_price,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF54408C))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const WishList()),
);

                },
                child: const Text(
                  "View Wishlist",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF54408C)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
