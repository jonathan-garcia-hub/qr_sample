import 'dart:convert';

class StatusResponse {
  int responseStatus;
  String message;
  ResponseData responseData;

  StatusResponse({
    required this.responseStatus,
    required this.message,
    required this.responseData,
  });

  factory StatusResponse.fromRawJson(String str) => StatusResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusResponse.fromJson(Map<String, dynamic> json) => StatusResponse(
    responseStatus: json["responseStatus"],
    message: json["message"],
    responseData: ResponseData.fromJson(json["responseData"]),
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "message": message,
    "responseData": responseData.toJson(),
  };
}

class ResponseData {
  String payIntentId;
  String type = '';
  DateTime date;
  Merchant merchant;
  String oper;
  double amount;
  String status;
  int error;
  String message;
  int appId;

  ResponseData({
    required this.payIntentId,
    required this.type,
    required this.date,
    required this.merchant,
    required this.oper,
    required this.amount,
    required this.status,
    required this.error,
    required this.message,
    required this.appId,
  });

  factory ResponseData.fromRawJson(String str) => ResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    payIntentId: json["payIntentId"],
    type: json["type"],
    date: DateTime.parse(json["date"]),
    merchant: Merchant.fromJson(json["merchant"]),
    oper: json["oper"],
    amount: json["amount"]?.toDouble(),
    status: json["status"],
    error: json["error"],
    message: json["message"],
    appId: json["AppID"],
  );

  Map<String, dynamic> toJson() => {
    "payIntentId": payIntentId,
    "type": type,
    "date": date.toIso8601String(),
    "merchant": merchant.toJson(),
    "oper": oper,
    "amount": amount,
    "status": status,
    "error": error,
    "message": message,
    "AppID": appId,
  };
}

class Merchant {
  String merchantId;
  String siteId;
  String terminalId;
  String lotId;
  String transactionId;
  String posSessionId;
  String userId;

  Merchant({
    required this.merchantId,
    required this.siteId,
    required this.terminalId,
    required this.lotId,
    required this.transactionId,
    required this.posSessionId,
    required this.userId,
  });

  factory Merchant.fromRawJson(String str) => Merchant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
    merchantId: json["merchantId"],
    siteId: json["siteId"],
    terminalId: json["terminalId"],
    lotId: json["lotId"],
    transactionId: json["transactionId"],
    posSessionId: json["posSessionId"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "siteId": siteId,
    "terminalId": terminalId,
    "lotId": lotId,
    "transactionId": transactionId,
    "posSessionId": posSessionId,
    "userId": userId,
  };
}
