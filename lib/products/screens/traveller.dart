import 'dart:convert';
import 'package:ajeg_mobile/products/models/product_model.dart';
import 'package:ajeg_mobile/review/widgets/rating_panel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ajeg_mobile/review/widgets/review_list.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<ProductModel> _allProducts;

  @override
  void initState() {
    super.initState();
    _allProducts = [];
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://localhost:8000/get-products/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allProducts =
              data.map((json) => ProductModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        backgroundColor: Colors.blue,
      ),
      body: //_allProducts.isEmpty
          //     ? const Center(child: CircularProgressIndicator())
          /*     : */ GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: _allProducts.length,
        itemBuilder: (context, index) {
          final product = _allProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AspectRatio(
                  //   aspectRatio: 1.6,
                  //   child: Image.network(
                  //     product.imgurl ??
                  //         'https://via.placeholder.com/150', // Fallback image
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return const Icon(Icons.error, size: 48);
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.fields.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.fields.price}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.green),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rating: ${product.fields.averageRating} (${product.fields.reviewCount} reviews)',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String? imgurl;
  final int reviewCount;
  final int averageRating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imgurl,
    required this.reviewCount,
    required this.averageRating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    return Product(
      id: json['pk'],
      name: fields['name'],
      price: fields['price'],
      description: fields['description'],
      imgurl: fields['imgurl'],
      reviewCount: fields['review_count'] ?? 0,
      averageRating: fields['average_rating'] ?? 0,
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AspectRatio(
            //   aspectRatio: 1.6,
            //   child: Image.network(
            //     product.imgurl ??
            //         'https://via.placeholder.com/150', // Fallback image
            //     fit: BoxFit.cover,
            //     errorBuilder: (context, error, stackTrace) {
            //       return const Icon(Icons.error, size: 48);
            //     },
            //   ),
            // ),
            const SizedBox(height: 16),
            Text(
              product.fields.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.fields.price}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (int i = 0; i < product.fields.averageRating; i++)
                  const Icon(Icons.star, color: Colors.amber),
                for (int i = 0; i < 5 - product.fields.averageRating; i++)
                  const Icon(Icons.star_border, color: Colors.amber),
                GestureDetector(
                  child: Text("${product.fields.reviewCount} reviews"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewList(product: product),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.fields.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Actually add product to cart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
