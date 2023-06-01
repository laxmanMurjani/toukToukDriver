import 'dart:convert';

import 'package:mozlit_driver/model/user_detail_model.dart';

EarningModel earningModelFromJson(String str) =>
    EarningModel.fromJson(json.decode(str));

String earningModelToJson(EarningModel data) => json.encode(data.toJson());

class EarningModel {
  EarningModel({
    this.rides = const [],
    this.ridesCount,
    this.target,
  });

  List<Ride> rides;
  dynamic ridesCount;
  String? target;

  factory EarningModel.fromJson(Map<String, dynamic> json) => EarningModel(
        rides: json["rides"] == null
            ? []
            : List<Ride>.from(json["rides"].map((x) => Ride.fromJson(x))),
        ridesCount: json["rides_count"],
        target: json["target"],
      );

  Map<String, dynamic> toJson() => {
        "rides": List<dynamic>.from(rides.map((x) => x.toJson())),
        "rides_count": ridesCount,
        "target": target,
      };
}

class Ride {
  Ride({
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
    this.payment,
    this.serviceType,
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
  dynamic sLatitude;
  dynamic sLongitude;
  String? dAddress;
  dynamic dLatitude;
  dynamic dLongitude;
  dynamic trackDistance;
  dynamic trackLatitude;
  dynamic trackLongitude;
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
  Payment? payment;
  ServiceType? serviceType;

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
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
        sLatitude:
            json["s_latitude"] == null ? null : json["s_latitude"].toDouble(),
        sLongitude:
            json["s_longitude"] == null ? null : json["s_longitude"].toDouble(),
        dAddress: json["d_address"],
        dLatitude:
            json["d_latitude"] == null ? null : json["d_latitude"].toDouble(),
        dLongitude:
            json["d_longitude"] == null ? null : json["d_longitude"].toDouble(),
        trackDistance: json["track_distance"],
        trackLatitude: json["track_latitude"] == null
            ? null
            : json["track_latitude"].toDouble(),
        trackLongitude: json["track_longitude"] == null
            ? null
            : json["track_longitude"].toDouble(),
        destinationLog: json["destination_log"],
        isDropLocation: json["is_drop_location"],
        isInstantRide: json["is_instant_ride"],
        isDispute: json["is_dispute"],
        assignedAt: json["assigned_at"] == null
            ? null
            : DateTime.parse(json["assigned_at"]),
        scheduleAt: json["schedule_at"],
        startedAt: json["started_at"] == null
            ? null
            : DateTime.parse(json["started_at"]),
        finishedAt: json["finished_at"] == null
            ? null
            : DateTime.parse(json["finished_at"]),
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        fare: json["fare"],
        isManual: json["is_manual"],
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        serviceType: json["service_type"] == null
            ? null
            : ServiceType.fromJson(json["service_type"]),
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
        "payment": payment?.toJson(),
        "service_type": serviceType?.toJson(),
      };
}

class Payment {
  Payment({
    this.id,
    this.requestId,
    this.userId,
    this.providerId,
    this.fleetId,
    this.promocodeId,
    this.paymentId,
    this.paymentMode,
    this.fixed,
    this.distance,
    this.minute,
    this.hour,
    this.commision,
    this.commisionPer,
    this.fleet,
    this.fleetPer,
    this.discount,
    this.discountPer,
    this.tax,
    this.taxPer,
    this.wallet,
    this.isPartial,
    this.cash,
    this.card,
    this.online,
    this.surge,
    this.tollCharge,
    this.roundOf,
    this.peakAmount,
    this.peakCommAmount,
    this.totalWaitingTime,
    this.waitingAmount,
    this.waitingCommAmount,
    this.tips,
    this.total,
    this.payable,
    this.providerCommission,
    this.providerPay,
  });

  dynamic id;
  dynamic requestId;
  dynamic userId;
  dynamic providerId;
  dynamic fleetId;
  dynamic promocodeId;
  dynamic paymentId;
  String? paymentMode;
  dynamic fixed;
  dynamic distance;
  dynamic minute;
  dynamic hour;
  dynamic commision;
  dynamic commisionPer;
  dynamic fleet;
  dynamic fleetPer;
  dynamic discount;
  dynamic discountPer;
  dynamic tax;
  dynamic taxPer;
  dynamic wallet;
  dynamic isPartial;
  dynamic cash;
  dynamic card;
  dynamic online;
  dynamic surge;
  dynamic tollCharge;
  dynamic roundOf;
  dynamic peakAmount;
  dynamic peakCommAmount;
  dynamic totalWaitingTime;
  dynamic waitingAmount;
  dynamic waitingCommAmount;
  dynamic tips;
  dynamic total;
  dynamic payable;
  dynamic providerCommission;
  dynamic providerPay;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        requestId: json["request_id"],
        userId: json["user_id"],
        providerId: json["provider_id"],
        fleetId: json["fleet_id"],
        promocodeId: json["promocode_id"],
        paymentId: json["payment_id"],
        paymentMode: json["payment_mode"],
        fixed: json["fixed"].toDouble(),
        distance: json["distance"],
        minute: json["minute"],
        hour: json["hour"],
        commision: json["commision"].toDouble(),
        commisionPer: json["commision_per"],
        fleet: json["fleet"],
        fleetPer: json["fleet_per"],
        discount: json["discount"],
        discountPer: json["discount_per"],
        tax: json["tax"].toDouble(),
        taxPer: json["tax_per"],
        wallet: json["wallet"],
        isPartial: json["is_partial"],
        cash: json["cash"],
        card: json["card"],
        online: json["online"],
        surge: json["surge"],
        tollCharge: json["toll_charge"],
        roundOf: json["round_of"].toDouble(),
        peakAmount: json["peak_amount"],
        peakCommAmount: json["peak_comm_amount"],
        totalWaitingTime: json["total_waiting_time"],
        waitingAmount: json["waiting_amount"],
        waitingCommAmount: json["waiting_comm_amount"],
        tips: json["tips"],
        total: json["total"].toDouble(),
        payable: json["payable"],
        providerCommission: json["provider_commission"],
        providerPay: json["provider_pay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "user_id": userId,
        "provider_id": providerId,
        "fleet_id": fleetId,
        "promocode_id": promocodeId,
        "payment_id": paymentId,
        "payment_mode": paymentMode,
        "fixed": fixed,
        "distance": distance,
        "minute": minute,
        "hour": hour,
        "commision": commision,
        "commision_per": commisionPer,
        "fleet": fleet,
        "fleet_per": fleetPer,
        "discount": discount,
        "discount_per": discountPer,
        "tax": tax,
        "tax_per": taxPer,
        "wallet": wallet,
        "is_partial": isPartial,
        "cash": cash,
        "card": card,
        "online": online,
        "surge": surge,
        "toll_charge": tollCharge,
        "round_of": roundOf,
        "peak_amount": peakAmount,
        "peak_comm_amount": peakCommAmount,
        "total_waiting_time": totalWaitingTime,
        "waiting_amount": waitingAmount,
        "waiting_comm_amount": waitingCommAmount,
        "tips": tips,
        "total": total,
        "payable": payable,
        "provider_commission": providerCommission,
        "provider_pay": providerPay,
      };
}

