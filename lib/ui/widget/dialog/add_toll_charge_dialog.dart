import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class AddTollChargeDialog extends StatefulWidget {
  const AddTollChargeDialog({Key? key}) : super(key: key);

  @override
  State<AddTollChargeDialog> createState() => _AddTollChargeDialogState();
}

class _AddTollChargeDialogState extends State<AddTollChargeDialog> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Center(
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Touk Touk Driver",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  "add_toll_charge".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cont.homeActiveTripModel.value.currency!,style: TextStyle(
                      fontSize: 18
                    )),
                    SizedBox(width: 8.w),
                    Container(
                      width: 100.w,
                      child: Material(
                        color: Colors.transparent,
                        child: TextFormField(
                          controller: cont.tollTaxController,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              hintText: "add_Toll".tr,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 2.h),
                              isDense: true),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(thickness: 1.0, height: 5.h),
                // SizedBox(height: 10.h),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Map<String, String> params = {};
                        params["status"] = "DROPPED";
                        params["_method"] = "PATCH";
                        params["latitude"] = cont.userCurrentLocation!.latitude.toString();
                        params["longitude"] = cont.userCurrentLocation!.longitude.toString();
                        cont.updateTrip(data: params);
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.center,

                        height: 55,
                        width: MediaQuery.of(context).size.width*0.43,
                        child: Text(
                          "dismiss".tr,
                          style: TextStyle(color: Color(0xffD85656)),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 15.h,
                      color: AppColors.gray,
                    ),
                    InkWell(
                      onTap: () {
                        if (cont.tollTaxController.text.isEmpty) {
                          cont.showError(msg: "please_enter_valid_amount".tr);
                          return;
                        }

                        // if ((int.tryParse(_tollTaxController.text) ?? 0) <=
                        //     0) {
                        //   cont.showError(msg: "please_enter_valid_amount".tr);
                        // }
                        if (int.tryParse(cont.tollTaxController.text)! >= 80) {
                          cont.showError(
                              msg: "Max toll charge is below 80 Rs.");
                        } else {
                          Map<String, String> params = {};
                          params["status"] = "DROPPED";
                          params["_method"] = "PATCH";
                          params["latitude"] = cont.userCurrentLocation!.latitude.toString();
                          params["longitude"] = cont.userCurrentLocation!.longitude.toString();
                          params["toll_price"] = "${cont.tollTaxController.text}";
                          cont.updateTrip(data: params);
                          Get.back();
                        }

                      },
                      child: Container(
                        alignment: Alignment.center,

                        height: 55,
                        width: MediaQuery.of(context).size.width*0.43,
                        child: Text(
                          "submit".tr,
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
