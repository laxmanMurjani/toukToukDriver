import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/model/user_detail_model.dart';
import 'package:mozlit_driver/ui/terms_and_condition_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/enum/error_type.dart';

import '../../util/app_constant.dart';
import '../widget/custom_text_filed.dart';

class VehicleSignUpScreen extends StatefulWidget {
  @override
  _VehicleSignUpScreenState createState() => _VehicleSignUpScreenState();
}

class _VehicleSignUpScreenState extends State<VehicleSignUpScreen> {
  final UserController _userController = Get.find();
  Map<String, dynamic> params = Map();

  @override
  void initState() {
    super.initState();

    // _userController.clearFormData();
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
            alignment: Alignment.center,
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
                          "Vehicle_Registration".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24.sp,
                              color: Colors.black),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Text(
                                "Taxi service type".tr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color(0x50000000),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DropdownButton<ServiceType>(
                          hint: Text(
                            'please_choose_a_service_type'.tr,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Not necessary for Option 1
                          value: cont.taxiServiceType,
                          isExpanded: true,
                          isDense: true,
                          focusColor: AppColors.primaryColor,
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w600),
                          underline: Container(
                            height: 1.h,
                            width: double.infinity,
                            decoration:
                                BoxDecoration(color: AppColors.underLineColor),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              cont.taxiServiceType = newValue;
                            });
                          },
                          items: cont.serviceTypeList1.map((location) {
                            return DropdownMenuItem(
                              child: Text(
                                location.name ?? "",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),
                        // SizedBox(height: 15.h),
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(bottom: 5.h),
                        //       child: Text(
                        //         "Delivery service type".tr,
                        //         style: TextStyle(
                        //           fontSize: 13.sp,
                        //           color: Color(0x50000000),
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // DropdownButton<ServiceType>(
                        //   hint: Text(
                        //     'please_choose_a_service_type'.tr,
                        //     style: TextStyle(
                        //       fontSize: 10.sp,
                        //       color: Colors.grey[600],
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        //   // Not necessary for Option 1
                        //   value: cont.deliveryServiceType,
                        //   isExpanded: true,
                        //   isDense: true,
                        //   focusColor: AppColors.primaryColor,
                        //   style: TextStyle(
                        //       fontSize: 12.sp, fontWeight: FontWeight.w600),
                        //   underline: Container(
                        //     height: 1.h,
                        //     width: double.infinity,
                        //     decoration:
                        //     BoxDecoration(color: AppColors.underLineColor),
                        //   ),
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       cont.deliveryServiceType = newValue;
                        //     });
                        //   },
                        //   items: cont.serviceTypeList.map((location) {
                        //     return DropdownMenuItem(
                        //       child: Text(
                        //         location.name ?? "",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 12.sp,
                        //         ),
                        //       ),
                        //       value: location,
                        //     );
                        //   }).toList(),
                        // ),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                            controller: cont.carModelController,
                            label: "car_model".tr,
                            hint: "car_model".tr),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                            controller: cont.carNumberController,
                            label: "car_number".tr,
                            hint: "car_number".tr),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                            controller: cont.carColorController,
                            label: "car_color".tr,
                            hint: "car_color".tr),
                        SizedBox(height: 15.h),
                        CustomTextFiled(
                            controller: cont.carCompanyNameController,
                            label: "car_name".tr,
                            hint: "car_name".tr),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: cont.chkTerms.value,
                  //       onChanged: (v) {
                  //         cont.chkTerms.value = v!;
                  //       },
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         cont.removeUnFocusManager();
                  //         Get.to(() => TermsAndConditionScreen());
                  //       },
                  //       child: Text(
                  //         "i_have_read_and_agreed_the_terms_and_Conditions".tr,
                  //         style: TextStyle(fontSize: 12.sp),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        //SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: cont.chkTerms.value,
                              onChanged: (value) {
                                cont.chkTerms.value = value!;
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'By Continuing, You Agree to our ',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 10),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '\nTerms of use ',
                                      style: TextStyle(
                                          color: Color(0xff297FFF),
                                          fontSize: 10)),
                                  TextSpan(
                                    text: 'and',
                                  ),
                                  TextSpan(
                                      text: '  Privacy Policy',
                                      style: TextStyle(
                                          color: Color(0xff297FFF),
                                          fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            // print('ll: ${cont.taxiServiceType?.id}');
                            // print('ll: ${cont.deliveryServiceType?.id}');
                            cont.registerUser();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("create_an_account".tr,
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
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
