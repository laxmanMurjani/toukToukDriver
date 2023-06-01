import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppImage {
  static const String _basePath = "assets/images";

  static String logo = "$_basePath/logo.png";
  static String logoT = "$_basePath/bg_logo_2.png";
  static String appLogo = "$_basePath/app_logo.png";
  static String appMainLogo = "$_basePath/bg_logo_2.png";
  static String mozilitDriverSplash = "$_basePath/mozilitDriverSplash.png";
  static String mozilitNameLogo = "$_basePath/mozilitNameLogo.png";
  static String paymentSuccess = "$_basePath/payment_success.png";
  static String timerJson = "$_basePath/timer.json";
  static String downArrow1 = "$_basePath/down_arrow.png";
  static String account = "$_basePath/acount.png";
  static String bell = "$_basePath/bell.png";
  static String profilePic = "$_basePath/profilePic.png";
  static String building = "$_basePath/building.png";
  static String whatsapp = "$_basePath/whatsapp.png";
  // static String auto1 = "$_basePath/auto1.png";
  static String logoOpacity = "$_basePath/logo_opacity.png";
  static String auto4 = "$_basePath/auto4.jpg";
  static String downArrow = "$_basePath/arrow.png";
  static String help = "$_basePath/help.png";
  static String summary = "$_basePath/summary.png";
  static String chargingStation = "$_basePath/charging_station.png";
  static String earning = "$_basePath/earning.png";
  static String document = "$_basePath/document.png";
  static String walletNew = "$_basePath/wallet_new.png";
  static String inviteFriend = "$_basePath/invite_friend.png";
  static String logOut = "$_basePath/logout.png";
  static String locationArrow = "$_basePath/locationArrow.png";
  static String preview = "$_basePath/preview.png";
  static String edit = "$_basePath/edit.png";
  static String walletCard = "$_basePath/wallet_card.png";
  static String instantRide = "$_basePath/instant_ride.png";
  static String backArrow = "$_basePath/back_arrow.png";
  static String pastRide = "$_basePath/pastRide.png";
  static String chat = "$_basePath/chat.png";
  static String search = "$_basePath/search.png";
  static String pin = "$_basePath/pin.png";
  static String gps = "$_basePath/gps.png";
  static String creditCard = "$_basePath/credit_card.png";
  static String insta = "$_basePath/insta.png";
  static String helpBoy = "$_basePath/help_boy.png";
  static String twitter = "$_basePath/twitter.png";
  static String coupons = "$_basePath/coupons.png";
  static String mySelf = "$_basePath/my_self.png";
  static String saveContact = "$_basePath/save_contact.png";
  static String people = "$_basePath/people.png";
  static String loginBackground = "$_basePath/login_background.png";
  static String walkthroughFirst = "$_basePath/walkthrough_first.png";
  static String walkthrough2 = "$_basePath/walkthrough_2.png";
  static String walkthrough3 = "$_basePath/walkthrough_3.png";
  static String giftCard = "$_basePath/gift-card.png";
  static String back = "$_basePath/back.png";
  static String next = "$_basePath/next.png";
  static String root = "$_basePath/root.png";
  static String car = "$_basePath/car1.png";
  static String car2 = "$_basePath/car2.png";
  static String car3 = "$_basePath/car3.png";
  static String apple = "$_basePath/apple.png";
  static String facebook = "$_basePath/facebook.png";
  static String email = "$_basePath/email.png";
  static String drawer = "$_basePath/drawer_bg.png";
  static String work_icon = "$_basePath/work_icon.png";
  static String home_icon = "$_basePath/home_icon.png";
  static String wallet_icon = "$_basePath/wallet_icon.png";
  static String wallet_icon2 = "$_basePath/ic_wallete_image.png";
  static String moreMenu = "$_basePath/ic_more_menu.png";

  static String loginBg = "$_basePath/login_bg.png";
  static String icMenu = "$_basePath/ic_menu.png";
  static String bgAppLogo = "$_basePath/bg_app_logo.png";
  static String call = "$_basePath/call.png";
  static String message = "$_basePath/message.png";
  static String flag = "$_basePath/flag.png";
  static String flag1 = "$_basePath/flag1.png";
  static String flagUser = "$_basePath/flag_user.png";
  static String icArrivedSelect = "$_basePath/ic_arrived_select.png";
  static String icFinished = "$_basePath/ic_finished.png";
  static String breakDown = "$_basePath/break_down.png";
  static String icPickup = "$_basePath/ic_pickup.png";
  static String icPickupSelect = "$_basePath/ic_pickup_select.png";
  static String icUserPlaceholder = "$_basePath/ic_user_placeholder.png";
  static String multiDestIcon = "$_basePath/multi_dest_icon.png";
  static String srcIcon = "$_basePath/src_icon.png";
  static String desIcon = "$_basePath/des_icon.png";
  static String icHomeLocation = "$_basePath/icHomeLocation.png";
  static String icGPS = "$_basePath/icon_gps.png";
  static String otp = "$_basePath/otp.png";
  static String icWhiteArrow = "$_basePath/ic_white_arrow.png";
  static String wallet = "$_basePath/wallet.png";
  static String icPin = "$_basePath/ic_pin.png";
  static String icQrScan = '$_basePath/ic_qr_scan.png';
  static String icQrCode = "$_basePath/ic_qr_code.png";
  static String icRiding = "$_basePath/ic_riding.png";
  static String icPauseRiding = "$_basePath/ic_pause_riding.png";
  static String offline = "$_basePath/offline.png";
  static String licenceImage = "$_basePath/licence_image.png";
  static String clock = "$_basePath/clock.png";
  static String splash_logo = "$_basePath/splash_logo.png";
  static String mozilit_footer = "$_basePath/logo1.png";
  static String black_footer = "$_basePath/black_footer.png";
  static String mozilit_icon = "$_basePath/mozilit_icon.png";
  static String send_fill = "$_basePath/send_fill.png";
  static String phone = "$_basePath/phone.png";
  static String pointClock = "$_basePath/pointclock.png";
  static String autoArrived = "$_basePath/auto_arrived.png";
  static String carArrived = "$_basePath/car_arrived.png";
  static String mapPin = "$_basePath/mapfin_done.png";
  static String monyCash = "$_basePath/mony_cash.png";
  static String verifiedIcon = "$_basePath/1000.png";
  static String circleCheck = "$_basePath/circleCheck.png";
}

double? latitude, longitude;

Future<void> getCurrentLocation() async {
  await Geolocator.isLocationServiceEnabled();

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  latitude = position.latitude;
  longitude = position.longitude;
  print("latitude $latitude");
  print("longitude $longitude");
}

class AppColors {
  // static const Color primaryColor = Color(0xff3081A6);

  //static const Color primaryColor = Color(0xff393A3C);
  static const Color primaryColor = Color(0xff1C1C1C);
  static const Color white = Color(0xffffffff);
  static const Color yellow = Color(0xffD6D00F);
  static const Color primaryColor2 = Color(0xff00994E);
  static const Color lightGray = Color(0xffC7C7C7);
  static const Color gray = Color(0xffB7B7B7);
  static const Color drawer = Color(0xff282828);
  static const Color shadowColor = Color(0x16000000);
  static const Color bgColor = Color(0xffEFEFEF);
  static const Color openBgColor = Color(0xffe7ebff);
  static const Color openWordColor = Color(0xff1b66ee);
  static const Color closeBgColor = Color(0xffffe7ed);
  static const Color closeWordColor = Color(0xffff3823);
  static const Color underLineColor = Color(0xffb9b9b9);

  static const Color drawerGradient1 = Color(0xff282828);
  static const Color drawerGradient2 = Color(0xff545454);

  static const Color appColor = Color(0xff1C1C1C);
  static const Color summeryColor1 = Color(0xffD9912F);
  static const Color summeryColor2 = Color(0xffD6D00F);
  static const Color summeryColor3 = Color(0xff0080A5);
  static const Color summeryColor4 = Color(0xffAD3E3E);
  static const Color unselectedColor = Color(0xffffffff);
  static const Color selectedColor = Color(0xff000000);
}

class AppBoxShadow {
  static BoxShadow defaultShadow() => BoxShadow(
        color: AppColors.shadowColor,
        offset: Offset(0, 12.h),
        blurRadius: 16.r,
      );
}

class AppString {
  static String? googleMapKey;

  static String MINUTE = "MIN";
  static String HOUR = "HOUR";
  static String DISTANCE = "DISTANCE";
  static String DISTANCE_MIN = "DISTANCEMIN";
  static String DISTANCE_HOUR = "DISTANCEHOUR";

  static String defaultCountryCode = "+91";
}

class CheckStatus {
  static String EMPTY = "EMPTY";
  static String SEARCHING = "SEARCHING";
  static String ACCEPTED = "ACCEPTED";
  static String STARTED = "STARTED";
  static String ARRIVED = "ARRIVED";
  static String PICKEDUP = "PICKEDUP";
  static String DROPPED = "DROPPED";
  static String COMPLETED = "COMPLETED";
  static String PATCH = "PATCH";
}
