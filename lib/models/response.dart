// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

class Response {
  String codigo;
  String message;
  String recibo;

  Response({
    required this.codigo,
    required this.message,
    required this.recibo,
  });

  factory Response.fromRawJson(String str) => Response.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    codigo: json["codigo"],
    message: json["message"],
    recibo: json["recibo"],
  );

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "message": message,
    "recibo": recibo,
  };
}
