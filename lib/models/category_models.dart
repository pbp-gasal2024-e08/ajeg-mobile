// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
    String model;
    int pk;
    Fields fields;

    CategoryModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
    String category;

    Fields({
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
    };
}
