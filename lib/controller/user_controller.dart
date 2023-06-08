import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/api/api_service.dart';
import 'package:mozlit_driver/controller/base_controller.dart';
import 'package:mozlit_driver/enum/user_module_type.dart';
import 'package:mozlit_driver/model/charging_station_cal_distance_model.dart';
import 'package:mozlit_driver/model/charging_station_model.dart';
import 'package:mozlit_driver/model/document_model.dart';
import 'package:mozlit_driver/model/earning_model.dart';
import 'package:mozlit_driver/model/help_response_model.dart';
import 'package:mozlit_driver/model/login_otp_reponse_model.dart';
import 'package:mozlit_driver/model/login_response_model.dart';
import 'package:mozlit_driver/model/notification_manager_model.dart';
import 'package:mozlit_driver/model/service_type_model.dart';
import 'package:mozlit_driver/model/summery_model.dart';
import 'package:mozlit_driver/model/user_detail_model.dart';
import 'package:mozlit_driver/model/wallet_balance_model.dart';
import 'package:mozlit_driver/ui/authentication_screen/forgot_password.dart';
import 'package:mozlit_driver/ui/authentication_screen/login_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/otp_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/phone_number_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/profile_number_otp_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_in_up_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/vehicle_sign_up_screen.dart';
import 'package:mozlit_driver/ui/home_screen.dart';
import 'package:mozlit_driver/ui/splash_screen.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/util/common.dart';
import 'package:mozlit_driver/util/user_details.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/authentication_screen/bothOtp_screen.dart';
import 'home_controller.dart';

class UserController extends BaseController {
  RxBool isShowLogin = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carCompanyNameController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController
  carNumberController = TextEditingController();
  TextEditingController carServiceController = TextEditingController();
  TextEditingController refCodeController = TextEditingController();
  TextEditingController userFeedbackController = TextEditingController();
  TextEditingController transferAmountController = TextEditingController();
  TextEditingController breakDownController = TextEditingController();
  TextEditingController giveFeedbackTitleController = TextEditingController();
  TextEditingController giveFeedbackDescriptionController =
  TextEditingController();
  String countryCode = "+961";
  RxInt selectedLanguage = 0.obs;
  Rx<SummeryModel> summeryModel = SummeryModel().obs;
  Rx<LoginResponseModel> userToken = LoginResponseModel().obs;
  Rx<UserDetailModel> userData = UserDetailModel().obs;
  RxInt currentCarouselSliderPosition = 0.obs;
  final UserDetails _userDetails = UserDetails();
  RxList<NotificationManagerModel> notificationManagerList =
      <NotificationManagerModel>[].obs;
  RxList<WalletTransation> walletTransaction = <WalletTransation>[].obs;
  Rx<ChargingStationModel> chargingStationModel = ChargingStationModel().obs;
  Rx<EarningModel> earningModel = EarningModel().obs;
  Rx<HelpResponseModel> helpResponseModel = HelpResponseModel().obs;
  Rx<WalletBalanceModel> walletTransationModel = WalletBalanceModel().obs;

  String? imageFilePah;
  //ServiceType? serviceType;
  ServiceType? taxiServiceType;
  ServiceType? deliveryServiceType;
  RxList<ServiceType> serviceTypeList = <ServiceType>[].obs;
  RxList<ServiceType> serviceTypeList1 = <ServiceType>[].obs;
  RxBool chkTerms = false.obs;
  RxList<Document> documentList = <Document>[].obs;
  String type = 'provider';
  List transactionWalletList = [].obs;
  Rx<UserModuleType> selectedUserModuleType = UserModuleType.TAXI.obs;
  // List<ChargingStationCalDistanceModel> calDistance = [];
  // List<ChargingStationCalDistanceModel> totalList = [];

  @override
  void onReady() {
    super.onReady();
    // getLocation();
  }

  @override
  void onInit() {
    super.onInit();
    _userDetails.getSaveUserModuleType.then((data) {
      selectedUserModuleType.value = data;
    });
    if (_userDetails.getSaveUserDetails != null) {
      _userDetails.getSaveUserDetails.then((value) {
        log("userTokenAccess ====>   ${value.toJson()}");
        print("userTokenAccess ====>   ${value.toJson()}");
        userToken.value = value;
        setLanguage();
      });
      userToken.listen((data) {
        _userDetails.saveUserDetails(data);
      });
      selectedUserModuleType.listen((data) {
        _userDetails.saveUserModuleType(data);
      });

      getSaveLanguages.then((value) {
        log("selectedLanguage ==================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $value");
        selectedLanguage.value = value;
        setLanguage();
        log("After ==================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${selectedLanguage.value}");
      });

      selectedLanguage.listen((data) {
        saveLanguage(data);
      });
    }
  }

  Future<int> get getSaveLanguages async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? language = sharedPreferences.getInt("languages");
    log("message  ================================================================>  $language");
    return language ?? 0;
  }

  Future<void> saveLanguage(int selectedLanguage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt("languages", selectedLanguage);
  }

  Future<void> forgotPassword() async {
    removeUnFocusManager();
    if (emailController.text.isEmpty) {
      showError(msg: "Please enter your email address..");
      return;
    }

    try {
      showLoader();
      Map<String, dynamic> params = Map();
      params["email"] = emailController.text;

      await apiService.postRequest(
          url: ApiUrl.forgotPassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            print(data);
            showSnack(msg: data["response"]["message"]);
            Get.to(() => ForgotPassword(
                  response: data["response"],
                ));
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      await apiService.postRequest(
          url: ApiUrl.resetPassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            clearFormData();
            Get.back();
            showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser() async {
    removeUnFocusManager();

    try {
      if (phoneNumberController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter phone number",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your first name");
        return;
      }
      if (passwordController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter password",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your first name");
        return;
      }
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["password"] = passwordController.text;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["grant_type"] = "password";
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["client_secret"] = ApiUrl.clientSecret;
      params["client_id"] = ApiUrl.clientId;
      //params["email"] = emailController.text;
      params["mobile"] = phoneNumberController.text;
      params["userLiveLocation"] = userLiveLocation;
      params["device_name"] = deviceName;
      params["device_model"] = deviceModelNumber;
      params["device_manufacturer"] = deviceManufacture;

      await apiService.postRequest(
          url: ApiUrl.login,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithGoogle(
      {required String accessToken, Map<String, dynamic>? data}) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "google";
      params["accessToken"] = "$accessToken";
      params["mobile"] = "";
      params["country_code"] = "";
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
          url: ApiUrl.googleLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params));
            } else {
              showError(msg: msg);
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithApple(
      {required String socialUniqueId, Map<String, dynamic>? data}) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "apple";
      params["social_unique_id"] = "$socialUniqueId";
      params["mobile"] = "";
      params["country_code"] = "";
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
          url: ApiUrl.appleLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params));
            } else {
              showError(msg: msg);
            }
          });
    } catch (e) {
      showError(msg: "$e");
      print(e);
    }
  }

  void setLanguage() {
    if (selectedLanguage.value == 0) {
      Get.updateLocale(Locale('en', 'US'));
    } else if (selectedLanguage.value == 1) {
      Get.updateLocale(Locale('ar', 'AE'));
    } else if (selectedLanguage.value == 2) {
      Get.updateLocale(Locale('hy', 'AM'));
    }
  }

  Future<void> sendOtp({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode;

      await apiService.postRequest(
          url: ApiUrl.sendOtp,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                () => OtpScreen(
                      params: params,
                    ),
                arguments: [phoneNumberController.text, countryCode]);
          },
          onError: (ErrorType errorType, String msg) {
            print('object12 ${msg}');
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> givenFeedback(String title, String description) async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["user_id"] = "${userData.value.id}";
      params["title"] = title;
      params["description"] = description;
      params["type"] = "driver";
      await apiService.postRequest(
          url: ApiUrl.giveFeedback,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            Get.back();
            Get.snackbar("Successfully", data["response"]["message"],
                backgroundColor: Colors.green, colorText: Colors.white);
            print("complete feedback");
            // userToken.value = LoginResponseModel();
            // userData.value = UserDetailModel();
            // await _userDetails.logoutUser();
            // // Get.offAll(() => SignInUpScreen());
            // Get.offAll(() => LoginScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }


  Future<void> sendBothOtp({required Map<String, dynamic> params}) async {
    removeUnFocusManager();
    print("object==>${phoneNumberController.text}");
    print("object==>${countryCode}");
    print("object==>${emailController.text}");
    try {
      showLoader();

      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode;
      //params["email"] = emailController.text.trim();

      await apiService.postRequest(
          url:ApiUrl.sendotpBoth,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            //params["email_otp"] = data["response"]["email_otp"];
            Get.to(
                () => BothOtpScreen(
                      params: params,
                    ),
                arguments: [
                  phoneNumberController.text,
                  countryCode,
                  emailController.text
                ]);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> verifyOTp(String otp) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumberController.text;
      params["otp"] = otp;
      params["device_token"] = token;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_type"] = ApiUrl.deviceType;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();

            // userToken.refresh();
            // getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyBothOTp(String otp, String emailOtp) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumberController.text;
      params["otp"] = otp;
      //params["email_otp"] = emailOtp;
      params["device_token"] = token;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_type"] = ApiUrl.deviceType;

      print('bodysss ${params}');

      await apiService.postRequest(
          url:
              ApiUrl.sendVerifyBothOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            print('verifyBothOTp succeed');
            //registerUser();
            dismissLoader();
            userToken.value = loginResponseModelFromJson(jsonEncode(data["response"]));
            print('check');
            userToken.refresh();
            getUserProfileData();
            Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyResendOTp(String otp, String phoneNumber) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();
      print("phoneNumber ===> $phoneNumber");
      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumber;
      params["otp"] = otp;
      params["device_token"] = token;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_type"] = ApiUrl.deviceType;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();

            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendProfileOtp() async {
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = Map();
      params["oldmobile"] = userData.value.mobile;
      params["newmobile"] = phoneNumberController.text;
      params["country_code"] = countryCode;
      await apiService.postRequest(
          url: ApiUrl.sendOTPProfile,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                    () => ProfileNumberOtpScreen(
                  params: params,
                ),
                arguments: [phoneNumberController.text, countryCode]);
          },
          onError: (ErrorType errorType, String msg) {
            print('object12 ${msg}');
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyProfileNumberOTP(String otp) async {
    removeUnFocusManager();

    try {
      showLoader();
      print("phoneNumber ===> ${userData.value.mobile}");
      Map<String, dynamic> params = Map();
      params["oldmobile"] = userData.value.mobile;
      params["newmobile"] = phoneNumberController.text;
      params["otp"] = otp;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTPProfile,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            updateProfile();
            // userToken.value = LoginResponseModel(
            //     accessToken: data["response"]["success"]["token"],
            //     tokenType: data["response"]["token_type"]);
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            // var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            // var tkn = a.success!.token;
            // print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            // userToken.refresh();
            // getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }


  Future<void> loginWithFacebook(
      {required String accessToken, Map<String, dynamic>? data}) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "facebook";
      params["accessToken"] = "${accessToken}";
      params["mobile"] = "";
      params["country_code"] = "";
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
          url: ApiUrl.facebookLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params));
            } else {
              showError(msg: msg);
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerUser() async {
    removeUnFocusManager();
    try {
      if (taxiServiceType == null) {
        showError(msg: "Please select service type..");
        return;
      }
      // if (deliveryServiceType == null) {
      //   showError(msg: "Please select service type..");
      //   return;
      // }
      // if (emailController.text.isEmpty) {
      //   showError(msg: "Please enter your Email address");
      //   return;
      // }
      // if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
      //     .hasMatch(emailController.text)) {
      //   showError(msg: "Please enter a valid email address");
      //   return;
      // }
      if (firstNameController.text.isEmpty) {
        showError(msg: "Please enter your first name");
        return;
      }
      if (lastNameController.text.isEmpty) {
        showError(msg: "Please enter your last name");
        return;
      }
      if (phoneNumberController.text.isEmpty) {
        showError(msg: "Please enter your mobile number");
        return;
      }
      if (countryCode == '+91' && phoneNumberController.text.length != 10) {
        showError(msg: "Please enter valid mobile number");
        return;
      }

      if (carModelController.text.isEmpty) {
        showError(msg: "Please enter your vehicle model");
        return;
      }

      if (carNumberController.text.isEmpty) {
        showError(msg: "Please enter your vehicle number");
        return;
      }
      if (carColorController.text.isEmpty) {
        showError(msg: "Please enter your vehicle color");
        return;
      }

      if (carCompanyNameController.text.isEmpty) {
        showError(msg: "Please enter your vehicle company name");
        return;
      }

      if (passwordController.text.length < 6) {
        showError(msg: "Password length must be between 6–15 characters.");
        return;
      }

      if (conPasswordController.text.isEmpty) {
        showError(msg: "Please enter confirm password");
        return;
      }

      if (conPasswordController.text != passwordController.text) {
        showError(msg: "Password should be same");
        return;
      }
      if (chkTerms.isFalse) {
        showError(msg: "Please Accept Terms and Conditions");
        return;
      }
      // if (!passwordController.text.contains((RegExp(r'[0-9]'))) ||
      //     !passwordController.text
      //         .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      //   Get.snackbar("Make strong password",
      //       "Password must be alphanumeric with special characters",
      //       backgroundColor: Colors.redAccent.withOpacity(0.8),
      //       colorText: Colors.white);
      //   return;
      // }
      // if(passwordController.text.contains((RegExp(r'[0-9]')))){
      //   if(passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      //     //cont.sendBothOtp(params: params);
      //   }else{
      //     Get.snackbar("Make strong password", "Password must be alphanumeric with special characters",
      //         backgroundColor: Colors.redAccent.withOpacity(0.8),
      //         colorText: Colors.white);
      //   }
      // }
      if (((phoneNumberController.text.length ==
          6 || phoneNumberController.text.length ==
          8 || phoneNumberController.text.length ==
          7) &&
          countryCode == '+961') || phoneNumberController.text.length ==
          10 && countryCode != '+961'){
        showLoader();

        String? token = await FirebaseMessaging.instance.getToken();
        Map<String, dynamic> params = Map();
        params["first_name"] = firstNameController.text.trim();
        params["last_name"] = lastNameController.text.trim();
        //params["email"] = emailController.text.trim();
        params["country_code"] = countryCode;
        params["mobile"] = phoneNumberController.text;
        params["password"] = passwordController.text;
        params["password_confirmation"] = conPasswordController.text;
        params["service_type"] = "${taxiServiceType?.id ?? 1}";
        params["delivery_service"] = "${deliveryServiceType?.id ?? 1}";
        params["service_model"] = carModelController.text;
        params["service_number"] = carNumberController.text;
        params["car_camp_name"] = carCompanyNameController.text;
        params["car_color"] = carColorController.text;
        params["device_id"] = "aa0cd79f26dd98b8";
        params["device_token"] = token;
        params["device_type"] = ApiUrl.deviceType;
        params["login_by"] = "manual";

        await apiService.postRequest(
          url: ApiUrl.signUp,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            sendBothOtp(params: params);
            // userToken.value =
            //     loginResponseModelFromJson(jsonEncode(data["response"]));
            // userToken.refresh();
            // getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          },
        );
        return;
      }
      Get.snackbar("Alert", "Please enter a valid mobile number",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    } catch (e) {
      print(e);
    }
  }
  Future<void> signUpDetailsUser() async {
    removeUnFocusManager();
    try {

      // if (emailController.text.isEmpty) {
      //   showError(msg: "Please enter your Email address");
      //   return;
      // }
      // if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
      //     .hasMatch(emailController.text)) {
      //   showError(msg: "Please enter a valid email address");
      //   return;
      // }
      if (firstNameController.text.isEmpty) {
        showError(msg: "Please enter your first name");
        return;
      }
      if (lastNameController.text.isEmpty) {
        showError(msg: "Please enter your last name");
        return;
      }
      if (phoneNumberController.text.isEmpty) {
        showError(msg: "Please enter your mobile number");
        return;
      }
      if (countryCode == '+91' && phoneNumberController.text.length != 10) {
        showError(msg: "Please enter valid mobile number");
        return;
      }

      if (passwordController.text.length < 6) {
        showError(msg: "Password length must be between 6–15 characters.");
        return;
      }

      if (conPasswordController.text.isEmpty) {
        showError(msg: "Please enter confirm password");
        return;
      }

      if (conPasswordController.text != passwordController.text) {
        showError(msg: "Password should be same");
        return;
      }

      // if (!passwordController.text.contains((RegExp(r'[0-9]'))) ||
      //     !passwordController.text
      //         .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      //   Get.snackbar("Make strong password",
      //       "Password must be alphanumeric with special characters",
      //       backgroundColor: Colors.redAccent.withOpacity(0.8),
      //       colorText: Colors.white);
      //   return;
      // }
      if (((phoneNumberController.text.length ==
          6 || phoneNumberController.text.length ==
          8) &&
          countryCode == '+961') || phoneNumberController.text.length ==
          10 && countryCode == '+91') {
        print('passed');
        Get.to(VehicleSignUpScreen());
        return;
      }
      Get.snackbar("Alert", "Please enter a valid mobile number",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserProfileData({bool isScreenChange = true}) async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.userDetails,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userData.value = UserDetailModel.fromJson(data["response"]);
            userData.refresh();
            if (isScreenChange) {
              Get.offAll(() => HomeScreen());
            }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
            userToken.value = LoginResponseModel();
            userToken.refresh();
            Get.offAll(() => SignInUpScreen(), predicate: (_) => true);
          });
    } catch (e) {
      log("message ===>   $e");
      dismissLoader();
      Get.offAll(() => SignInUpScreen(), predicate: (_) => true);
      // showError(msg: e.toString());
    }
  }


  Future<void> showPaymentSuccessDialog() async {
    return Get.defaultDialog(
        title: "Your payment is successfully added in your wallet".tr,
        titleStyle: TextStyle(
            fontSize: 17,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500),
        content: Image.asset(AppImage.paymentSuccess,width: 170,  height: 150,fit: BoxFit.contain,),
        actions: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              width: 130,
              // margin: EdgeInsets.symmetric(horizontal: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Text("OK".tr,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700)),
            ),
          ),

        ],
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        backgroundColor: AppColors.white);
  }

  Future<void> getUserPaymentProfileData({bool isScreenChange = true}) async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.userDetails,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            userData.value = UserDetailModel.fromJson(data["response"]);
            // Stripe.publishableKey = userData.value.stripePublishableKey ?? "";

            userData.refresh();
            log("message   ==>  ${jsonEncode(data)}");
            if (isScreenChange) {
              log("message andar chala jata he");
              Get.offAll(() => HomeScreen());
              showPaymentSuccessDialog();
            }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
            userToken.value = LoginResponseModel();
            userToken.refresh();
            Get.offAll(() => LoginScreen());
          });
    } catch (e) {
      log("message   ==>  ${e}");
      dismissLoader();
      Get.off(() => LoginScreen());
      // showError(msg: e.toString());
    }
  }

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // getCurrentLocation();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    print("latitude $latitude");
    print("longitude $longitude");
  }

  Future<void> getNotificationList() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.notifications,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            notificationManagerList.clear();
            List<NotificationManagerModel> tempNotificationList =
                notificationManagerModelFromJson(jsonEncode(data["response"]));
            notificationManagerList.addAll(tempNotificationList);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getWalletTransaction() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.walletTransaction,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            WalletBalanceModel walletBalanceModel =
                walletBalanceModelFromJson(jsonEncode(data["response"]));
            walletTransaction.clear();
            userData.value.walletBalance = walletBalanceModel.walletBalance;
            userData.refresh();
            walletTransaction.addAll(walletBalanceModel.walletTransation);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getEarning() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.target,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            earningModel.value =
                earningModelFromJson(jsonEncode(data["response"]));
            earningModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      HomeController _homeController = Get.find();
      showLoader();
      Map<String, dynamic> params = {};
      params["first_name"] = firstNameController.text;
      params["last_name"] = lastNameController.text;
      params["email"] = emailController.text;
      params["mobile"] = phoneNumberController.text;
      params["country_code"] = userData.value.countryCode ?? "";
      print("filePath===>${imageFilePah}");
      if (imageFilePah != null) {
        params["avatar"] = await dio.MultipartFile.fromFile(imageFilePah!);
      }
      log("message   ==>  $params");
      dio.FormData formData = new dio.FormData.fromMap(params);
      await apiService.postRequest(
          url: ApiUrl.userDetails,
          params: formData,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            _homeController.isCaptureImage.value = false;
            await getUserProfileData(isScreenChange: false);
            Get.back();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> changePassword() async {
    try {
      removeUnFocusManager();

      if (oldPasswordController.text.isEmpty) {
        showError(msg: "Please enter current password");
        return;
      }
      if (passwordController.text.isEmpty) {
        showError(msg: "Please enter password");
        return;
      }
      if (passwordController.text.length < 6) {
        showError(msg: "Password length must be between 6–15 characters.");
        return;
      }
      if (passwordController.text == oldPasswordController.text) {
        showError(msg: "Old and new password must be different");
        return;
      }
      if (conPasswordController.text.isEmpty) {
        showError(msg: "Please enter confirm password");
        return;
      }
      if (conPasswordController.text != passwordController.text) {
        showError(msg: "Password should be same");
        return;
      }
      showLoader();
      Map<String, dynamic> params = {};
      params["password_old"] = oldPasswordController.text;
      params["password"] = passwordController.text;
      params["password_confirmation"] = conPasswordController.text;

      await apiService.postRequest(
          url: ApiUrl.changePassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            showSnack(msg: data["response"]["message"]);
            // clearFormData();
            passwordController.text = "";
            conPasswordController.text = "";
            oldPasswordController.text = "";
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getHelp() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.help,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            helpResponseModel.value =
                helpResponseModelFromJson(jsonEncode(data["response"]));
            helpResponseModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $phoneNumber");
    }
  }

  Future<void> sendMail({required String mail}) async {
    try {
      final Email email = Email(
        recipients: [mail],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      showError(msg: "$e");
    }

    // Uri uri = Uri.parse("mailto:$mail");
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // } else {
    //   showError(msg: "Could not launch $mail");
    // }
  }

  Future<void> logout() async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["id"] = "${userData.value.id}";
      await apiService.postRequest(
          url: ApiUrl.logout,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            userToken.value = LoginResponseModel();
            userData.value = UserDetailModel();
            await _userDetails.logoutUser();
            Get.offAll(() => SignInUpScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> requestTransferAmount() async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["amount"] = int.parse(transferAmountController.text);
      params["type"] = type;
      print('params $params');
      await apiService.postRequest(
          url:
              ApiUrl.requestAmount,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            print('check succeed');
            print('ggggg $data');
            dismissLoader();
          },
          onError: (ErrorType errorType, String? msg) {
            print('check failed');
            print(params);
            dismissLoader();
            showError(
                msg: 'Wallet balance may be lesser than requested amount');
          });
    } catch (e) {
      log("message   ==>  $e");
      dismissLoader();
      showError(msg: e.toString());
      print('check failed in catch');
      // showError(msg: e.toString());
    }
  }

  Future<void> requestTransferAmountList() async {
    try {
      showLoader();
      await apiService.getRequest(
          url:
              ApiUrl.transferList,
          onSuccess: (Map<String, dynamic> data) async {
            print('check succeed');
            transactionWalletList.add(data);
            //print('list $transactionWalletList');
            dismissLoader();
          },
          onError: (ErrorType errorType, String? msg) {
            print('check failed');
            dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      dismissLoader();
      showError(msg: e.toString());
      print('check failed in catch');
      // showError(msg: e.toString());
    }
  }

  Future<void> requestTransferAmountCancel(id) async {
    try {
      showLoader();
      await apiService.getRequest(
          url:
              '${ApiUrl.requestsCancel}?id=$id',
          onSuccess: (Map<String, dynamic> data) async {
            print('check succeed');
            print('ggggg $data');
            dismissLoader();
          },
          onError: (ErrorType errorType, String? msg) {
            print('check failed');
            dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      dismissLoader();
      showError(msg: e.toString());
      print('check failed in catch');
      // showError(msg: e.toString());
    }
  }

  Future<void> getServiceType() async {
    try {
      showLoader();

      await apiService.getRequest(
          url: ApiUrl.settings,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            serviceTypeList.clear();
            serviceTypeList1.clear();
            taxiServiceType = null;
            deliveryServiceType = null;
            ServiceTypeModel serviceTypeModel =
                serviceTypeModelFromJson(jsonEncode(data["response"]));
            //serviceTypeList.addAll(serviceTypeModel.serviceTypes);
            var deliveryservice = serviceTypeModel.serviceTypes
                .where((o) => o.moduletype == "DELIVERY")
                .toList();
            var texiservice = serviceTypeModel.serviceTypes
                .where((o) => o.moduletype == "TAXI")
                .toList();
            // print("deliveryserviceList     $deliveryserviceList");
            // print("texiserviceList     $texiserviceList");
            serviceTypeList.addAll(deliveryservice);
            serviceTypeList1.addAll(texiservice);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getDocument() async {
    try {
      showLoader();

      await apiService.getRequest(
          url: ApiUrl.documents,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            documentList.clear();
            DocumentModel documentModel =
                documentModelFromJson(jsonEncode(data["response"]));
            documentList.addAll(documentModel.documents);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> uploadSignUpDocument() async {
    List<Document> tempDocument = [];
    documentList.forEach((element) {
      if (element.imagePath != null) {
        tempDocument.add(element);
      }
    });
    if (tempDocument.isEmpty) {
      showError(msg: "Change any document and submit");
      return;
    }
    Map<String, dynamic> params = {};
    int count = 0;
    List<String> idList = [];
    List<dio.MultipartFile> fileList = [];
    for (int i = 0; i < tempDocument.length; i++) {
      Document document = tempDocument[i];
      idList.add("${document.id}");
      fileList.add(await dio.MultipartFile.fromFile(document.imagePath!));

      count++;
    }
    params["id[]"] = idList;
    params["document[]"] = fileList;
    try {
      showLoader();
      log("Params ===>   ${params}");
      dio.FormData formData = new dio.FormData.fromMap(params);
      await apiService.postRequest(
          url: ApiUrl.documentsUpload,
          params: formData,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.offAll(HomeScreen());
                      // Get.back();
                      showSnack(title: "Message", msg: "Document Upload Successfully!");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }


  Future<void> uploadDocument({documentId, documentImagePath}) async {
    // List<Document> tempDocument = [];
    // documentList.forEach((element) {
    //   if (element.imagePath != null) {
    //     tempDocument.add(element);
    //   }
    // });
    // if (tempDocument.isEmpty) {
    //   showError(msg: "Change any document and submit");
    //   return;
    // }
    Map<String, dynamic> params = {};
    // int count = 0;
    // List<String> idList = [];
    // List<dio.MultipartFile> fileList = [];
    // for (int i = 0; i < tempDocument.length; i++) {
    //   Document document = tempDocument[i];
    //   idList.add("${document.id}");
    //   print("document.imagePath==> ${document.imagePath}");
    //   fileList.add(await dio.MultipartFile.fromFile(document.imagePath!));

    // try {
    //   showLoader();
    //   params["id"] = document.id;
    //   params["document"] = await dio.MultipartFile.fromFile(document.imagePath!);
    //   log("Params ===>   ${params}");
    //   dio.FormData formData = new dio.FormData.fromMap(params);
    //   await apiService.postRequest(
    //       url: ApiUrl.documentsUpload,
    //       params: formData,
    //       onSuccess: (Map<String, dynamic> data) async {},
    //       onError: (ErrorType errorType, String? msg) {
    //         showError(msg: msg);
    //       });
    // } catch (e) {
    //   log("message   ==>  $e");
    //   showError(msg: e.toString());
    //   // showError(msg: e.toString());
    // }

    //   count++;
    // }
    params["id[]"] = documentId;
    params["document[]"] = await dio.MultipartFile.fromFile(documentImagePath);

    // params["id[]"] = idList;
    // params["document[]"] = fileList;
    try {
      showLoader();
      log("Params ===>   ${params}");
      dio.FormData formData = new dio.FormData.fromMap(params);
      print("fromdatatatata===> ${dio.FormData.fromMap(params)}");
      print("fromdatatatata===> ${formData.files.first}");
      print("fromdatatatata===> ${formData.fields}");
      await apiService.postRequest(
          url: ApiUrl.documentsUpload,
          params: formData,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.offAll(HomeScreen());
            // Get.back();
            showSnack(title: "Message", msg: "Document Upload Successfully!");
          },
          onError: (ErrorType errorType, String? msg) {
            print("errorType==> $errorType");
            print("errorType==> $msg");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  $e");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = userData.value.id;
      await apiService.postRequest(
          url: ApiUrl.deleteAccount,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            await logout();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getChargingStation({String? liveLat,String?  liveLong}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["latitude"] = liveLat;
      params["longitude"] = liveLong;
      await apiService.postRequest(
          url: ApiUrl.chargingStation,
         params: params,
          onSuccess: (Map<String, dynamic> data) {
            // totalList.clear();
            dismissLoader();
            print("chargingStationModel.value====>${data["response"]}");
            chargingStationModel.value = ChargingStationModel.fromJson(data["response"]);
            // for (int i = 0;
            // i <=
            //     chargingStationModel.value.chargingStation!.length -
            //         1;
            // i++) {
            //   print("cccc==>${homeController.userCurrentLocation!.latitude}");
            //   print("cccc==>${homeController.userCurrentLocation!.longitude}");
            //    calDistance.add(ChargingStationCalDistanceModel(
            //       chargingStationAddress:
            //           chargingStationModel.value.chargingStation![i].address,
            //       chargingStationCall: chargingStationModel.value.chargingStation![i].phone,
            //       chargingStationDistance: calculateDistance(
            //           homeController.userCurrentLocation!.latitude,
            //           homeController.userCurrentLocation!.longitude,
            //           double.parse(chargingStationModel.value.chargingStation![i].latitude!),
            //           double.parse(chargingStationModel.value.chargingStation![i].longitude!)),
            //       chargingStationLat: chargingStationModel.value.chargingStation![i].latitude,
            //       chargingStationLong: chargingStationModel.value.chargingStation![i].longitude,
            //       chargingStationName: chargingStationModel.value.chargingStation![i].name));
            //
            //   // totalList.add({double.parse(calDistance[i].chargingStationDistance.toString()):calDistance[i]});
            //   totalList.add(calDistance[i]);
            // }
            // totalList.sort((a, b) => a.chargingStationDistance!.ceilToDouble().compareTo(b.chargingStationDistance!.ceilToDouble()));
            // print("totalList===>${totalList.first.chargingStationDistance}");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  void clearFormData() {
    taxiServiceType = null;
    deliveryServiceType = null;
    chkTerms.value = false;
    emailController.text = "";
    firstNameController.text = "";
    lastNameController.text = "";
    phoneNumberController.text = "";
    passwordController.text = "";
    conPasswordController.text = "";
    oldPasswordController.text = "";
    otpController.text = "";
    carModelController.clear();
    carNumberController.clear();
    carServiceController.clear();
    countryCode = "+961";
  }

  Future<void> getSummery({String? providerId, String? filter}) async {
    print("providerId==> ${providerId}");
    print("providerId==> ${filter}");
    UserController userController = UserController();
    try {
      showLoader();
      await apiService.getRequest(
          url: "${ApiUrl.summary}?provider_id=$providerId&filter=$filter",
          // params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            summeryModel.value =
                summeryModelFromJson(jsonEncode(data["response"]));
            print("summeryModel.value===>${summeryModel.value}");
            summeryModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            print("msg===> ${msg}");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> updateUserModuleType(
      {required UserModuleType userModuleType}) async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["provider_id"] = "${userData.value.id ?? "0"}";
      params["active_module"] = "${userModuleType.name}";
      await apiService.postRequest(
          url: ApiUrl.selectModuleType,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            // if(data["response"]["message"].toString().toLowerCase() == "true"){
            selectedUserModuleType.value = userModuleType;
            await getUserProfileData(isScreenChange: false);
            // }
            // summeryModel.value =
            //     summeryModelFromJson(jsonEncode(data["response"]));
            // summeryModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }
}
