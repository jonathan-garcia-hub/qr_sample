import 'dart:convert';

class QrResponse {
  int responseStatus;
  String message;
  ResponseData responseData;

  QrResponse({
    required this.responseStatus,
    required this.message,
    required this.responseData,
  });

  factory QrResponse.fromRawJson(String str) => QrResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QrResponse.fromJson(Map<String, dynamic> json) => QrResponse(
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
  Merchant merchant;
  double amount;
  QrCode qrCode;
  String merchantId;
  String action;
  String type;
  String oper;
  int appId;
  String uid;
  String payIntentId;
  int error;
  String message;

  ResponseData({
    required this.merchant,
    required this.amount,
    required this.qrCode,
    required this.merchantId,
    required this.action,
    required this.type,
    required this.oper,
    required this.appId,
    required this.uid,
    required this.payIntentId,
    required this.error,
    required this.message,
  });

  factory ResponseData.fromRawJson(String str) => ResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    merchant: Merchant.fromJson(json["merchant"]),
    amount: json["amount"],
    qrCode: QrCode.fromJson(json["QRCode"]),
    merchantId: json["merchantId"],
    action: json["action"],
    type: json["type"],
    oper: json["oper"],
    appId: json["AppID"],
    uid: json["UID"],
    payIntentId: json["payIntentId"],
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "merchant": merchant.toJson(),
    "amount": amount,
    "QRCode": qrCode.toJson(),
    "merchantId": merchantId,
    "action": action,
    "type": type,
    "oper": oper,
    "AppID": appId,
    "UID": uid,
    "payIntentId": payIntentId,
    "error": error,
    "message": message,
  };
}

class Merchant {
  String merchantId;
  String siteId;
  String terminalId;
  String lotId;
  String name;
  String nationalId;
  String city;
  String posSessionId;
  String userId;
  String userName;

  Merchant({
    required this.merchantId,
    required this.siteId,
    required this.terminalId,
    required this.lotId,
    required this.name,
    required this.nationalId,
    required this.city,
    required this.posSessionId,
    required this.userId,
    required this.userName,
  });

  factory Merchant.fromRawJson(String str) => Merchant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
    merchantId: json["merchantId"],
    siteId: json["siteId"],
    terminalId: json["terminalId"],
    lotId: json["lotId"],
    name: json["name"],
    nationalId: json["nationalId"],
    city: json["city"],
    posSessionId: json["posSessionId"],
    userId: json["userId"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "siteId": siteId,
    "terminalId": terminalId,
    "lotId": lotId,
    "name": name,
    "nationalId": nationalId,
    "city": city,
    "posSessionId": posSessionId,
    "userId": userId,
    "userName": userName,
  };
}

class QrCode {
  String data;
  String code;
  String image;

  QrCode({
    required this.data,
    required this.code,
    required this.image,
  });

  factory QrCode.fromRawJson(String str) => QrCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
    data: json["data"],
    code: json["code"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "code": code,
    "image": image,
  };
}
