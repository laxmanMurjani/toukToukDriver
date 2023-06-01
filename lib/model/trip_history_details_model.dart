import 'dart:convert';

import 'package:mozlit_driver/model/home_active_trip_model.dart';

TripHistoryDetailModel tripHistoryDetailModelFromJson(String str) => TripHistoryDetailModel.fromJson(json.decode(str));

String? tripHistoryDetailModelToJson(TripHistoryDetailModel data) => json.encode(data.toJson());

class TripHistoryDetailModel {

  TripHistoryDetailModel({
    this.id,
    this.bookingId,
    this.userId,
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
    this.multiDestination = const [],
    this.staticMap,
    this.dispute,
    this.contactNumber,
    this.contactEmail,
    this.payment,
    this.serviceType,
    this.user,
    this.rating,
  });

  dynamic id;
  String? bookingId;
  dynamic userId;
  dynamic braintreeNonce;
  dynamic providerId;
  dynamic currentProviderId;
  dynamic serviceTypeId;
  dynamic promocodeId;
  dynamic rentalHours;
  String? status;
  String? cancelledBy;
  dynamic cancelReason;
  String? paymentMode;
  dynamic paid;
  String? isTrack;
  dynamic distance;
  String? travelTime;
  String? unit;
  String? otp;
  String? sAddress;
  double? sLatitude;
  double? sLongitude;
  String? dAddress;
  double? dLatitude;
  double? dLongitude;
  dynamic trackDistance;
  double? trackLatitude;
  double? trackLongitude;
  String? destinationLog;
  dynamic isDropLocation;
  dynamic isInstantRide;
  dynamic isDispute;
  DateTime? assignedAt;
  dynamic scheduleAt;
  DateTime? startedAt;
  DateTime? finishedAt;
  String? isScheduled;
  dynamic userRated;
  dynamic providerRated;
  dynamic useWallet;
  dynamic surge;
  String? routeKey;
  dynamic nonce;
  dynamic geoFencingId;
  dynamic geoFencingDistance;
  String? geoTime;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fare;
  dynamic isManual;
  List<MultiDestination> multiDestination;
  String? staticMap;
  dynamic dispute;
  String? contactNumber;
  String? contactEmail;
  Payment? payment;
  ServiceType? serviceType;
  User? user;
  Rating? rating;

  factory TripHistoryDetailModel.fromJson(Map<String, dynamic> json) => TripHistoryDetailModel(
    id: json["id"],
    bookingId: json["booking_id"],
    userId: json["user_id"],
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
    startedAt:json["started_at"] == null?null: DateTime.parse(json["started_at"]),
    finishedAt:json["finished_at"] == null?null: DateTime.parse(json["finished_at"]),
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
    createdAt:json["created_at"] == null?null: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null?null:DateTime.parse(json["updated_at"]),
    fare: json["fare"],
    isManual: json["is_manual"],
    multiDestination: json["multi_destination"] == null?[]:List<MultiDestination>.from(json["multi_destination"].map((x) => MultiDestination.fromJson(x))),
    staticMap: json["static_map"],
    dispute: json["dispute"],
    contactNumber: json["contact_number"],
    contactEmail: json["contact_email"],
    payment: json["payment"] == null?null:Payment.fromJson(json["payment"]),
    serviceType:json["service_type"] == null?null :ServiceType.fromJson(json["service_type"]),
    user:json["user"] == null?null :User.fromJson(json["user"]),
    rating:json["rating"] == null?null: Rating.fromJson(json["rating"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "user_id": userId,
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
    "assigned_at": assignedAt?.toIso8601String(),
    "schedule_at": scheduleAt,
    "started_at": startedAt?.toIso8601String(),
    "finished_at": finishedAt?.toIso8601String(),
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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "fare": fare,
    "is_manual": isManual,
    "multi_destination": List<dynamic>.from(multiDestination.map((x) => x.toJson())),
    "static_map": staticMap,
    "dispute": dispute,
    "contact_number": contactNumber,
    "contact_email": contactEmail,
    "payment": payment?.toJson(),
    "service_type": serviceType?.toJson(),
    "user": user?.toJson(),
    "rating": rating?.toJson(),
  };
}

class Dispute {
  Dispute({
    this.id,
    this.requestId,
    this.disputeType,
    this.userId,
    this.providerId,
    this.disputeName,
    this.disputeTitle,
    this.comments,
    this.refundAmount,
    this.status,
    this.isAdmin,
  });

  int? id;
  int? requestId;
  String? disputeType;
  int? userId;
  int? providerId;
  String? disputeName;
  String? disputeTitle;
  String? comments;
  int? refundAmount;
  String? status;
  int? isAdmin;

  factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
    id: json["id"],
    requestId: json["request_id"],
    disputeType: json["dispute_type"],
    userId: json["user_id"],
    providerId: json["provider_id"],
    disputeName: json["dispute_name"],
    disputeTitle: json["dispute_title"],
    comments: json["comments"],
    refundAmount: json["refund_amount"],
    status: json["status"],
    isAdmin: json["is_admin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "request_id": requestId,
    "dispute_type": disputeType,
    "user_id": userId,
    "provider_id": providerId,
    "dispute_name": disputeName,
    "dispute_title": disputeTitle,
    "comments": comments,
    "refund_amount": refundAmount,
    "status": status,
    "is_admin": isAdmin,
  };
}



class Rating {
  Rating({
    this.id,
    this.requestId,
    this.userId,
    this.providerId,
    this.userRating,
    this.providerRating,
    this.userComment,
    this.providerComment,
  });

  dynamic id;
  dynamic requestId;
  dynamic userId;
  dynamic providerId;
  dynamic userRating;
  dynamic providerRating;
  String? userComment;
  String? providerComment;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json["id"],
    requestId: json["request_id"],
    userId: json["user_id"],
    providerId: json["provider_id"],
    userRating: json["user_rating"],
    providerRating: json["provider_rating"],
    userComment: json["user_comment"],
    providerComment: json["provider_comment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "request_id": requestId,
    "user_id": userId,
    "provider_id": providerId,
    "user_rating": userRating,
    "provider_rating": providerRating,
    "user_comment": userComment,
    "provider_comment": providerComment,
  };
}

class ServiceType {
  ServiceType({
    this.id,
    this.name,
    this.providerName,
    this.image,
    this.marker,
    this.capacity,
    this.fixed,
    this.price,
    this.minute,
    this.hour,
    this.distance,
    this.calculator,
    this.description,
    this.waitingFreeMins,
    this.waitingMinCharge,
    this.status,
  });

  dynamic id;
  String? name;
  String? providerName;
  String? image;
  String? marker;
  dynamic capacity;
  dynamic fixed;
  dynamic price;
  dynamic minute;
  dynamic hour;
  dynamic distance;
  String? calculator;
  dynamic description;
  dynamic waitingFreeMins;
  dynamic waitingMinCharge;
  dynamic status;

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"],
    name: json["name"],
    providerName: json["provider_name"],
    image: json["image"],
    marker: json["marker"],
    capacity: json["capacity"],
    fixed: json["fixed"],
    price: json["price"],
    minute: json["minute"],
    hour: json["hour"],
    distance: json["distance"],
    calculator: json["calculator"],
    description: json["description"],
    waitingFreeMins: json["waiting_free_mins"],
    waitingMinCharge: json["waiting_min_charge"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "provider_name": providerName,
    "image": image,
    "marker": marker,
    "capacity": capacity,
    "fixed": fixed,
    "price": price,
    "minute": minute,
    "hour": hour,
    "distance": distance,
    "calculator": calculator,
    "description": description,
    "waiting_free_mins": waitingFreeMins,
    "waiting_min_charge": waitingMinCharge,
    "status": status,
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.paymentMode,
    this.userType,
    this.email,
    this.gender,
    this.countryCode,
    this.mobile,
    this.picture,
    this.deviceToken,
    this.deviceId,
    this.deviceType,
    this.loginBy,
    this.socialUniqueId,
    this.latitude,
    this.longitude,
    this.stripeCustId,
    this.walletBalance,
    this.rating,
    this.otp,
    this.language,
    this.qrcodeUrl,
    this.referralUniqueId,
    this.referalCount,
    this.updatedAt,
  });

  dynamic id;
  String? firstName;
  String? lastName;
  String? paymentMode;
  String? userType;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  String? picture;
  String? deviceToken;
  String? deviceId;
  String? deviceType;
  String? loginBy;
  String? socialUniqueId;
  dynamic latitude;
  dynamic longitude;
  String? stripeCustId;
  dynamic walletBalance;
  String? rating;
  dynamic otp;
  dynamic language;
  String? qrcodeUrl;
  String? referralUniqueId;
  dynamic referalCount;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    paymentMode: json["payment_mode"],
    userType: json["user_type"],
    email: json["email"],
    gender: json["gender"],
    countryCode: json["country_code"],
    mobile: json["mobile"],
    picture: json["picture"],
    deviceToken: json["device_token"],
    deviceId: json["device_id"],
    deviceType: json["device_type"],
    loginBy: json["login_by"],
    socialUniqueId: json["social_unique_id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    stripeCustId: json["stripe_cust_id"],
    walletBalance: json["wallet_balance"],
    rating: json["rating"],
    otp: json["otp"],
    language: json["language"],
    qrcodeUrl: json["qrcode_url"],
    referralUniqueId: json["referral_unique_id"],
    referalCount: json["referal_count"],
    updatedAt: json["updated_at"] == null?null:DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "payment_mode": paymentMode,
    "user_type": userType,
    "email": email,
    "gender": gender,
    "country_code": countryCode,
    "mobile": mobile,
    "picture": picture,
    "device_token": deviceToken,
    "device_id": deviceId,
    "device_type": deviceType,
    "login_by": loginBy,
    "social_unique_id": socialUniqueId,
    "latitude": latitude,
    "longitude": longitude,
    "stripe_cust_id": stripeCustId,
    "wallet_balance": walletBalance,
    "rating": rating,
    "otp": otp,
    "language": language,
    "qrcode_url": qrcodeUrl,
    "referral_unique_id": referralUniqueId,
    "referal_count": referalCount,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
