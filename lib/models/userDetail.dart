import 'dart:convert';

class UserDetail {
  int id;
  String email;
  String name;
  String cardId;
  String phone;
  bool enabled;
  bool mfaEnabled;
  List<String> roles;

  UserDetail({
    required this.id,
    required this.email,
    required this.name,
    required this.cardId,
    required this.phone,
    required this.enabled,
    required this.mfaEnabled,
    required this.roles,
  });

  factory UserDetail.fromRawJson(String str) => UserDetail.fromJson(json.decode(str));

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    cardId: json["cardId"],
    phone: json["phone"],
    enabled: json["enabled"],
    mfaEnabled: json["mfaEnabled"],
    roles: List<String>.from(json["roles"].map((x) => x)),
  );

  // New empty constructor
  UserDetail.empty()
      : id = 0,
        email = "",
        name = "",
        cardId = "",
        phone = "",
        enabled = false,
        mfaEnabled = false,
        roles = [];
}
