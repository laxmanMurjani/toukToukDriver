// To parse this JSON data, do
//
//     final breakDownNewRideModel = breakDownNewRideModelFromJson(jsonString);

import 'dart:convert';

BreakDownNewRideModel breakDownNewRideModelFromJson(String str) => BreakDownNewRideModel.fromJson(json.decode(str));

String breakDownNewRideModelToJson(BreakDownNewRideModel data) => json.encode(data.toJson());

class BreakDownNewRideModel {
  BreakDownNewRideModel({
    this.userReqDetails,
  });

  List<UserReqDetail>? userReqDetails;

  factory BreakDownNewRideModel.fromJson(Map<String, dynamic> json) => BreakDownNewRideModel(
    userReqDetails: List<UserReqDetail>.from(json["userReq_details"].map((x) => UserReqDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userReq_details": List<dynamic>.from(userReqDetails!.map((x) => x.toJson())),
  };
}

class UserReqDetail {
  UserReqDetail({
    this.id,
    this.bookingId,
    this.userId,
    this.elseMobile,
    this.bookSomeoneName,
    this.braintreeNonce,
    this.providerId,
    this.currentProviderId,
    this.serviceTypeId,
    this.promocodeId,
    this.rentalHours,
    this.status,
    this.cancelledBy,
    this.cancelReason,
    this.paymentMode,
    this.selectedPayment,
    this.paid,
    this.isTrack,
    this.distance,
    this.travelTime,
    this.unit,
    this.otp,
    this.sAddress,
    this.sLatitude,
    this.sLongitude,
    this.dAddress,
    this.dLatitude,
    this.dLongitude,
    this.trackDistance,
    this.trackLatitude,
    this.trackLongitude,
    this.destinationLog,
    this.isDropLocation,
    this.isInstantRide,
    this.isDispute,
    this.assignedAt,
    this.scheduleAt,
    this.startedAt,
    this.finishedAt,
    this.isScheduled,
    this.userRated,
    this.providerRated,
    this.useWallet,
    this.surge,
    this.routeKey,
    this.nonce,
    this.geoFencingId,
    this.geoFencingDistance,
    this.geoTime,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.fare,
    this.isManual,
    this.breakdown,
    this.bkdForReqid,
    this.breakdownStatus,
    this.breakdownComment,
  });

  int? id;
  String? bookingId;
  int? userId;
  dynamic elseMobile;
  dynamic bookSomeoneName;
  dynamic braintreeNonce;
  int? providerId;
  int? currentProviderId;
  int? serviceTypeId;
  int? promocodeId;
  dynamic rentalHours;
  String? status;
  String? cancelledBy;
  dynamic cancelReason;
  String? paymentMode;
  String? selectedPayment;
  int? paid;
  String? isTrack;
  int? distance;
  String? travelTime;
  String? unit;
  String? otp;
  String? sAddress;
  double? sLatitude;
  double? sLongitude;
  String? dAddress;
  double? dLatitude;
  double? dLongitude;
  int? trackDistance;
  double? trackLatitude;
  double? trackLongitude;
  String? destinationLog;
  int? isDropLocation;
  int? isInstantRide;
  int? isDispute;
  DateTime? assignedAt;
  dynamic scheduleAt;
  DateTime? startedAt;
  DateTime? finishedAt;
  String? isScheduled;
  int? userRated;
  int? providerRated;
  int? useWallet;
  int? surge;
  String? routeKey;
  dynamic nonce;
  int? geoFencingId;
  int? geoFencingDistance;
  String? geoTime;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fare;
  int? isManual;
  int? breakdown;
  dynamic bkdForReqid;
  String? breakdownStatus;
  String? breakdownComment;

  factory UserReqDetail.fromJson(Map<String, dynamic> json) => UserReqDetail(
    id: json["id"],
    bookingId: json["booking_id"],
    userId: json["user_id"],
    elseMobile: json["else_mobile"],
    bookSomeoneName: json["book_someone_name"],
    braintreeNonce: json["braintree_nonce"],
    providerId: json["provider_id"],
    currentProviderId: json["current_provider_id"],
    serviceTypeId: json["service_type_id"],
    promocodeId: json["promocode_id"],
    rentalHours: json["rental_hours"],
    status: json["status"],
    cancelledBy: json["cancelled_by"],
    cancelReason: json["cancel_reason"],
    paymentMode: json["payment_mode"],
    selectedPayment: json["selected_payment"],
    paid: json["paid"],
    isTrack: json["is_track"],
    distance: json["distance"],
    travelTime: json["travel_time"],
    unit: json["unit"],
    otp: json["otp"],
    sAddress: json["s_address"],
    sLatitude: json["s_latitude"].toDouble(),
    sLongitude: json["s_longitude"].toDouble(),
    dAddress: json["d_address"],
    dLatitude: json["d_latitude"].toDouble(),
    dLongitude: json["d_longitude"].toDouble(),
    trackDistance: json["track_distance"],
    trackLatitude: json["track_latitude"].toDouble(),
    trackLongitude: json["track_longitude"].toDouble(),
    destinationLog: json["destination_log"],
    isDropLocation: json["is_drop_location"],
    isInstantRide: json["is_instant_ride"],
    isDispute: json["is_dispute"],
    assignedAt: DateTime.parse(json["assigned_at"]),
    scheduleAt: json["schedule_at"],
    startedAt: DateTime.parse(json["started_at"]),
    finishedAt: DateTime.parse(json["finished_at"]),
    isScheduled: json["is_scheduled"],
    userRated: json["user_rated"],
    providerRated: json["provider_rated"],
    useWallet: json["use_wallet"],
    surge: json["surge"],
    routeKey: json["route_key"],
    nonce: json["nonce"],
    geoFencingId: json["geo_fencing_id"],
    geoFencingDistance: json["geo_fencing_distance"],
    geoTime: json["geo_time"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    fare: json["fare"],
    isManual: json["is_manual"],
    breakdown: json["breakdown"],
    bkdForReqid: json["bkd_for_reqid"],
    breakdownStatus: json["breakdown_status"],
    breakdownComment: json["breakdown_comment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "user_id": userId,
    "else_mobile": elseMobile,
    "book_someone_name": bookSomeoneName,
    "braintree_nonce": braintreeNonce,
    "provider_id": providerId,
    "current_provider_id": currentProviderId,
    "service_type_id": serviceTypeId,
    "promocode_id": promocodeId,
    "rental_hours": rentalHours,
    "status": status,
    "cancelled_by": cancelledBy,
    "cancel_reason": cancelReason,
    "payment_mode": paymentMode,
    "selected_payment": selectedPayment,
    "paid": paid,
    "is_track": isTrack,
    "distance": distance,
    "travel_time": travelTime,
    "unit": unit,
    "otp": otp,
    "s_address": sAddress,
    "s_latitude": sLatitude,
    "s_longitude": sLongitude,
    "d_address": dAddress,
    "d_latitude": dLatitude,
    "d_longitude": dLongitude,
    "track_distance": trackDistance,
    "track_latitude": trackLatitude,
    "track_longitude": trackLongitude,
    "destination_log": destinationLog,
    "is_drop_location": isDropLocation,
    "is_instant_ride": isInstantRide,
    "is_dispute": isDispute,
    "assigned_at": assignedAt!.toIso8601String(),
    "schedule_at": scheduleAt,
    "started_at": startedAt!.toIso8601String(),
    "finished_at": finishedAt!.toIso8601String(),
    "is_scheduled": isScheduled,
    "user_rated": userRated,
    "provider_rated": providerRated,
    "use_wallet": useWallet,
    "surge": surge,
    "route_key": routeKey,
    "nonce": nonce,
    "geo_fencing_id": geoFencingId,
    "geo_fencing_distance": geoFencingDistance,
    "geo_time": geoTime,
    "deleted_at": deletedAt,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "fare": fare,
    "is_manual": isManual,
    "breakdown": breakdown,
    "bkd_for_reqid": bkdForReqid,
    "breakdown_status": breakdownStatus,
    "breakdown_comment": breakdownComment,
  };
}
