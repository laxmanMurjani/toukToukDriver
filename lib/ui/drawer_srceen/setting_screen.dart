import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/util/app_constant.dart';

import '../../enum/error_type.dart';
import '../widget/no_internet_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String locale = Intl.getCurrentLocale();
  int _selected = 0;
  List _language = ["English", "Dutch"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "setting".tr),
      backgroundColor: AppColors.bgColor,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ],
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  children: [
                    Text(
                      "choose_language".tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // SizedBox(height: 7.h),
                    Divider(
                      thickness: 2,
                    ),
                    Column(
                      children: List.generate(
                          _language.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cont.selectedLanguage.value = index;
                                  });
                                  if(_language[index] == "English"){
                                    log("///////////////////////////////////////////////////////////////////////////////////////////////////${cont.selectedLanguage.value}");
                                  cont.selectedLanguage.value  = index;

                                    log("////////g///////////////////////////////////////////////////////////////////////////////////////////${cont.selectedLanguage.value}");

                                    cont.setLanguage();
                                  }else if(_language[index] == "Dutch"){
                                    log("///////////////////////////////////////////////////////////////////////////////////////////////////${cont.selectedLanguage.value}");

                                    cont.selectedLanguage.value = index;
                                    log("///////////////////////////////////////////////////////////////////////////////////////////////////${cont.selectedLanguage.value}");

                                    Get.updateLocale(Locale('nl', 'NL'));
                                    cont.setLanguage();
                                  }
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 7.h),
                                    Row(
                                      children: [
                                        Container(
                                          height: 15.w,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                            // color: _selected == index
                                            //     ? AppColors.primaryColor
                                            //     : Color  b s.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 2.w),
                                          ),
                                          child:cont.selectedLanguage.value == index
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.w),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                           _language[index],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    if (index != _language.length - 1)
                                      Divider(
                                        thickness: 2.h,
                                      )
                                  ],
                                ),
                              )),
                    ),
                    SizedBox(height: 10.h)
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
