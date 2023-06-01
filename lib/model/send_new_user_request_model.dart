// To parse this JSON data, do
//
//     final sendNewUserRequestModel = sendNewUserRequestModelFromJson(jsonString);

import 'dart:convert';

SendNewUserRequestModel sendNewUserRequestModelFromJson(String str) =>
    SendNewUserRequestModel.fromJson(json.decode(str));

String sendNewUserRequestModelToJson(SendNewUserRequestModel data) =>
    json.encode(data.toJson());

class SendNewUserRequestModel {
  SendNewUserRequestModel({
    this.message,
    this.requestId,
    this.currentProvider,
  });

  String? message;
  int? requestId;
  int? currentProvider;

  factory SendNewUserRequestModel.fromJson(Map<String, dynamic> json) =>
      SendNewUserRequestModel(
        message: json["message"],
        requestId: json["request_id"],
        currentProvider: json["current_provider"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "request_id": requestId,
        "current_provider": currentProvider,
      };
}
