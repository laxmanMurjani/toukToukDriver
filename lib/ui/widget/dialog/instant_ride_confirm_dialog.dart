import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/fare_with_out_auth_model.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

bool instantRideConfirm = false;

class InstantRideConfirmDialog extends StatefulWidget {
  const InstantRideConfirmDialog({Key? key}) : super(key: key);

  @override
  State<InstantRideConfirmDialog> createState() =>
      _InstantRideConfirmDialogState();
}

class _InstantRideConfirmDialogState extends State<InstantRideConfirmDialog> {
  @override
  final box = GetStorage();
  Widget build(BuildContext context) {
    return Container(
      child: GetX<HomeController>(builder: (cont) {
        if ((cont.error.value.errorType == ErrorType.internet)) {
          return NoInternetWidget();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          // margin: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
          child: GetX<HomeController>(builder: (cont) {
            if ((cont.error.value.errorType == ErrorType.internet)) {
              return NoInternetWidget();
            }
            FareWithOutAuthModel fareWithOutAuthModel =
                cont.fareWithOutAuthModel.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    "please_confirm_the_address".tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                _rowItem(
                    title: "picked_up_location".tr,
                    value: "${cont.tempLocationFromTo.text}"),
                _rowItem(
                    title: "drop_location".tr,
                    value: "${cont.tempLocationWhereTo1.text}"),
                _rowItem(
                  title: "phone_number".tr,
                  value:
                      "${cont.countryCode} ${cont.tempMobileNumberController.text}",
                  iconData: Icons.call,
                ),
                _rowItem(
                  title: "estimated_fare".tr,
                  value: "${fareWithOutAuthModel.estimatedFare ?? "0"}",
                  iconData: Icons.call,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          child: Text(
                            "cancel".tr,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: "confirm".tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        onTap: () {
                          cont.requestInstantRide(() => setState(() {}));
                          box.write('isInstantRide', 'True');
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h)
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _rowItem(
      {IconData iconData = Icons.location_on,
      required String title,
      required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(iconData),
          SizedBox(width: 5.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              SizedBox(height: 3.h),
              Text(
                "$value",
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
