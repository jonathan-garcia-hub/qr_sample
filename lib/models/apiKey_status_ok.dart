import 'dart:convert';

class ApiKeystatusOk {
  int port;
  String message;
  String applicationName;

  ApiKeystatusOk({
    required this.port,
    required this.message,
    required this.applicationName,
  });

  factory ApiKeystatusOk.fromRawJson(String str) => ApiKeystatusOk.fromJson(json.decode(str));

  factory ApiKeystatusOk.fromJson(Map<String, dynamic> json) => ApiKeystatusOk(
    port: json["port"],
    message: json["message"],
    applicationName: json["applicationName"],
  );

}
