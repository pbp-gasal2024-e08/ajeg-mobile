// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
    String model;
    int pk;
    Fields fields;

    ProductModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
    int store;
    String name;
    int price;
    String imgurl;
    String description;
    dynamic reviewCount;
    dynamic averageRating;

    Fields({
        required this.store,
        required this.name,
        required this.price,
        required this.imgurl,
        required this.description,
        required this.reviewCount,
        required this.averageRating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        store: json["store"],
        name: json["name"],
        price: json["price"],
        imgurl: json["imgurl"],
        description: json["description"],
        reviewCount: json["review_count"],
        averageRating: json["average_rating"],
    );

    Map<String, dynamic> toJson() => {
        "store": store,
        "name": name,
        "price": price,
        "imgurl": imgurl,
        "description": description,
        "review_count": reviewCount,
        "average_rating": averageRating,
    };
}
