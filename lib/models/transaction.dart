import 'dart:convert';

class Transaction {
  Data data;

  Transaction({
    required this.data,
  });

  factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    data: Data.fromJson(json["data"]),
  );

}

class Data {
  List<QrTransaction> qrTransactions;

  Data({
    required this.qrTransactions,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    qrTransactions: List<QrTransaction>.from(json["qrTransactions"].map((x) => QrTransaction.fromJson(x))),
  );

}

class QrTransaction {
  int id;
  String mit;
  DateTime date;
  Operation operation;
  int userId;
  Name name;
  String phone;
  Cardd cardd;
  String d002;
  String amount;
  String d011;
  String d032;
  String d033;
  String referenceId;
  String? d038;
  String d039;
  D043 d043;
  String description;

  QrTransaction({
    required this.id,
    required this.mit,
    required this.date,
    required this.operation,
    required this.userId,
    required this.name,
    required this.phone,
    required this.cardd,
    required this.d002,
    required this.amount,
    required this.d011,
    required this.d032,
    required this.d033,
    required this.referenceId,
    required this.d038,
    required this.d039,
    required this.d043,
    required this.description,
  });

  factory QrTransaction.fromRawJson(String str) => QrTransaction.fromJson(json.decode(str));


  factory QrTransaction.fromJson(Map<String, dynamic> json) => QrTransaction(
    id: json["id"],
    mit: json["mit"],
    date: DateTime.parse(json["tranDate"]),
    operation: operationValues.map[json["operation"]]!,
    userId: json["userId"],
    name: nameValues.map[json["name"]]!,
    phone: json["phone"],
    cardd: carddValues.map[json["cardd"]]!,
    d002: json["d002"],
    amount: json["d004"],
    d011: json["d011"],
    d032: json["d032"],
    d033: json["d033"],
    referenceId: json["d037"],
    d038: json["d038"],
    d039: json["d039"],
    d043: d043Values.map[json["d043"]]!,
    description: json["d104"],
  );

}

enum Cardd {
  V16113921,
  V25157584
}

final carddValues = EnumValues({
  "V16113921": Cardd.V16113921,
  "V25157584": Cardd.V25157584
});

enum D043 {
  ISA_CANDELARIO_CARACAS,
  JONATHAN_GARCIA_CARACAS
}

final d043Values = EnumValues({
  "Isa Candelario/CARACAS": D043.ISA_CANDELARIO_CARACAS,
  "Jonathan Garcia/CARACAS": D043.JONATHAN_GARCIA_CARACAS
});

enum Name {
  JONATHAN_GARCIA,
  JOSE_ROSAS
}

final nameValues = EnumValues({
  "Jonathan Garcia": Name.JONATHAN_GARCIA,
  "Jose Rosas": Name.JOSE_ROSAS
});

enum Operation {
  PAY,
  PAYMENT
}

final operationValues = EnumValues({
  "pay": Operation.PAY,
  "payment": Operation.PAYMENT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
