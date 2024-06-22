import 'dart:convert';

class NewUser {
  String email;
  String name;
  String token;

  NewUser({
    required this.email,
    required this.name,
    required this.token,
  });

  factory NewUser.fromRawJson(String str) => NewUser.fromJson(json.decode(str));

  factory NewUser.fromJson(Map<String, dynamic> json) => NewUser(
    email: json["email"],
    name: json["name"],
    token: json["token"],
  );

}
