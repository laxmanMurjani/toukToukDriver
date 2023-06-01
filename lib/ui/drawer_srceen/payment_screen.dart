import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "payment".tr,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)], borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text(
                  "payment_options".tr,
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Image.asset(
                      AppImage.wallet_icon,
                      height: 30.h,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "by_cash".tr,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
