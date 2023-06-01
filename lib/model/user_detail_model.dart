// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  UserDetailModel({
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
    this.currency,
    this.sos,
    this.measurement,
    this.profile,
    this.cash,
    this.card,
    this.stripeSecretKey,
    this.stripePublishableKey,
    this.stripeCurrency,
    this.payumoney,
    this.paypal,
    this.paypalAdaptive,
    this.braintree,
    this.paytm,
    this.stripeOauthUrl,
    this.payumoneyEnvironment,
    this.payumoneyKey,
    this.payumoneySalt,
    this.payumoneyAuth,
    this.paypalEnvironment,
    this.paypalCurrency,
    this.paypalClientId,
    this.paypalClientSecret,
    this.braintreeEnvironment,
    this.braintreeMerchantId,
    this.braintreePublicKey,
    this.braintreePrivateKey,
    this.referralCount,
    this.referralAmount,
    this.referralText,
    this.referralTotalCount,
    this.referralTotalAmount,
    this.referralTotalText,
    this.rideOtp,
  });

  dynamic  id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  dynamic avatar;
  String? rating;
  String? status;
  dynamic fleet;
  dynamic latitude;
  dynamic longitude;
  dynamic stripeAccId;
  dynamic stripeCustId;
  dynamic paypalEmail;
  String? loginBy;
  dynamic socialUniqueId;
  dynamic  otp;
  dynamic  walletBalance;
  String? referralUniqueId;
  String? qrcodeUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;
  String? currency;
  String? sos;
  String? measurement;
  Profile? profile;
  dynamic  cash;
  dynamic  card;
  String? stripeSecretKey;
  String? stripePublishableKey;
  String? stripeCurrency;
  dynamic  payumoney;
  dynamic  paypal;
  dynamic  paypalAdaptive;
  dynamic  braintree;
  dynamic  paytm;
  String? stripeOauthUrl;
  String? payumoneyEnvironment;
  String? payumoneyKey;
  String? payumoneySalt;
  String? payumoneyAuth;
  String? paypalEnvironment;
  String? paypalCurrency;
  String? paypalClientId;
  String? paypalClientSecret;
  String? braintreeEnvironment;
  String? braintreeMerchantId;
  String? braintreePublicKey;
  String? braintreePrivateKey;
  String? referralCount;
  String? referralAmount;
  String? referralText;
  String? referralTotalCount;
  dynamic referralTotalAmount;
  String? referralTotalText;
  dynamic  rideOtp;

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
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
        walletBalance: json["wallet_balance"],
        referralUniqueId: json["referral_unique_id"],
        qrcodeUrl: json["qrcode_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        currency: json["currency"],
        sos: json["sos"],
        measurement: json["measurement"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        cash: json["cash"],
        card: json["card"],
        stripeSecretKey: json["stripe_secret_key"],
        stripePublishableKey: json["stripe_publishable_key"],
        stripeCurrency: json["stripe_currency"],
        payumoney: json["payumoney"],
        paypal: json["paypal"],
        paypalAdaptive: json["paypal_adaptive"],
        braintree: json["braintree"],
        paytm: json["paytm"],
        stripeOauthUrl: json["stripe_oauth_url"],
        payumoneyEnvironment: json["payumoney_environment"],
        payumoneyKey: json["payumoney_key"],
        payumoneySalt: json["payumoney_salt"],
        payumoneyAuth: json["payumoney_auth"],
        paypalEnvironment: json["paypal_environment"],
        paypalCurrency: json["paypal_currency"],
        paypalClientId: json["paypal_client_id"],
        paypalClientSecret: json["paypal_client_secret"],
        braintreeEnvironment: json["braintree_environment"],
        braintreeMerchantId: json["braintree_merchant_id"],
        braintreePublicKey: json["braintree_public_key"],
        braintreePrivateKey: json["braintree_private_key"],
        referralCount: json["referral_count"],
        referralAmount: json["referral_amount"],
        referralText: json["referral_text"],
        referralTotalCount: json["referral_total_count"],
        referralTotalAmount: json["referral_total_amount"],
        referralTotalText: json["referral_total_text"],
        rideOtp: json["ride_otp"],
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
        "currency": currency,
        "sos": sos,
        "measurement": measurement,
        "profile": profile?.toJson(),
        "cash": cash,
        "card": card,
        "stripe_secret_key": stripeSecretKey,
        "stripe_publishable_key": stripePublishableKey,
        "stripe_currency": stripeCurrency,
        "payumoney": payumoney,
        "paypal": paypal,
        "paypal_adaptive": paypalAdaptive,
        "braintree": braintree,
        "paytm": paytm,
        "stripe_oauth_url": stripeOauthUrl,
        "payumoney_environment": payumoneyEnvironment,
        "payumoney_key": payumoneyKey,
        "payumoney_salt": payumoneySalt,
        "payumoney_auth": payumoneyAuth,
        "paypal_environment": paypalEnvironment,
        "paypal_currency": paypalCurrency,
        "paypal_client_id": paypalClientId,
        "paypal_client_secret": paypalClientSecret,
        "braintree_environment": braintreeEnvironment,
        "braintree_merchant_id": braintreeMerchantId,
        "braintree_public_key": braintreePublicKey,
        "braintree_private_key": braintreePrivateKey,
        "referral_count": referralCount,
        "referral_amount": referralAmount,
        "referral_text": referralText,
        "referral_total_count": referralTotalCount,
        "referral_total_amount": referralTotalAmount,
        "referral_total_text": referralTotalText,
        "ride_otp": rideOtp,
      };
}

class Profile {
  Profile({
    this.id,
    this.providerId,
    this.language,
    this.address,
    this.addressSecondary,
    this.city,
    this.country,
    this.postalCode,
  });

  dynamic  id;
  dynamic  providerId;
  String? language;
  dynamic address;
  dynamic addressSecondary;
  dynamic city;
  dynamic country;
  dynamic postalCode;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        providerId: json["provider_id"],
        language: json["language"],
        address: json["address"],
        addressSecondary: json["address_secondary"],
        city: json["city"],
        country: json["country"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "language": language,
        "address": address,
        "address_secondary": addressSecondary,
        "city": city,
        "country": country,
        "postal_code": postalCode,
      };
}

class Service {
  Service({
    this.id,
    this.providerId,
    this.serviceTypeId,
    this.status,
    this.serviceNumber,
    this.car_camp_name,
    this.car_color,
    this.serviceModel,
    this.serviceType,
  });

  dynamic  id;
  dynamic  providerId;
  dynamic  serviceTypeId;
  String? status;
  String? serviceNumber;
  String? car_camp_name;
  String? car_color;
  String? serviceModel;
  ServiceType? serviceType;


  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        providerId: json["provider_id"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
        serviceNumber: json["service_number"],
    car_color: json["car_color"],
    car_camp_name: json["car_camp_name"],
        serviceModel: json["service_model"],
        serviceType: json["service_type"] == null? null:ServiceType.fromJson(json["service_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "service_type_id": serviceTypeId,
        "status": status,
        "service_number": serviceNumber,
        "car_camp_name": car_camp_name,
        "car_color": car_color,
        "service_model": serviceModel,
        "service_type": serviceType?.toJson(),
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
    required this.moduletype,
  });

  dynamic  id;
  String? name;
  String? providerName;
  String? image;
  String? marker;
  dynamic  capacity;
  dynamic  fixed;
  dynamic  price;
  dynamic  minute;
  dynamic  hour;
  dynamic  distance;
  String? calculator;
  dynamic description;
  dynamic  waitingFreeMins;
  dynamic  waitingMinCharge;
  dynamic  status;
  String  moduletype;

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
        moduletype: json["module_type"],
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
        "module_type": moduletype,
      };
}
