// To parse this JSON data, do
//
//     final editableReview = editableReviewFromJson(jsonString);

import 'dart:convert';

EditableReview editableReviewFromJson(String str) =>
    EditableReview.fromJson(json.decode(str));

String editableReviewToJson(EditableReview data) => json.encode(data.toJson());

class EditableReview {
  String id;
  int product;
  String creator;
  int starRating;
  String synopsis;
  String createdAt;
  String lastUpdated;
  BaseComment baseComment;
  bool editable;

  EditableReview({
    required this.id,
    required this.product,
    required this.creator,
    required this.starRating,
    required this.synopsis,
    required this.createdAt,
    required this.lastUpdated,
    required this.baseComment,
    required this.editable,
  });

  factory EditableReview.fromJson(Map<String, dynamic> json) => EditableReview(
        id: json["id"],
        product: json["product"],
        creator: json["creator"],
        starRating: json["star_rating"],
        synopsis: json["synopsis"],
        createdAt: json["created_at"],
        lastUpdated: json["last_updated"],
        baseComment: BaseComment.fromJson(json["base_comment"]),
        editable: json["editable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "creator": creator,
        "star_rating": starRating,
        "synopsis": synopsis,
        "created_at": createdAt,
        "last_updated": lastUpdated,
        "base_comment": baseComment.toJson(),
        "editable": editable,
      };
}

class BaseComment {
  String id;
  String content;

  BaseComment({
    required this.id,
    required this.content,
  });

  factory BaseComment.fromJson(Map<String, dynamic> json) => BaseComment(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}
