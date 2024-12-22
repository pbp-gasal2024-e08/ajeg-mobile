import 'package:ajeg_mobile/widgets/truncated_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:ajeg_mobile/products/models/product_model.dart';
import 'package:ajeg_mobile/review/models/editable_review_model.dart';

class ReviewList extends StatelessWidget {
  final ProductModel product;

  const ReviewList({super.key, required this.product});

  Future<List<EditableReview>> fetchReviews(CookieRequest request) async {
    final response = await request
        .get('http://localhost:8000/review/by-product/${product.pk}');

    List<EditableReview> results = [];

    var data = response;

    for (var d in data["data"]) {
      if (d != null) {
        results.add(EditableReview.fromJson(d));
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);
    return FutureBuilder<List<EditableReview>>(
      future: fetchReviews(request),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData) {
            return const Column(
              children: [
                Text(
                  'No reviews found.',
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                ),
                SizedBox(height: 8),
              ],
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Reviews for ${product.fields.name}'),
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final voucher = snapshot.data![index];
                  return ReviewListItem(
                    creator: voucher.creator.toString(),
                    createdAt: voucher.createdAt,
                    lastUpdated: voucher.lastUpdated,
                    starRating: voucher.starRating,
                    synopsis: voucher.synopsis,
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}

class ReviewListItem extends StatelessWidget {
  final String creator;
  final String createdAt;
  final String lastUpdated;
  final int starRating;
  final String synopsis;

  const ReviewListItem({
    super.key,
    required this.creator,
    required this.createdAt,
    required this.lastUpdated,
    required this.starRating,
    required this.synopsis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Review by $creator",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Created: $createdAt",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                "Updated: $lastUpdated",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < starRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TruncatedText(
                text: synopsis,
                maxLength: 50,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
