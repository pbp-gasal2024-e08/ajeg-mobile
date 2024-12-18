// To parse this JSON data, do
//
//     final voucher = voucherFromJson(jsonString);

import 'dart:convert';

List<Voucher> voucherFromJson(String str) => List<Voucher>.from(json.decode(str).map((x) => Voucher.fromJson(x)));

String voucherToJson(List<Voucher> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Voucher {
    String model;
    int pk;
    Fields fields;

    Voucher({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
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
    String code;
    String discount;
    DateTime expiryDate;
    bool isClaimed;
    bool isFlashSale;

    Fields({
        required this.code,
        required this.discount,
        required this.expiryDate,
        required this.isClaimed,
        required this.isFlashSale,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        code: json["code"],
        discount: json["discount"],
        expiryDate: DateTime.parse(json["expiry_date"]),
        isClaimed: json["is_claimed"],
        isFlashSale: json["is_flash_sale"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "discount": discount,
        "expiry_date": expiryDate.toIso8601String(),
        "is_claimed": isClaimed,
        "is_flash_sale": isFlashSale,
    };
}
