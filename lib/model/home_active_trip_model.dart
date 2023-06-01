



import 'dart:convert';

HomeActiveTripModel homeActiveTripModelFromJson(String str) =>
    HomeActiveTripModel.fromJson(json.decode(str));

String? homeActiveTripModelToJson(HomeActiveTripModel data) =>
    json.encode(data.toJson());

class HomeActiveTripModel {
  HomeActiveTripModel({
    this.user_device_token,
    this.provider_id,
    this.accountStatus,
    this.breakdown_count_check,
    this.is_instant_ride_check,
    this.currency,
    this.serviceStatus,
    this.requests = const [],
    this.multiDestination = const [],
    this.providerDetails,
    this.reasons = const [],
    this.referralCount,
    this.referralAmount,
    this.rideOtp,
    this.referralText,
    this.referralTotalCount,
    this.referralTotalAmount,
    this.referralTotalText,
    this.statusInfo,
    this.providerVerifyCheck,
    this.userVerifyCheck,
    this.driverServiceType,
    this.driverVerifyCounter
  });

  String? accountStatus;
  int? provider_id;
  int? breakdown_count_check;
  String? user_device_token;
  int? is_instant_ride_check;
  String? currency;
  String? serviceStatus;
  List<RequestElement> requests;
  List<MultiDestination> multiDestination;
  ProviderDetails? providerDetails;
  List<Reason> reasons;
  String? referralCount;
  String? referralAmount;
  dynamic rideOtp;
  String? referralText;
  String? referralTotalCount;
  dynamic referralTotalAmount;
  String? referralTotalText;
  String? statusInfo;
  String? providerVerifyCheck;
  String? userVerifyCheck;
  dynamic driverServiceType;
  String? driverVerifyCounter;

  factory HomeActiveTripModel.fromJson(Map<String, dynamic> json) =>
      HomeActiveTripModel(
        accountStatus: json["account_status"],
        provider_id: json["provider_id"],
        breakdown_count_check: json["breakdown_count_check"],
        is_instant_ride_check: json["is_instant_ride_check"],
        currency: json["currency"],
        serviceStatus: json["service_status"],
        requests: json["requests"] == null
            ? []
            : List<RequestElement>.from(
                json["requests"].map((x) => RequestElement.fromJson(x))),
        multiDestination: json["multi_destination"] == null
            ? []
            : List<MultiDestination>.from(json["multi_destination"]
                .map((x) => MultiDestination.fromJson(x))),
        providerDetails: json["provider_details"] == null
            ? null
            : ProviderDetails.fromJson(json["provider_details"]),
        reasons: json["reasons"] == null
            ? []
            : List<Reason>.from(json["reasons"].map((x) => Reason.fromJson(x))),
        referralCount: json["referral_count"],
        referralAmount: json["referral_amount"],
        user_device_token: json["user_device_token"],
        rideOtp: json["ride_otp"],
        referralText: json["referral_text"],
        referralTotalCount: json["referral_total_count"],
        referralTotalAmount: json["referral_total_amount"],
        referralTotalText: json["referral_total_text"],
        statusInfo: json["provider_details"]["status_info"],
        providerVerifyCheck: json["providerVerifyCheck"],
        userVerifyCheck: json["providerVerifyCheck"],
        driverServiceType: json["driver_service_type"],
        driverVerifyCounter: json["driver_verify_counter"]
      );

  Map<String, dynamic> toJson() => {
        "account_status": accountStatus,
        "breakdown_count_check": breakdown_count_check,
        "provider_id": provider_id,
        "is_instant_ride_check": is_instant_ride_check,
        "currency": currency,
        "service_status": serviceStatus,
        "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
        "multi_destination":
            List<dynamic>.from(multiDestination.map((x) => x.toJson())),
        "provider_details": providerDetails?.toJson(),
        "reasons": List<dynamic>.from(reasons.map((x) => x.toJson())),
        "referral_count": referralCount,
        "referral_amount": referralAmount,
        "user_device_token": user_device_token,
        "ride_otp": rideOtp,
        "referral_text": referralText,
        "referral_total_count": referralTotalCount,
        "referral_total_amount": referralTotalAmount,
        "referral_total_text": referralTotalText,
        "status_info": statusInfo,
        "providerVerifyCheck": providerVerifyCheck,
        "userVerifyCheck": userVerifyCheck,
        "driver_service_type": driverServiceType,
        "driver_verify_counter": driverVerifyCounter
      };
}

class MultiDestination {
  MultiDestination({
    this.id,
    this.requestId,
    this.latitude,
    this.longitude,
    this.finalDestination,
    this.createdAt,
    this.updatedAt,
    this.isPickedup,
    this.dAddress,
    this.deletedAt,
  });

  dynamic id;
  dynamic requestId;
  double? latitude;
  double? longitude;
  dynamic finalDestination;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic isPickedup;
  String? dAddress;
  dynamic deletedAt;

  factory MultiDestination.fromJson(Map<String, dynamic> json) =>
      MultiDestination(
        id: json["id"],
        requestId: json["request_id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        finalDestination: json["final_destination"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isPickedup: json["is_pickedup"],
        dAddress: json["d_address"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "latitude": latitude,
        "longitude": longitude,
        "final_destination": finalDestination,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_pickedup": isPickedup,
        "d_address": dAddress,
        "deleted_at": deletedAt,
      };
}

class ProviderDetails {
  ProviderDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.countryCode,
    this.mobile,
    this.avatar,
    this.rating,
    this.status,
    this.fleet,
    this.latitude,
    this.longitude,
    this.stripeAccId,
    this.stripeCustId,
    this.paypalEmail,
    this.loginBy,
    this.socialUniqueId,
    this.otp,
    this.walletBalance,
    this.referralUniqueId,
    this.qrcodeUrl,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  dynamic id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  String? avatar;
  String? rating;
  String? status;
  dynamic fleet;
  String? latitude;
  String? longitude;
  dynamic stripeAccId;
  dynamic stripeCustId;
  dynamic paypalEmail;
  String? loginBy;
  dynamic socialUniqueId;
  dynamic otp;
  double? walletBalance;
  String? referralUniqueId;
  dynamic qrcodeUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;

  factory ProviderDetails.fromJson(Map<String, dynamic> json) =>
      ProviderDetails(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        gender: json["gender"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        avatar: json["avatar"],
        rating: json["rating"],
        status: json["status"],
        fleet: json["fleet"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        stripeAccId: json["stripe_acc_id"],
        stripeCustId: json["stripe_cust_id"],
        paypalEmail: json["paypal_email"],
        loginBy: json["login_by"],
        socialUniqueId: json["social_unique_id"],
        otp: json["otp"],
        walletBalance: json["wallet_balance"].toDouble(),
        referralUniqueId: json["referral_unique_id"],
        qrcodeUrl: json["qrcode_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "gender": gender,
        "country_code": countryCode,
        "mobile": mobile,
        "avatar": avatar,
        "rating": rating,
        "status": status,
        "fleet": fleet,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_acc_id": stripeAccId,
        "stripe_cust_id": stripeCustId,
        "paypal_email": paypalEmail,
        "login_by": loginBy,
        "social_unique_id": socialUniqueId,
        "otp": otp,
        "wallet_balance": walletBalance,
        "referral_unique_id": referralUniqueId,
        "qrcode_url": qrcodeUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service": service?.toJson(),
      };
}

class Service {
  Service({
    this.id,
    this.providerId,
    this.serviceTypeId,
    this.status,
    this.serviceNumber,
    this.serviceModel,
  });

  dynamic id;
  dynamic providerId;
  dynamic serviceTypeId;
  String? status;
  String? serviceNumber;
  String? serviceModel;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        providerId: json["provider_id"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
        serviceNumber: json["service_number"],
        serviceModel: json["service_model"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "service_type_id": serviceTypeId,
        "status": status,
        "service_number": serviceNumber,
        "service_model": serviceModel,
      };
}

class Reason {
  Reason({
    this.id,
    this.type,
    this.reason,
    this.status,
  });

  dynamic id;
  String? type;
  String? reason;
  dynamic status;

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
        id: json["id"],
        type: json["type"],
        reason: json["reason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "reason": reason,
        "status": status,
      };
}

class RequestElement {
  RequestElement({
    this.id,
    this.requestId,
    this.providerId,
    this.status,
    this.timeLeftToRespond,
    this.request,
  });

  dynamic id;
  dynamic requestId;
  dynamic providerId;
  dynamic status;
  dynamic timeLeftToRespond;
  RequestRequest? request;

  factory RequestElement.fromJson(Map<String, dynamic> json) => RequestElement(
        id: json["id"],
        requestId: json["request_id"],
        providerId: json["provider_id"],
        status: json["status"],
        timeLeftToRespond: json["time_left_to_respond"],
        request: json["request"] == null
            ? null
            : RequestRequest.fromJson(json["request"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "provider_id": providerId,
        "status": status,
        "time_left_to_respond": timeLeftToRespond,
        "request": request?.toJson(),
      };
}

class RequestRequest {
  RequestRequest({
    this.id,
    this.bookingId,
    this.userId,
    this.else_mobile,
    this.selected_payment,
    this.book_someone_name,
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
    this.breakdown,
    this.bkd_for_reqid,
    this.breakdown_status,
    this.breakdown_comment,
    this.user,
    this.payment,
    this.moduleType,
    this.deliveryPackageDetails,
  });

  dynamic id;
  String? bookingId;
  String? book_someone_name;
  String? selected_payment;
  String? else_mobile;
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
  dynamic breakdown;
  dynamic bkd_for_reqid;
  dynamic breakdown_status;
  dynamic breakdown_comment;
  User? user;
  Payment? payment;
  String? moduleType;
  String? deliveryPackageDetails;

  factory RequestRequest.fromJson(Map<String, dynamic> json) => RequestRequest(
        id: json["id"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        else_mobile: json["else_mobile"],
        book_someone_name: json["book_someone_name"],
    selected_payment: json["selected_payment"],
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
    breakdown: json["breakdown"],
    bkd_for_reqid: json["bkd_for_reqid"],
    breakdown_status: json["breakdown_status"],
    breakdown_comment: json["breakdown_comment"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
    moduleType: json["module_type"],
    deliveryPackageDetails: json["delivery_package_details"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "user_id": userId,
        "book_someone_name": book_someone_name,
        "else_mobile": else_mobile,
        "braintree_nonce": braintreeNonce,
        "selected_payment": selected_payment,
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
        "breakdown": breakdown,
        "bkd_for_reqid": bkd_for_reqid,
        "breakdown_status": breakdown_status,
        "breakdown_comment": breakdown_comment,
        "user": user?.toJson(),
        "payment": payment?.toJson(),
    "module_type":moduleType,
    "delivery_package_details":deliveryPackageDetails
      };
}

class Payment {
  Payment({
    this.id,
    this.requestId,
    this.userId,
    this.breakdown_amount,
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
  String? breakdown_amount;
  double? fixed;
  dynamic distance;
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
    breakdown_amount: json["breakdown_amount"].toString(),
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
        "breakdown_amount": breakdown_amount,
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
  dynamic stripeCustId;
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
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
