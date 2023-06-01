import 'dart:convert';

SummeryModel summeryModelFromJson(String str) =>
    SummeryModel.fromJson(json.decode(str));

String summeryModelToJson(SummeryModel data) => json.encode(data.toJson());

class SummeryModel {
  SummeryModel(
      {this.rides,
      this.revenue,
      this.cancelRides,
      this.scheduledRides,
      this.totalKmDistance});

  dynamic rides;
  dynamic revenue;
  dynamic cancelRides;
  dynamic scheduledRides;
  dynamic totalKmDistance;

  factory SummeryModel.fromJson(Map<String, dynamic> json) => SummeryModel(
        rides: json["rides"],
        revenue: json["revenue"],
        cancelRides: json["cancel_rides"],
        scheduledRides: json["scheduled_rides"],
        totalKmDistance: json["total_km_distance"],
      );

  Map<String, dynamic> toJson() => {
        "rides": rides,
        "revenue": revenue,
        "cancel_rides": cancelRides,
        "scheduled_rides": scheduledRides,
        "total_km_distance": totalKmDistance,
      };
}
