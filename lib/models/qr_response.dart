import 'dart:convert';

class NewQrResponse {
  final double amount;
  final QrCode qrCode;
  final int merchantId;
  final Merchant merchant;
  final String action;
  final String type;
  final int error;
  final String message;

  const NewQrResponse({
    required this.amount,
    required this.qrCode,
    required this.merchantId,
    required this.merchant,
    required this.action,
    required this.type,
    required this.error,
    required this.message,
  });

  factory NewQrResponse.fromRawJson(String str) => NewQrResponse.fromJson(json.decode(str));

  factory NewQrResponse.fromJson(Map<String, dynamic> json) => NewQrResponse(
    amount: json["amount"]?.toDouble(),
    qrCode: QrCode.fromJson(json["QRCode"]),
    merchantId: json["merchantId"],
    merchant: Merchant.fromJson(json["merchant"]),
    action: json["action"],
    type: json["type"],
    error: json["error"],
    message: json["message"],
  );
}

class QrCode {
  String image;
  String code;
  String data;

  QrCode({
    required this.image,
    required this.code,
    required this.data,
  });

  factory QrCode.fromRawJson(String str) => QrCode.fromJson(json.decode(str));

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
    image: json['image'].split(',').last,
    code: json["code"],
    data: json["data"],
  );

}

class Merchant {
  int merchantId;
  String city;
  String name;
  String userName;
  int userId;
  String cardTaxId;

  Merchant({
    required this.merchantId,
    required this.city,
    required this.name,
    required this.userName,
    required this.userId,
    required this.cardTaxId,
  });

  factory Merchant.fromRawJson(String str) => Merchant.fromJson(json.decode(str));


  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
    merchantId: json["merchantId"],
    city: json["city"],
    name: json["name"],
    userName: json["userName"],
    userId: json["userId"],
    cardTaxId: json["cardTaxId"] ?? 'V25157584',
  );


}