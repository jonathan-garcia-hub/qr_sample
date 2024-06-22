import 'dart:convert';

class QrStatusResponse {
  int id;
  // String nonce;
  // String code;
  // String originAffiliationId;
  // String originPhone;
  // int destinationAffiliationId;
  // String destinationPhone;
  // double amount;
  String reference;
  String receipt;
  String status;
  // String serial;
  // DateTime createAt;
  // DateTime updatedAt;

  QrStatusResponse({
    required this.id,
    // required this.nonce,
    // required this.code,
    // required this.originAffiliationId,
    // required this.originPhone,
    // required this.destinationAffiliationId,
    // required this.destinationPhone,
    // required this.amount,
    required this.reference,
    required this.receipt,
    required this.status,
    // required this.serial,
    // required this.createAt,
    // required this.updatedAt,
  });

  factory QrStatusResponse.fromRawJson(String str) => QrStatusResponse.fromJson(json.decode(str));

  factory QrStatusResponse.fromJson(Map<String, dynamic> json) => QrStatusResponse(
    id: json["id"],
    // nonce: json["nonce"] ?? 'NA',
    // code: json["code"] ?? 'NA',
    // originAffiliationId: json["originAffiliationId"] ?? 'NA',
    // originPhone: json["originPhone"] ?? 'NA',
    // destinationAffiliationId: json["destinationAffiliationId"],
    // destinationPhone: json["destinationPhone"] ?? 'NA',
    // amount: json["amount"]  ?? 'NA',
    reference: json["reference"] ?? 'NA',
    receipt: json["receipt"] ?? 'NA',
    status: json["status"]  ?? 'NA',
    // serial: json["serial"]  ?? 'NA',
    // createAt: DateTime.parse(json["createAt"]),
    // updatedAt: DateTime.parse(json["updatedAt"]),
  );

}
