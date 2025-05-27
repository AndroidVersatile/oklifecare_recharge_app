import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String productName;
  final String imageUrl;
  final double oldPrice;
  final double discountedPrice;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.oldPrice,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    final productImages = [imageUrl];
    final category = "Category Name";
    final brand = "BrandX";
    final description = "This is a detailed description of the product...";
    final returnPolicy = "30 days return & exchange policy.";
    final rating = 4.3;
    final totalReviews = 23;

    return Scaffold(
      appBar: AppBar(
        // title: Text(productName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: productImages.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    productImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 150);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(productName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text("₹$discountedPrice",
                    style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text("₹$oldPrice",
                    style: const TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough)),
              ],
            ),
            const SizedBox(height: 10),
            Text("Category: $category", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            Text("Brand: $brand", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 15),
            const Text("Product Details:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(description),
            const SizedBox(height: 15),
            const Text("Return & Exchange Policy:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(returnPolicy),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text("$rating ($totalReviews reviews)"),
              ],
            ),
            const SizedBox(height: 15),

            /// Buttons Row
            Row(
              children: [
                // Add to Cart Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE95168),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),

                // Buy Now Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Buy now logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF018BD3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text("Buy Now", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Text("Rating & Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
