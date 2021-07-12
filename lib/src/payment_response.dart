import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) => PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) => json.encode(data.toJson());

class PaymentResponse {
  PaymentResponse({
    this.productId,
    this.productName,
    this.totalAmount,
    this.environment,
    this.code,
    this.merchantName,
    this.message,
    this.transactionDetails,
  });

  final String productId;
  final String productName;
  final String totalAmount;
  final String environment;
  final String code;
  final String merchantName;
  final Message message;
  final TransactionDetails transactionDetails;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
    productId: json["productId"],
    productName: json["productName"],
    totalAmount: json["totalAmount"],
    environment: json["environment"],
    code: json["code"],
    merchantName: json["merchantName"],
    message: Message.fromJson(json["message"]),
    transactionDetails: TransactionDetails.fromJson(json["transactionDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "totalAmount": totalAmount,
    "environment": environment,
    "code": code,
    "merchantName": merchantName,
    "message": message.toJson(),
    "transactionDetails": transactionDetails.toJson(),
  };
}

class Message {
  Message({
    this.technicalSuccessMessage,
    this.successMessage,
  });

  final String technicalSuccessMessage;
  final String successMessage;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    technicalSuccessMessage: json["technicalSuccessMessage"],
    successMessage: json["successMessage"],
  );

  Map<String, dynamic> toJson() => {
    "technicalSuccessMessage": technicalSuccessMessage,
    "successMessage": successMessage,
  };
}

class TransactionDetails {
  TransactionDetails({
    this.status,
    this.referenceId,
    this.date,
  });

  final String status;
  final String referenceId;
  final String date;

  factory TransactionDetails.fromJson(Map<String, dynamic> json) => TransactionDetails(
    status: json["status"],
    referenceId: json["referenceId"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "referenceId": referenceId,
    "date": date,
  };
}
