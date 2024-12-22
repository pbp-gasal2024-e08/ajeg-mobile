import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class RatingPanel extends StatefulWidget {
  const RatingPanel({super.key});

  @override
  State<RatingPanel> createState() => _RatingPanelState();
}

class _RatingPanelState extends State<RatingPanel> {
  int _rating = 0;
  String _comment = '';

  void submitReview(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://10.0.2.2:8000/review/",
      jsonEncode(<String, dynamic>{
        'rating': _rating,
        'comment': _comment,
      }),
    );

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit review.')),
      );
    }
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
