// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

List<StoreModel> storeModelFromJson(String str) => List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

String storeModelToJson(List<StoreModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
    String model;
    int pk;
    Fields fields;

    StoreModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
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
    String name;
    String url;
    String priceRange;
    double rating;
    List<int> category;

    Fields({
        required this.name,
        required this.url,
        required this.priceRange,
        required this.rating,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        url: json["url"],
        priceRange: json["price_range"],
        rating: json["rating"]?.toDouble(),
        category: List<int>.from(json["category"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "price_range": priceRange,
        "rating": rating,
        "category": List<dynamic>.from(category.map((x) => x)),
    };
}
