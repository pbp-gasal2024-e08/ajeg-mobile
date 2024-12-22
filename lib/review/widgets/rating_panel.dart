import 'dart:convert';

import 'package:ajeg_mobile/products/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class RatingPanel extends StatefulWidget {
  final ProductModel product;

  const RatingPanel({super.key, required this.product});

  @override
  State<RatingPanel> createState() => _RatingPanelState();
}

class _RatingPanelState extends State<RatingPanel> {
  int _rating = 0;
  String _synopsis = '';
  String _comment = '';

  void submitReview(BuildContext context, CookieRequest request) async {
    await request.postJson(
      "http://https://thorbert-anson-ajeg.pbp.cs.ui.ac.id/review/add-review/${widget.product.pk}",
      jsonEncode(<String, dynamic>{
        'star_rating': _rating,
        'synopsis': _synopsis,
        'base_comment': _comment,
      }),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    i <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = i;
                    });
                  },
                ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Give us a short description',
            ),
            onChanged: (value) {
              setState(() {
                _synopsis = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter your comment',
            ),
            onChanged: (value) {
              setState(() {
                _comment = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              submitReview(context, request);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
