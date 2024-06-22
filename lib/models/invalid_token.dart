import 'dart:convert';

class TokenVencido {
  DateTime timestamp;
  String path;
  int status;
  String message;
  String requestId;

  TokenVencido({
    required this.timestamp,
    required this.path,
    required this.status,
    required this.message,
    required this.requestId,
  });

  factory TokenVencido.fromRawJson(String str) => TokenVencido.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenVencido.fromJson(Map<String, dynamic> json) => TokenVencido(
    timestamp: DateTime.parse(json["timestamp"]),
    path: json["path"],
    status: json["status"],
    message: json["message"],
    requestId: json["requestId"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "path": path,
    "status": status,
    "message": message,
    "requestId": requestId,
  };
}
