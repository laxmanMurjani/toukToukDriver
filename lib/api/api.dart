import 'dart:io';

class ApiUrl {
  static const String _baseUrl = 'https://demo.mozilit.com/superAdminLogin/touk_touktaxi/public';
      //'https://demo.mozilit.com/superAdminLogin/mozilit_official/public';
      //'https://etoride.etomotors.com';
  // static const String _baseUrl = 'https://demo.mozilit.com/superAdminLogin/eto_taxi/public';
  static const String baseImageUrl = _baseUrl+"/";
  // static const String baseImageUrl = "https://demo.mozilit.com/superAdminLogin/eto_taxi/public/";
  static const String BASE_URL = _baseUrl;
  static const String termsCondition = "$BASE_URL/terms";
  static const String privacyPolicy = "$BASE_URL/terms";

  static const String _apiBaseUrl = '$_baseUrl/api/provider';

  // static const String clientId = "5";
  // static const String clientSecret = "Fg7SAg4540H9dQ0WagKh49Lg9QL1q2JLPowN4bfe";

  static const String clientId = '10';
      //'2';
      //"8";
  static const String clientSecret = 'fXOAp7eIRbVaTPqix3SLaP49TH6j7o0ZWhy0NTJP';
      //'aemt5ueZUibxOBkg8V8INBG4zO3MoUF57Nj6emUn';
      //"Jh7SzC3gpIyByyHgJ3liNp24RAfWjzNx2L4EdbKb";

  static String deviceType = Platform.isAndroid ? "android" : "ios";
  static String disputeList = "$_apiBaseUrl/dispute-list";
  static String sendOTPProfile = "$_apiBaseUrl/sendotp_profile";
  static String verifyOTPProfile = "$_apiBaseUrl/otp_verified_for_profile_update";
  static String requestAmount = "$_apiBaseUrl/requestamount";
  static String giveFeedback = "$_apiBaseUrl/ticketcreate";
  static String transferList = "$_apiBaseUrl/transferlist";
  static String requestsCancel = "$_apiBaseUrl/requestcancel";
  static String dispute = "$_apiBaseUrl/dispute";
  static String estimatedFare = "$_apiBaseUrl/estimated/fare";
  static String sendUSerNewRequest = "$_apiBaseUrl/send/request";
  static String breakdownUSerNewRide = "$_apiBaseUrl/get-breakdown-trip";
  static String signUp = "$_apiBaseUrl/register";
  static String chargingStation = "$_apiBaseUrl/charging/stations";
  static String login = "$_apiBaseUrl/oauth/token";
  static String googleLogin = "$_apiBaseUrl/auth/google";
  static String facebookLogin = "$_apiBaseUrl/auth/facebook";
  static String appleLogin = "$_apiBaseUrl/auth/apple";
  static String sendOtp = "$_apiBaseUrl/sendotp";
  static String sendotpBoth = "$_apiBaseUrl/sendotp_both";
  static String verifyOTP = "$_apiBaseUrl/otp_verified";
  static String sendVerifyBothOTP = "$_apiBaseUrl/otp_verified_both";
  static String userDetails = "$_apiBaseUrl/profile";
  static String changePassword = "$_apiBaseUrl/profile/password";
  static String forgotPassword = "$_apiBaseUrl/forgot/password";
  static String resetPassword = "$_apiBaseUrl/reset/password";
  static String getTrip = "$_apiBaseUrl/trip";
  static String endBreakDown = "$_apiBaseUrl/end-breakdown-ride";
  static String waiting = "$_apiBaseUrl/waiting";
  static String multiDestination = "$_apiBaseUrl/multidestination";
  static String tripDetails = "$_apiBaseUrl/trip/details";
  static String history = "$_apiBaseUrl/requests/history";
  static String instantRide = "$_apiBaseUrl/requests/instant/ride";
  static String details = "$_apiBaseUrl/requests/history/details";
  static String notifications = "$_apiBaseUrl/notifications/provider";
  static String walletTransaction = "$_apiBaseUrl/wallettransaction";
  static String target = "$_apiBaseUrl/target";
  // static String summary = "$_apiBaseUrl/summary";
  static String summary = "$_apiBaseUrl/statement/range";
  static String help = "$_apiBaseUrl/help";
  static String fareWithOutAuth =
      "$_baseUrl/api/user/estimated/fare_without_auth";
  static String logout = "$_apiBaseUrl/logout";
  static String settings = "$_apiBaseUrl/settings";
  static String available = "$_apiBaseUrl/profile/available";
  static String documents = "$_apiBaseUrl/profile/documents";
  static String documentsUpload = "$_apiBaseUrl/profile/documents/store";
  static String requestCancel = "$_apiBaseUrl/cancel";
  static String reasons = "$_apiBaseUrl/reasons";
  static String deleteAccount = "$_apiBaseUrl/delete/account";
  static String selectModuleType = "$_apiBaseUrl/profile/servicetype/module";

  static String tripRate({required String requestId}) =>
      "$_apiBaseUrl/trip/$requestId/rate";
}
