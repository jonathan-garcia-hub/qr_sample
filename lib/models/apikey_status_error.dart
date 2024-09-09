import 'dart:convert';

class ApiKeystatusError {
  DateTime timestamp;
  String path;
  int status;
  String message;
  String requestId;

  ApiKeystatusError({
    required this.timestamp,
    required this.path,
    required this.status,
    required this.message,
    required this.requestId,
  });

  factory ApiKeystatusError.fromRawJson(String str) => ApiKeystatusError.fromJson(json.decode(str));

  factory ApiKeystatusError.fromJson(Map<String, dynamic> json) => ApiKeystatusError(
    timestamp: DateTime.parse(json["timestamp"]),
    path: json["path"],
    status: json["status"],
    message: json["message"],
    requestId: json["requestId"],
  );

}
