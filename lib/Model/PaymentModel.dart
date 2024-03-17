// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  dynamic cartDetails;
  String cfOrderId;
  DateTime createdAt;
  CustomerDetails customerDetails;
  String entity;
  double orderAmount;
  String orderCurrency;
  DateTime orderExpiryTime;
  String orderId;
  OrderMeta orderMeta;
  dynamic orderNote;
  List<dynamic> orderSplits;
  String orderStatus;
  dynamic orderTags;
  String paymentSessionId;
  dynamic terminalData;

  Payment({
    required this.cartDetails,
    required this.cfOrderId,
    required this.createdAt,
    required this.customerDetails,
    required this.entity,
    required this.orderAmount,
    required this.orderCurrency,
    required this.orderExpiryTime,
    required this.orderId,
    required this.orderMeta,
    required this.orderNote,
    required this.orderSplits,
    required this.orderStatus,
    required this.orderTags,
    required this.paymentSessionId,
    required this.terminalData,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        cartDetails: json["cart_details"],
        cfOrderId: json["cf_order_id"],
        createdAt: DateTime.parse(json["created_at"]),
        customerDetails: CustomerDetails.fromJson(json["customer_details"]),
        entity: json["entity"],
        orderAmount: json["order_amount"]?.toDouble(),
        orderCurrency: json["order_currency"],
        orderExpiryTime: DateTime.parse(json["order_expiry_time"]),
        orderId: json["order_id"],
        orderMeta: OrderMeta.fromJson(json["order_meta"]),
        orderNote: json["order_note"],
        orderSplits: List<dynamic>.from(json["order_splits"].map((x) => x)),
        orderStatus: json["order_status"],
        orderTags: json["order_tags"],
        paymentSessionId: json["payment_session_id"],
        terminalData: json["terminal_data"],
      );

  Map<String, dynamic> toJson() => {
        "cart_details": cartDetails,
        "cf_order_id": cfOrderId,
        "created_at": createdAt.toIso8601String(),
        "customer_details": customerDetails.toJson(),
        "entity": entity,
        "order_amount": orderAmount,
        "order_currency": orderCurrency,
        "order_expiry_time": orderExpiryTime.toIso8601String(),
        "order_id": orderId,
        "order_meta": orderMeta.toJson(),
        "order_note": orderNote,
        "order_splits": List<dynamic>.from(orderSplits.map((x) => x)),
        "order_status": orderStatus,
        "order_tags": orderTags,
        "payment_session_id": paymentSessionId,
        "terminal_data": terminalData,
      };
}

class CustomerDetails {
  String customerId;
  dynamic customerName;
  dynamic customerEmail;
  String customerPhone;
  dynamic customerUid;

  CustomerDetails({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerUid,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        customerUid: json["customer_uid"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "customer_uid": customerUid,
      };
}

class OrderMeta {
  String returnUrl;
  dynamic notifyUrl;
  dynamic paymentMethods;

  OrderMeta({
    required this.returnUrl,
    required this.notifyUrl,
    required this.paymentMethods,
  });

  factory OrderMeta.fromJson(Map<String, dynamic> json) => OrderMeta(
        returnUrl: json["return_url"],
        notifyUrl: json["notify_url"],
        paymentMethods: json["payment_methods"],
      );

  Map<String, dynamic> toJson() => {
        "return_url": returnUrl,
        "notify_url": notifyUrl,
        "payment_methods": paymentMethods,
      };
}
