// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class User {
  String code;
  String message;
  Data data;

  User({
    required this.code,
    required this.message,
    required this.data,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  UserClass user;

  Data({
    required this.user,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: UserClass.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class UserClass {
  int id;
  String name;
  String cardId;
  String phone;
  String email;
  String secret;
  String apiKey;
  int statusId;

  UserClass({
    required this.id,
    required this.name,
    required this.cardId,
    required this.phone,
    required this.email,
    required this.secret,
    required this.apiKey,
    required this.statusId,
  });

  factory UserClass.fromRawJson(String str) => UserClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    name: json["name"],
    cardId: json["cardId"],
    phone: json["phone"],
    email: json["email"],
    secret: json["secret"],
    apiKey: json["apiKey"],
    statusId: json["statusId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cardId": cardId,
    "phone": phone,
    "email": email,
    "secret": secret,
    "apiKey": apiKey,
    "statusId": statusId,
  };
}
