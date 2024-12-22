// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  String model;
  String pk;
  Fields fields;

  Review({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int creator;
  int product;
  DateTime createdAt;
  DateTime lastUpdated;
  int starRating;
  String synopsis;
  String baseComment;

  Fields({
    required this.creator,
    required this.product,
    required this.createdAt,
    required this.lastUpdated,
    required this.starRating,
    required this.synopsis,
    required this.baseComment,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        creator: json["creator"],
        product: json["product"],
        createdAt: DateTime.parse(json["created_at"]),
        lastUpdated: DateTime.parse(json["last_updated"]),
        starRating: json["star_rating"],
        synopsis: json["synopsis"],
        baseComment: json["base_comment"],
      );

  Map<String, dynamic> toJson() => {
        "creator": creator,
        "product": product,
        "created_at": createdAt.toIso8601String(),
        "last_updated": lastUpdated.toIso8601String(),
        "star_rating": starRating,
        "synopsis": synopsis,
        "base_comment": baseComment,
      };
}
