import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/model/trip_history_details_model.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripReceiptDialog extends StatefulWidget {
  @override
  State<TripReceiptDialog> createState() => _TripReceiptDialogState();
}

class _TripReceiptDialogState extends State<TripReceiptDialog> {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<HomeController>(builder: (cont) {
        if ((cont.error.value.errorType == ErrorType.internet)) {
          return NoInternetWidget();
        }

        TripHistoryDetailModel tripDataModel = cont.tripHistoryDetailModel.value;
        String timeFare = "";

        ServiceType serviceType = tripDataModel.serviceType ?? ServiceType();
        Payment payment = tripDataModel.payment ?? Payment();

        if (serviceType.calculator == AppString.MINUTE) {
          timeFare = "${payment.minute ?? ""}";
        } else if (serviceType.calculator == AppString.HOUR) {
          timeFare = "${payment.hour ?? ""}";
        } else if (serviceType.calculator == AppString.DISTANCE) {
          timeFare = "${payment.distance ?? ""}";
        } else if (serviceType.calculator == AppString.DISTANCE_MIN) {
          timeFare = "${payment.minute ?? ""}";
        } else if (serviceType.calculator == AppString.DISTANCE_HOUR) {
          timeFare = "${payment.hour ?? ""}";
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15.h),
                Text(
                  "invoice".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                _invoiceRow(
                    label: "booking_id".tr, value: tripDataModel.bookingId ?? ""),
                _invoiceRow(
                    label: "time_taken".tr,
                    value: "${tripDataModel.travelTime ?? "0"} Min(s)"),
                _invoiceRow(
                    label: "base_fare".tr,
                    value:
                        "${(tripDataModel.payment?.fixed ?? 0).toStringAsFixed(2)} ${_userController.userData.value.currency ?? ""}"),
                _invoiceRow(
                    label: "time_fare".tr,
                    value:
                        "$timeFare ${_userController.userData.value.currency ?? ""} "),
                _invoiceRow(
                    label: "tax".tr,
                    value:
                        "${payment.tax ?? ""} ${_userController.userData.value.currency ?? ""}"),
                _invoiceRow(
                    label: "toll_charges".tr,
                    value:
                        "${payment.tollCharge ?? ""} ${_userController.userData.value.currency ?? ""}"),
                _invoiceRow(
                    label: "round_off".tr,
                    value:
                        "${payment.roundOf ?? ""} ${_userController.userData.value.currency ?? ""}"),
                _invoiceRow(
                    label: "total".tr,
                    labelStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                    value:
                        "${payment.total ?? ""} ${_userController.userData.value.currency ?? ""}",
                    valueStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    )),
                Divider(),
                _invoiceRow(
                  label: "payable".tr,
                  labelStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                  value:
                      "${payment.payable ?? ""} ${_userController.userData.value.currency ?? ""}",
                  valueStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      "close".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _invoiceRow({
    String label = "",
    TextStyle? labelStyle,
    String value = "",
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle ??
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
          ),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
          ),
        ],
      ),
    );
  }
}
