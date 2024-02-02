// To parse this JSON data, do
//
//     final commerce = commerceFromJson(jsonString);

import 'dart:convert';

class Commerce {
  Data data;

  Commerce({
    required this.data,
  });

  factory Commerce.fromRawJson(String str) => Commerce.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Commerce.fromJson(Map<String, dynamic> json) => Commerce(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<CommerceElement> commerces;

  Data({
    required this.commerces,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    commerces: List<CommerceElement>.from(json["commerces"].map((x) => CommerceElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "commerces": List<dynamic>.from(commerces.map((x) => x.toJson())),
  };
}

class CommerceElement {
  int id;
  String taxId;
  String name;
  String address;
  int statusId;

  CommerceElement({
    required this.id,
    required this.taxId,
    required this.name,
    required this.address,
    required this.statusId,
  });

  factory CommerceElement.fromRawJson(String str) => CommerceElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommerceElement.fromJson(Map<String, dynamic> json) => CommerceElement(
    id: json["id"],
    taxId: json["taxId"],
    name: json["name"],
    address: json["address"],
    statusId: json["statusId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "taxId": taxId,
    "name": name,
    "address": address,
    "statusId": statusId,
  };
}
