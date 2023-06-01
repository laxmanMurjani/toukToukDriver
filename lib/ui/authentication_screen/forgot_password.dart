import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_text_filed.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/cutom_appbar.dart';

class ForgotPassword extends StatefulWidget {
  Map<String, dynamic> response;

  ForgotPassword({required this.response});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "forgot_password".tr),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomTextFiled(
                    controller: cont.otpController,
                    label: "otp".tr,
                    hint: "otp".tr,
                    inputType: TextInputType.number,
                  ),
                  CustomTextFiled(
                    controller: cont.passwordController,
                    isPassword: true,
                    label: "new_password".tr,
                    hint: "new_password".tr,
                  ),
                  CustomTextFiled(
                    controller: cont.conPasswordController,
                    isPassword: true,
                    label: "confirm_new_password".tr,
                    hint: "confirm_new_password".tr,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
              child: CustomButton(
                text: "submit".tr,
                onTap: () {
                  if (cont.otpController.text.isEmpty) {
                    cont.showError(msg: "please_enter_otp".tr);
                    return;
                  }

                  if (cont.otpController.text ==
                      widget.response["otp"].toString()) {
                    cont.showError(msg: "wrong_otp".tr);
                    return;
                  }

                  if (cont.passwordController.text.isEmpty) {
                    cont.showError(msg: "please_enter_password".tr);
                    return;
                  }

                  if (cont.conPasswordController.text.length < 6) {
                    cont.showError(msg: "password_length".tr);
                    return;
                  }

                  if (cont.passwordController.text !=
                      cont.conPasswordController.text) {
                    cont.showError(msg: "password_should_be_same".tr);
                    return;
                  }
                  print("paaaa===>${cont.passwordController.text}");
                  if (cont.passwordController.text.contains((RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')))) {
                    Get.snackbar("Make strong password",
                        "Password must be alphanumeric with special characters",
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        colorText: Colors.white);
                    return;
                  }

                  Map<String, dynamic> params = Map();
                  params["password"] = cont.passwordController.text;
                  params["password_confirmation"] =
                      cont.passwordController.text;
                  params["id"] = widget.response["provider"]["id"];

                  cont.resetPassword(params: params);
                },
                fontSize: 16.sp,
              ),
            ),
          ],
        );
      }),
    );
  }
}
