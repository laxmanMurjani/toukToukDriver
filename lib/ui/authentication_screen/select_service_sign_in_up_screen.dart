import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/preference/preference.dart';
import 'package:mozlit_driver/ui/authentication_screen/login_otp_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/login_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_up_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SelectServiceSignInUpScreen extends StatefulWidget {
  const SelectServiceSignInUpScreen({Key? key}) : super(key: key);

  @override
  State<SelectServiceSignInUpScreen> createState() => _SelectServiceSignInUpScreenState();
}

class _SelectServiceSignInUpScreenState extends State<SelectServiceSignInUpScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find();
  CarouselController? controller;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly'
    ],
    signInOption: SignInOption.standard,
    // clientId: AppString.googleSignInServerClientId,
    // hostedDomain: "predictive-host-314811.firebaseapp.com"
  );

  @override
  void initState() {
    super.initState();
    _userController.clearFormData();
    _userController.isShowLogin.value = false;
    _userController.currentCarouselSliderPosition.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      print(
          "prefs.containsKey(Database.seenOnBoarding)===>${prefs.containsKey(Database.seenOnBoarding)}");
      if (!prefs.containsKey(Database.seenOnBoarding)) {
        _showDialog();
      }
    });
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(
              "Touk Touk Driver would like to collect location data to enable your current location to provide you the service for taxi booking and navigation even when the app is closed or not in use.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Database.setSeenLocationAlertDialog();
                    Get.back();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (_userController.isShowLogin.value) {
          _userController.isShowLogin.value = false;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomInset: false,
          body: Stack(
            children: [

              Stack(
                alignment: Alignment.bottomCenter,
                children: [

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: _size.height ,
                      color: Colors.black,
                      // child: Image.asset(
                      //   AppImage.loginBackground,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset(
                        AppImage.logoT,
                        width: _size.width * 0.4,
                        height: _size.height * 0.4,
                        // fit: BoxFit.contain,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                              width: double.infinity,alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height*0.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(40.w))),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  CustomButton(
                                      text: "To Driver".tr,
                                      bgColor: Colors.white,
                                      textColor: Colors.black,
                                      onTap: () {
                                        Get.to(() => SignUpScreen(isDriver: true,));
                                        // _showLoginScreen();
                                        // cont.isShowLogin.value = true;
                                      }),
                                  SizedBox(height: 15.h),
                                  Text("or", textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16
                                  ),),
                                  SizedBox(height: 15.h),
                                  CustomButton(
                                    onTap: () {
                                      Get.to(() => SignUpScreen(isDriver: false,));
                                    },
                                    text: "Road Side Servicemen".tr,
                                  ),
                                  SizedBox(height: 40.h),
                                ],
                              ),
                            )

                        ],
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        AppImage.building,
                        color: Colors.black.withOpacity(0.15),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedDot() {
    return Container(
      width: 15.w,
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 5.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(5.w),
      ),
    );
  }

  Widget _unSelectedDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 5.w,
      height: 5.w,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(5.w),
      ),
    );
  }

  void _showLoginScreen() {
    showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LoginOtpScreen();
        });
  }

  Future<void> _faceBookLogin() async {
    try {
      AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      // await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();

      switch (result.status) {
        case LoginStatus.success:
          // final AuthCredential? facebookCredential =
          // FacebookAuthProvider.credential(result.accessToken.token);
          // final userCredential =
          //     await _auth.signInWithCredential(facebookCredential);
          // Map<String, String> params = {};
          // params["name"] = "${userCredential.user.displayName}";
          // params["email"] = "${userCredential.user.email}";
          // params["so_id"] = "${userCredential.user.uid}";
          // params["so_platform"] = "FACEBOOK";
          // log("messageFacebook    ==>   ${userCredential.user.email}   ${userCredential.user.displayName}   ${userCredential.user.phoneNumber}  ${userCredential.user.photoURL}  ${userCredential.user.uid}");
          // _socialLogin(params: params);
          _userController.loginWithFacebook(
              accessToken: "${result.accessToken?.token ?? ""}");
          break;

        case LoginStatus.failed:
          _userController.showError(msg: result.message ?? "");
          break;
        case LoginStatus.cancelled:
          _userController.showError(msg: result.message ?? "");
          break;
        default:
          return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: 'example-nonce',
        state: 'example-state',
      );

      log("Apple Login ==>  ${credential.userIdentifier}    ${credential.email}   ${credential.authorizationCode}");
      _userController.loginWithApple(
          socialUniqueId: credential.userIdentifier ?? "");
    } on SignInWithAppleAuthorizationException catch (e) {
      _userController.showError(msg: "${e.message}");
    } catch (e) {
      _userController.showError(msg: "$e");
    }
  }

  Future<void> _googleLogin() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    GoogleSignInAccount? _googleSignAccount = await _googleSignIn.signIn();

    if (_googleSignAccount != null) {
      GoogleSignInAuthentication? googleSignInAuthentication =
          await _googleSignAccount.authentication;

      _userController.loginWithGoogle(
          accessToken: googleSignInAuthentication.accessToken ?? "");
    }
  }
}
