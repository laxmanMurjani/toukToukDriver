import 'dart:io';

class ApiUrl {
  static  String?  baseUrlLebanon;
  static  String?  baseUrlNigeria;
  static  String?  baseUrl;
  // static  String? baseUrl = "https://demo.mozilit.com/superAdminLogin/touk_touktaxi/public";
      // 'https://demo.mozilit.com/superAdminLogin/touk_touktaxi/public';

  // static  String baseImageUrl = baseUrl!+"/";
  // static const String baseImageUrl = "https://demo.mozilit.com/superAdminLogin/eto_taxi/public/";
  static  String BASE_URL = baseUrl!;
  static  String termsCondition = "/terms";
  static  String privacyPolicy = "/terms";

  // static  String _apiBaseUrl = '${baseUrl!}/api/provider';

  // static const String clientId = "5";
  // static const String clientSecret = "Fg7SAg4540H9dQ0WagKh49Lg9QL1q2JLPowN4bfe";

  static const String clientId = '10';
      //'2';
      //"8";
  static const String clientSecret = 'fXOAp7eIRbVaTPqix3SLaP49TH6j7o0ZWhy0NTJP';
      //'aemt5ueZUibxOBkg8V8INBG4zO3MoUF57Nj6emUn';
      //"Jh7SzC3gpIyByyHgJ3liNp24RAfWjzNx2L4EdbKb";

  static String deviceType = Platform.isAndroid ? "android" : "ios";
  static String updateLocation = "/update-provider-location";
  static String disputeList = "/dispute-list";
  static String sendOTPProfile = "/sendotp_profile";
  static String verifyOTPProfile = "/otp_verified_for_profile_update";
  static String requestAmount = "/requestamount";
  static String giveFeedback = "/ticketcreate";
  static String transferList = "/transferlist";
  static String requestsCancel = "/requestcancel";
  static String dispute = "/dispute";
  static String estimatedFare = "/estimated/fare";
  static String sendUSerNewRequest = "/send/request";
  static String breakdownUSerNewRide = "/get-breakdown-trip";
  static String signUp = "/register";
  static String chargingStation = "/charging/stations";
  static String login = "/oauth/token";
  static String googleLogin = "/auth/google";
  static String facebookLogin = "/auth/facebook";
  static String appleLogin = "/auth/apple";
  static String sendOtp = "/sendotp";
  static String sendotpBoth = "/sendotp_both";
  static String verifyOTP = "/otp_verified";
  static String sendVerifyBothOTP = "/otp_verified_both";
  static String userDetails = "/profile";
  static String changePassword = "/profile/password";
  static String forgotPassword = "/forgot/password";
  static String resetPassword = "/reset/password";
  static String getTrip = "/trip";
  static String endBreakDown = "/end-breakdown-ride";
  static String waiting = "/waiting";
  static String multiDestination = "/multidestination";
  static String tripDetails = "/trip/details";
  static String history = "/requests/history";
  static String instantRide = "/requests/instant/ride";
  static String details = "/requests/history/details";
  static String notifications = "/notifications/provider";
  static String walletTransaction = "/wallettransaction";
  static String target = "/target";
  // static String summary = "/summary";
  static String summary = "/statement/range";
  static String help = "/help";
  static String fareWithOutAuth =
      "$baseUrl/api/user/estimated/fare_without_auth";
  static String logout = "/logout";
  static String settings = "/settings";
  static String available = "/profile/available";
  static String documents = "/profile/documents";
  static String documentsUpload = "/profile/documents/store";
  static String requestCancel = "/cancel";
  static String reasons = "/reasons";
  static String deleteAccount = "/delete/account";
  static String selectModuleType = "/profile/servicetype/module";
  static String ringTone = "/incoming_ring";
  static String chooseServiceType = "/profile/servicetype/module";

  static String tripRate({required String requestId}) =>
      "${ApiUrl.baseUrl}/trip/$requestId/rate";
}
