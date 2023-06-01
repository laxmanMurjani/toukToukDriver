import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/model/user_detail_model.dart';
import 'package:mozlit_driver/ui/authentication_screen/vehicle_sign_up_screen.dart';
import 'package:mozlit_driver/ui/terms_and_condition_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/enum/error_type.dart';

import '../../util/app_constant.dart';
import '../widget/custom_text_filed.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserController _userController = Get.find();
  Map<String, dynamic> params = Map();

  @override
  void initState() {
    super.initState();

    _userController.clearFormData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getServiceType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SafeArea(
          child: Stack(
            children: <Widget>[

              Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    AppImage.building,
                    color: Colors.black.withOpacity(0.15),
                  )),
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 18.h),
                        ClipRRect(borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            AppImage.appMainLogo,
                            height: 150,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "Driver_Registration".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24.sp,
                              color: Colors.black),
                        ),
                        SizedBox(height: 15.h),
                        // CustomTextFiled(
                        //     controller: cont.emailController,
                        //     hint: "email".tr,
                        //     label: "email".tr),
                        CustomTextFiled(
                          controller: cont.firstNameController,
                          label: "first_name".tr,
                          hint: "first_name".tr,
                          inputType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 15.w),
                        CustomTextFiled(
                          controller: cont.lastNameController,
                          label: "lastname".tr,
                          hint: "lastname".tr,
                          inputType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                          controller: cont.emailController,
                          label: "email".tr,
                          hint: "email".tr,
                          inputType: TextInputType.emailAddress,
                        ),
                        // TextField(
                        //   inputFormatters: [
                        //     FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        //   ],
                        //   controller: cont.emailController,
                        //   //obscureText: isPassword,
                        //   decoration: InputDecoration(
                        //     border: UnderlineInputBorder(),
                        //     label: Text("email".tr),
                        //     hintText: "email".tr,
                        //     hintStyle:
                        //         TextStyle(fontSize: 10.sp, color: Colors.grey),
                        //     // labelText: label ?? "",
                        //     labelStyle: TextStyle(
                        //         fontSize: 10.sp, color: Color(0xffB4B4B5)),
                        //     // border: border,
                        //     // filled: filled,
                        //     // fillColor: fillColor,
                        //     isDense: true,
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: AppColors.primaryColor),
                        //     ),
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: AppColors.primaryColor),
                        //     ),
                        //     //suffixIcon: suffixIcon,
                        //   ),
                        //   style: TextStyle(
                        //       fontSize: 12.sp, fontWeight: FontWeight.w600),
                        //   // keyboardType: inputType,
                        //   // readOnly: readOnly,
                        // ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    CountryCodePicker(
                                      onChanged: (s) {cont.countryCode = s.toString();},
                                      textStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      hideMainText: true,
                                      initialSelection:
                                          cont.userData.value.countryCode ??
                                              "+961",
                                      // favorite: ['+91', 'IN'],
                                      // countryFilter: ['IT', 'FR', "IN"],
                                      showFlagDialog: true,
                                      comparator: (a, b) =>
                                          b.name!.compareTo(a.name.toString()),
                                      //Get the country information relevant to the initial selection
                                      onInit: (code) => print(
                                          "on init ${code!.name} ${code.dialCode} ${code.name}"),
                                    ),
                                    Image.asset(
                                      AppImage.downArrow1,
                                      height: 15,
                                      width: 15,
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 44, left: 10),
                                  color: Colors.black,
                                  height: 1,
                                  width: 80,
                                )
                              ],
                            ),
                            SizedBox(width: 15.w,),
                            Expanded(
                              child: CustomTextFiled(
                                controller: cont.phoneNumberController,
                                label: "phone".tr,
                                hint: "phone".tr,
                                inputType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                          controller: cont.passwordController,
                          hint: "password".tr,
                          label: "password".tr,
                          isPassword: true,
                        ),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                          controller: cont.conPasswordController,
                          hint: "confirm_password".tr,
                          label: "confirm_password".tr,
                          isPassword: true,
                        ),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                            controller: cont.refCodeController,
                            hint: "referral_code".tr,
                            label: "referral_code_(Optional)".tr),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                cont.signUpDetailsUser();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 45,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("next".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: capitalize(newValue.text),
//       selection: newValue.selection,
//     );
//   }
// }
String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}