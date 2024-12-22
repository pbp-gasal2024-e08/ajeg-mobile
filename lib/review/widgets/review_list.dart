import 'dart:convert';

import 'package:ajeg_mobile/widgets/truncated_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:ajeg_mobile/products/models/product_model.dart';
import 'package:ajeg_mobile/review/models/review_model.dart';

class ReviewList extends StatelessWidget {
  final ProductModel product;

  const ReviewList({super.key, required this.product});

  fetchReviews(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/review/by-product/${product.pk}/',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);
    return FutureBuilder(
      future: fetchReviews(request),
      builder: (context, AsyncSnapshot<List<Review>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (_, index) {
                final review = snapshot.data![index].fields;
                return ReviewListItem(
                  creator: review.creator.toString(),
                  createdAt: review.createdAt,
                  lastUpdated: review.lastUpdated,
                  starRating: review.starRating,
                  synopsis: review.synopsis,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No reviews available.'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ReviewListItem extends StatelessWidget {
  final String creator;
  final DateTime createdAt;
  final DateTime lastUpdated;
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
          Text("Creator: $creator"),
          Text("Created At: $createdAt"),
          Text("Last Updated: $lastUpdated"),
          Text("Star Rating: $starRating"),
          TruncatedText(
            text: "Synopsis: $synopsis",
            maxLength: 50,
          ),
        ],
      ),
    );
  }
}
