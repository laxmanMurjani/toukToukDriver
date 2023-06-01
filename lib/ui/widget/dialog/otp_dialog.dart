import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpDialog extends StatefulWidget {
  const OtpDialog({Key? key}) : super(key: key);

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  String _otp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: GetX<HomeController>(
            builder: (cont) {
              RequestElement requestElement = RequestElement();
              if (cont.homeActiveTripModel.value.requests.isNotEmpty) {
                requestElement = cont.homeActiveTripModel.value.requests[0];
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.h),
                        Image.asset(
                          AppImage.otp,
                          width: 50.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "otp_verification".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          animationType: AnimationType.fade,enableActiveFill: true,
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
                          animationDuration: Duration(milliseconds: 300),
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
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: CustomButton(
                            text: "submit".tr,
                            onTap: () {
                              if (_otp != requestElement.request?.otp){
                                cont.showError(msg: "wrong_otp".tr);
                                return;
                              }else{
                                Get.back(result: true);
                                cont.showSnack(msg: "otp_verified".tr);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
