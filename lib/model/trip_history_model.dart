import 'dart:convert';

List<TripHistoryModel> tripHistoryModelFromJson(String str) =>
    List<TripHistoryModel>.from(
        json.decode(str).map((x) => TripHistoryModel.fromJson(x)));

String tripHistoryModelToJson(List<TripHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripHistoryModel {
  TripHistoryModel({
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
  double? distance;
  String? travelTime;
  String? unit;
  String? otp;
  String? sAddress;
  double? sLatitude;
  double? sLongitude;
  String? dAddress;
  double? dLatitude;
  double? dLongitude;
  double? trackDistance;
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
  List<dynamic> multiDestination;
  String? staticMap;
  Payment? payment;
  ServiceType? serviceType;

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) =>
      TripHistoryModel(
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
        distance: json["distance"].toDouble(),
        travelTime: json["travel_time"],
        unit: json["unit"],
        otp: json["otp"],
        sAddress: json["s_address"],
        sLatitude: json["s_latitude"].toDouble(),
        sLongitude: json["s_longitude"].toDouble(),
        dAddress: json["d_address"],
        dLatitude: json["d_latitude"].toDouble(),
        dLongitude: json["d_longitude"].toDouble(),
        trackDistance: json["track_distance"].toDouble(),
        trackLatitude: json["track_latitude"].toDouble(),
        trackLongitude: json["track_longitude"].toDouble(),
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
        multiDestination: json["multi_destination"] == null
            ? []
            : List<dynamic>.from(json["multi_destination"].map((x) => x)),
        staticMap: json["static_map"],
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
        "multi_destination": List<dynamic>.from(multiDestination.map((x) => x)),
        "static_map": staticMap,
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
  double? fixed;
  double? distance;
  dynamic minute;
  dynamic hour;
  double? commision;
  dynamic commisionPer;
  dynamic fleet;
  dynamic fleetPer;
  dynamic discount;
  dynamic discountPer;
  double? tax;
  dynamic taxPer;
  dynamic wallet;
  dynamic isPartial;
  dynamic cash;
  dynamic card;
  dynamic online;
  dynamic surge;
  dynamic tollCharge;
  double? roundOf;
  dynamic peakAmount;
  dynamic peakCommAmount;
  dynamic totalWaitingTime;
  dynamic waitingAmount;
  dynamic waitingCommAmount;
  dynamic tips;
  double? total;
  dynamic payable;
  dynamic providerCommission;
  double? providerPay;

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
        distance: json["distance"].toDouble(),
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
        providerPay: json["provider_pay"].toDouble(),
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
