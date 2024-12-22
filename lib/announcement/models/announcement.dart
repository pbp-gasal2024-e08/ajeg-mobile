// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

List<Announcement> announcementFromJson(String str) => List<Announcement>.from(
    json.decode(str).map((x) => Announcement.fromJson(x)));

String announcementToJson(List<Announcement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcement {
  String model;
  String pk;
  Fields fields;

  Announcement({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
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
  String title;
  String description;
  int store;

  Fields({
    required this.title,
    required this.description,
    required this.store,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        description: json["description"],
        store: json["store"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "store": store,
      };
}
