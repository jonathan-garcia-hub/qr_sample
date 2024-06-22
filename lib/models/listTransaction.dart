import 'dart:convert';

class ListTransaction {
  int id;
  String code;
  String status;
  String amount;
  String description;
  String date;

  ListTransaction({
    required this.id,
    required this.code,
    required this.status,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory ListTransaction.fromRawJson(String str) => ListTransaction.fromJson(json.decode(str));

  factory ListTransaction.fromJson(Map<String, dynamic> json) => ListTransaction(
    id: json["id"],
    code: json["code"],
    status: json["status"],
    amount: json["amount"],
    description: json["description"],
    date: json["date"],
  );

}