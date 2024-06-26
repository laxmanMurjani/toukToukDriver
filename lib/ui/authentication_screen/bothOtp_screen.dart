import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../home_screen.dart';

class BothOtpScreen extends StatefulWidget {
  Map<String, dynamic> params;
  BothOtpScreen({required this.params});
  //const BothOtpScreen({Key? key}) : super(key: key);

  @override
  State<BothOtpScreen> createState() => _BothOtpScreenState();
}

class _BothOtpScreenState extends State<BothOtpScreen> {
  String _otp = "";
  String emailOtp = "";
  final phoneNumber = Get.arguments[0];
  final countryCode = Get.arguments[1];
  bool isResendOtp = false;

  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;
  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "verification_code".tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: GetX<UserController>(builder: (cont) {
          if ((cont.error.value.errorType == ErrorType.internet)) {
            return NoInternetWidget();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Please_type_the_verification_code_sent_to_your".tr,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'mobile_number'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // animationType: AnimationType.fade,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                boxShadows: [BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),],
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    borderWidth: 1,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    activeColor: AppColors.white,
                    disabledColor: AppColors.white,
                    errorBorderColor: Colors.red,
                    inactiveColor: AppColors.white,
                    selectedColor: AppColors.white,
                    selectedFillColor: AppColors.white,
                    inactiveFillColor: AppColors.white
                ),
                // animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,

                onCompleted: (v) {
                  print("Completed===>${v}");
                  _otp = v;
                  print("value00===>${_otp}");
                },
                onChanged: (value) {
                  print("value===>${value}");
                  _otp = value;
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              // OtpTextField(
              //   numberOfFields: 4,
              //   borderColor: AppColors.primaryColor,
              //   showFieldAsBox: true,
              //   fillColor: Colors.white,
              //   enabledBorderColor: AppColors.primaryColor,
              //   focusedBorderColor: AppColors.primaryColor,
              //   disabledBorderColor: AppColors.gray,
              //   autoFocus: true,
              //   //runs when a code is typed in
              //   onCodeChanged: (String code) {
              //     //handle validation or checks here
              //     _otp = code;
              //   },
              //   //runs when every textfield is filled
              //   onSubmit: (String verificationCode) {
              //     _otp = verificationCode;
              //     print("object  ==>  $_otp");
              //   }, // end onSubmit
              // ),
              SizedBox(height: 20.h),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //     text: "Please_type_the_verification_code_sent_to_your".tr,
              //     style: TextStyle(color: Colors.black, fontSize: 18),
              //     children: <TextSpan>[
              //       TextSpan(
              //           text: 'your_email'.tr,
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold)),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20.h),
              // PinCodeTextField(
              //   appContext: context,
              //   length: 6,
              //   obscureText: false,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   // animationType: AnimationType.fade,
              //   enableActiveFill: true,
              //   keyboardType: TextInputType.number,
              //   boxShadows: [BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 5,
              //     blurRadius: 7,
              //     offset: Offset(0, 3), // changes position of shadow
              //   ),],
              //   pinTheme: PinTheme(
              //       shape: PinCodeFieldShape.box,
              //       borderRadius: BorderRadius.circular(5),
              //       fieldHeight: 50,
              //       borderWidth: 1,
              //       fieldWidth: 50,
              //       activeFillColor: Colors.white,
              //       activeColor: AppColors.white,
              //       disabledColor: AppColors.white,
              //       errorBorderColor: Colors.red,
              //       inactiveColor: AppColors.white,
              //       selectedColor: AppColors.white,
              //       selectedFillColor: AppColors.white,
              //       inactiveFillColor: AppColors.white
              //   ),
              //   // animationDuration: Duration(milliseconds: 300),
              //   backgroundColor: Colors.transparent,
              //
              //   onCompleted: (v) {
              //     print("Completed===>${v}");
              //     emailOtp = v;
              //     print("value00===>${_otp}");
              //   },
              //   onChanged: (value) {
              //     print("value===>${value}");
              //     emailOtp = value;
              //   },
              //   beforeTextPaste: (text) {
              //     print("Allowing to paste $text");
              //     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //     //but you can show anything you want here, like your pop up saying wrong paste format or etc
              //     return true;
              //   },
              // ),
              // OtpTextField(
              //   numberOfFields: 6,
              //   borderColor: AppColors.primaryColor,
              //   showFieldAsBox: true,
              //   fillColor: Colors.white,
              //   enabledBorderColor: AppColors.primaryColor,
              //   focusedBorderColor: AppColors.primaryColor,
              //   disabledBorderColor: AppColors.gray,
              //   autoFocus: true,
              //   //runs when a code is typed in
              //   onCodeChanged: (String code) {
              //     //handle validation or checks here
              //     emailOtp = code;
              //   },
              //   //runs when every textfield is filled
              //   onSubmit: (String verificationCode) {
              //     emailOtp = verificationCode;
              //     print("object  ==>  $emailOtp");
              //   }, // end onSubmit
              // ),
              SizedBox(height: 20.h),
              CustomButton(
                text: "continue".tr,
                onTap: () async {
                  if (_otp.length != 4
                      //|| emailOtp.length != 6
                  ) {
                    print("enter 1");
                    cont.showError(msg: "please_enter_otp".tr);
                    return;
                  }
                  if (!isResendOtp) {
                    if (_otp != widget.params["otp"].toString()
                        //|| emailOtp != widget.params["email_otp"].toString()
                    ) {
                      // print(widget.params["otp"].toString());
                      // print(widget.params["email_otp"].toString());
                      // print(_otp);
                      // print(emailOtp);
                      print("enter 2");
                      cont.showError(msg: "Please enter valid otp");
                      return;
                    }
                  }

                  if (widget.params["login_by"] == "facebook") {
                    print("enter 3");
                    cont.loginWithFacebook(
                        accessToken: "", data: widget.params);
                  } else if (widget.params["login_by"] == "google") {
                    print("enter 4");
                    cont.loginWithGoogle(accessToken: "", data: widget.params);
                  } else if (widget.params["login_by"] == "apple") {
                    print("enter 5");
                    cont.loginWithApple(
                        socialUniqueId: "", data: widget.params);
                  }
                  if (isResendOtp) {
                    await cont.verifyResendOTp(_otp, phoneNumber);
                    setState(() {
                      isResendOtp = false;
                    });
                  } else {
                    // print(_otp);
                    // print(emailOtp);
                    cont.verifyBothOTp(_otp, emailOtp);
                  }
                },
                fontSize: 16.sp,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("did_get_the_OTP".tr,
                      style: TextStyle(
                        color: AppColors.drawer.withOpacity(0.8),
                      )),
                  InkWell(
                    onTap: () async {
                      _resendCode();
                      setState(() {
                        isResendOtp = true;
                      });
                      Map<String, dynamic> params = {};
                      params["mobile"] = phoneNumber;
                      params["country_code"] = countryCode;
                      cont.sendOtp(params: params);
                      print("otp===> ${_otp}");
                    },
                    child: Text(
                      "resend_otp".tr,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // RichText(
              //   text: TextSpan(
              //     text: "Didn't get the OTP" + " ",
              //     style: TextStyle(
              //       color: AppColors.drawer.withOpacity(0.8),
              //     ),
              //     children: [
              //       WidgetSpan(
              //         child:
              //       ),
              //     ],
              //   ),
              // )
            ],
          );
        }),
      ),
    );
  }
  void _resendCode() {
    //other code here
    setState((){
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  dispose(){
    timer!.cancel();
    super.dispose();
  }
}

// class OtpScreen extends StatefulWidget {
//   Map<String, dynamic> params;
//
//   OtpScreen({required this.params});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   String _otp = "";
//   String emailOtp = "";
//   final phoneNumber = Get.arguments[0];
//   final countryCode = Get.arguments[1];
//   bool isResendOtp = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         text: "verification_code".tr,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 20.w,
//         ),
//         child: GetX<UserController>(builder: (cont) {
//           if ((cont.error.value.errorType == ErrorType.internet)) {
//             return NoInternetWidget();
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20.h),
//               Center(
//                 child: Text(
//                   "Please_type_the_verification_code_sent_to_your".tr,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.gray,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15.h),
//               OtpTextField(
//                 numberOfFields: 4,
//                 borderColor: AppColors.primaryColor,
//                 showFieldAsBox: true,
//                 fillColor: Colors.white,
//                 enabledBorderColor: AppColors.primaryColor,
//                 focusedBorderColor: AppColors.primaryColor,
//                 disabledBorderColor: AppColors.gray,
//                 autoFocus: true,
//                 //runs when a code is typed in
//                 onCodeChanged: (String code) {
//                   //handle validation or checks here
//                   _otp = code;
//                 },
//                 //runs when every textfield is filled
//                 onSubmit: (String verificationCode) {
//                   _otp = verificationCode;
//                   print("object  ==>  $_otp");
//                 }, // end onSubmit
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 "Please_type_the_verification_code_sent_to_your_email".tr,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.gray,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: AppColors.primaryColor,
//                 showFieldAsBox: true,
//                 fillColor: Colors.white,
//                 enabledBorderColor: AppColors.primaryColor,
//                 focusedBorderColor: AppColors.primaryColor,
//                 disabledBorderColor: AppColors.gray,
//                 autoFocus: true,
//                 //runs when a code is typed in
//                 onCodeChanged: (String code) {
//                   //handle validation or checks here
//                   emailOtp = code;
//                 },
//                 //runs when every textfield is filled
//                 onSubmit: (String verificationCode) {
//                   emailOtp = verificationCode;
//                   print("object  ==>  $emailOtp");
//                 }, // end onSubmit
//               ),
//               SizedBox(height: 20.h),
//               CustomButton(
//                 text: "continue".tr,
//                 onTap: () async {
//                   if (_otp.length != 4 || emailOtp.length != 6) {
//                     print("enter 1");
//                     cont.showError(msg: "please_enter_otp".tr);
//                     return;
//                   }
//                   if (!isResendOtp) {
//                     if (_otp != widget.params["otp"].toString() ||
//                         emailOtp != widget.params["email_otp"].toString()) {
//                       // print(widget.params["otp"].toString());
//                       // print(widget.params["email_otp"].toString());
//                       // print(_otp);
//                       // print(emailOtp);
//                       print("enter 2");
//                       cont.showError(msg: "Please enter valid otp");
//                       return;
//                     }
//                   }
//
//                   if (widget.params["login_by"] == "facebook") {
//                     print("enter 3");
//                     cont.loginWithFacebook(
//                         accessToken: "", data: widget.params);
//                   } else if (widget.params["login_by"] == "google") {
//                     print("enter 4");
//                     cont.loginWithGoogle(accessToken: "", data: widget.params);
//                   } else if (widget.params["login_by"] == "apple") {
//                     print("enter 5");
//                     cont.loginWithApple(
//                         socialUniqueId: "", data: widget.params);
//                   }
//                   if (isResendOtp) {
//                     await cont.verifyResendOTp(_otp, phoneNumber);
//                     setState(() {
//                       isResendOtp = false;
//                     });
//                   } else {
//                     // print(_otp);
//                     // print(emailOtp);
//                     cont.verifyOTp(_otp);
//                   }
//                 },
//                 fontSize: 16.sp,
//               ),
//               SizedBox(height: 20.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Didn't get the OTP" + " ",
//                       style: TextStyle(
//                         color: AppColors.drawer.withOpacity(0.8),
//                       )),
//                   InkWell(
//                     onTap: () async {
//                       setState(() {
//                         isResendOtp = true;
//                       });
//                       Map<String, dynamic> params = {};
//                       params["mobile"] = phoneNumber;
//                       params["country_code"] = countryCode;
//                       cont.sendOtp(params: params);
//                       print("otp===> ${_otp}");
//                     },
//                     child: Container(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[600],
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Text(
//                         "resend_OTP".tr,
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // RichText(
//               //   text: TextSpan(
//               //     text: "Didn't get the OTP" + " ",
//               //     style: TextStyle(
//               //       color: AppColors.drawer.withOpacity(0.8),
//               //     ),
//               //     children: [
//               //       WidgetSpan(
//               //         child:
//               //       ),
//               //     ],
//               //   ),
//               // )
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
