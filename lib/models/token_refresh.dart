import 'dart:convert';

class TokenRefresh {
  String email;
  String name;
  String token;

  TokenRefresh({
    required this.email,
    required this.name,
    required this.token,
  });

  factory TokenRefresh.fromRawJson(String str) => TokenRefresh.fromJson(json.decode(str));

  factory TokenRefresh.fromJson(Map<String, dynamic> json) => TokenRefresh(
    email: json["email"],
    name: json["name"],
    token: json["token"],
  );
}
