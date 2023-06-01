import 'dart:convert';

import 'package:mozlit_driver/model/user_detail_model.dart';

ServiceTypeModel serviceTypeModelFromJson(String str) =>
    ServiceTypeModel.fromJson(json.decode(str));

String serviceTypeModelToJson(ServiceTypeModel data) =>
    json.encode(data.toJson());

class ServiceTypeModel {
  ServiceTypeModel({
    this.serviceTypes = const [],
    this.apiKey,
    this.androidApiKey,
    this.iosApiKey,
    this.referral,
  });

  List<ServiceType> serviceTypes;
  String? apiKey;
  String? androidApiKey;
  String? iosApiKey;
  Referral? referral;

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      ServiceTypeModel(
        serviceTypes: json["serviceTypes"] == null
            ? []
            : List<ServiceType>.from(
                json["serviceTypes"].map((x) => ServiceType.fromJson(x))),
        apiKey: json["api_key"],
        androidApiKey: json["android_api_key"],
        iosApiKey: json["ios_api_key"],
        referral: json["referral"] == null
            ? null
            : Referral.fromJson(json["referral"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceTypes": List<dynamic>.from(serviceTypes.map((x) => x.toJson())),
        "api_key": apiKey,
        "android_api_key": androidApiKey,
        "ios_api_key": iosApiKey,
        "referral": referral?.toJson(),
      };
}

class Referral {
  Referral({
    this.referral,
    this.count,
    this.amount,
    this.rideOtp,
  });

  String? referral;
  String? count;
  String? amount;
  int? rideOtp;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        referral: json["referral"],
        count: json["count"],
        amount: json["amount"],
        rideOtp: json["ride_otp"],
      );

  Map<String, dynamic> toJson() => {
        "referral": referral,
        "count": count,
        "amount": amount,
        "ride_otp": rideOtp,
      };
}

