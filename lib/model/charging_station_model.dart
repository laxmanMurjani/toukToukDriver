// To parse this JSON data, do
//
//     final chargingStationModel = chargingStationModelFromJson(jsonString);

import 'dart:convert';

ChargingStationModel chargingStationModelFromJson(String str) => ChargingStationModel.fromJson(json.decode(str));

String chargingStationModelToJson(ChargingStationModel data) => json.encode(data.toJson());

class ChargingStationModel {
  ChargingStationModel({
    this.chargingStation,
  });

  List<ChargingStation>? chargingStation;

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) => ChargingStationModel(
    chargingStation: List<ChargingStation>.from(json["charging_station"].map((x) => ChargingStation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "charging_station": List<dynamic>.from(chargingStation!.map((x) => x.toJson())),
  };
}

class ChargingStation {
  ChargingStation({
    this.station,
    this.phone,
    this.km,
    this.time,
    this.timeValue,
    this.desination,this.longitude,this.latitude
  });

  String? station;
  String? phone;
  String? km;
  String? time;
  int? timeValue;
  String? desination;
  String? latitude;
  String? longitude;

  factory ChargingStation.fromJson(Map<String, dynamic> json) => ChargingStation(
    station: json["station"],
    phone: json["phone"],
    km: json["km"],
    time: json["time"],
    timeValue: json["time_value"],
    desination: json["desination"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "station": station,
    "latitude": latitude,
    "longitude": longitude,
    "phone": phone,
    "km": km,
    "time": time,
    "time_value": timeValue,
    "desination": desination,
  };
}
