// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

List<Announcement> announcementFromJson(String str) => List<Announcement>.from(
    json.decode(str).map((x) => Announcement.fromJson(x)));

String announcementToJson(List<Announcement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcement {
  String pk;
  String title;
  String description;
  int store;
  String storeName;
  bool isOwner;

  Announcement({
    required this.pk,
    required this.title,
    required this.description,
    required this.store,
    required this.storeName,
    required this.isOwner,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        pk: json["pk"],
        title: json["title"],
        description: json["description"],
        store: json["store"],
        storeName: json["storeName"],
        isOwner: json["isOwner"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "title": title,
        "description": description,
        "store": store,
        "storeName": storeName,
        "isOwner": isOwner,
      };
}
