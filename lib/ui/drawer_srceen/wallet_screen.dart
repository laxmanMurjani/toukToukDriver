import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/wallet_balance_model.dart';
import 'package:mozlit_driver/ui/drawer_srceen/payment_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/payment_webview_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/transactionScreen.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model/wallet_balance_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../util/app_constant.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final UserController _userController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy KK:mm a");
  TextEditingController _addMoneyTextController = TextEditingController();
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getWalletTransaction();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar("Payment", "SUCCESS: " + response.paymentId!,
        backgroundColor: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Fail",
        "ERROR: " + response.code.toString() + " - " + response.message!,
        backgroundColor: Colors.redAccent);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", "EXTERNAL_WALLET: " + response.walletName!,
        backgroundColor: Colors.green);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }

  openCheckout(amount) async {
    var options = {
      'key': 'rzp_test_M6NGOqKjONbfnL',
      'amount': amount,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Center(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 45.0, right: 45, top: 120),
              //     child: Image.asset(
              //       AppImage.logoOpacity,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30.w, right: 20.w),
                    height: 97.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 6.r,
                            offset: Offset(0, 3.h)),
                      ],
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(38.r),
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              AppImage.backArrow,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                          Text(
                            'Wallet'.tr,
                            //widget.text ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => TransactionScreen());
                              },
                              child: Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.21.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            "your_wallet_amount".tr,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 7.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(AppImage.walletCard,
                                  width: 110, height: 110),
                              Container(
                                margin: EdgeInsets.only(right: 45),
                                child: Text(
                                  '${_userController.userData.value.currency} ${cont.userData.value.walletBalance ?? "0"}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                "add_money".tr,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${_userController.userData.value.currency ?? ""}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _addMoneyTextController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          hintText: "0",
                                          hintStyle: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold)),
                                      onChanged: (s) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  InkWell(
                    onTap: () {
                      double amount = 0;
                      if (_addMoneyTextController.text.isEmpty) {
                        Get.snackbar("Alert", "please_enter_amount".tr,
                            backgroundColor: Colors.redAccent.withOpacity(0.8),
                            colorText: Colors.white);

                        return;
                      }
                      try {
                        amount = double.parse(
                            _addMoneyTextController.text);
                      } catch (e) {
                        amount = 0;
                      }
                      if (amount < 1) {
                        Get.snackbar("Alert", "Please_enter_more_when_amount".tr,
                            backgroundColor: Colors.redAccent.withOpacity(0.8),
                            colorText: Colors.white);
                        // _baseController.showError(
                        //     msg: "Please_enter_more_when_amount".tr);
                        return;
                      }




                        Get.to(PaymentWebViewScreen(
                            url:
                                "${ApiUrl.BASE_URL}/razorpay_payment_add_money?name=${_userController.userData.value.firstName}&amount=${_addMoneyTextController.text}&user_type=provider&user_id=${_userController.userData.value.id}"));

                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                      margin: EdgeInsets.symmetric(
                        horizontal: 30.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          AppBoxShadow.defaultShadow(),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "add_amount".tr,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                 Container(
                   height:250,
                   // color: Colors.red,
                   child:  cont.walletTransaction.isEmpty
                       ? Padding(
                     padding: const EdgeInsets.only(top: 12.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           "no_wallet_history".tr,
                           style: TextStyle(
                               color: AppColors.primaryColor,
                               fontSize: 16),
                         ),
                       ],
                     ),
                   )
                       : Padding(
                     padding: const EdgeInsets.only(top: 5.0),
                     child: ListView.builder(
                       shrinkWrap: true,
                       physics: ScrollPhysics(),
                       padding: EdgeInsets.symmetric(vertical: 10.h),
                       itemBuilder: (context, index) {
                         WalletTransation walletTransation =
                         cont.walletTransaction[index];
                         return Container(
                           margin: EdgeInsets.symmetric(
                               vertical: 10.h, horizontal: 15.w),
                           clipBehavior: Clip.antiAlias,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(15.r),
                             boxShadow: [
                               AppBoxShadow.defaultShadow(),
                             ],
                           ),
                           child: Container(
                             padding: EdgeInsets.symmetric(
                                 horizontal: 10.w, vertical: 10.h),
                             decoration: BoxDecoration(
                               // color: ((walletTransation.amount??0) <0 ? Colors.red:Colors.green).withOpacity(0.15),
                               color: Colors.white,
                               // border: Border(
                               //   right: BorderSide(
                               //     color: (walletTransation.amount??0) <0 ? Colors.red:Colors.green,
                               //     width: 5.w,
                               //   ),
                               // ),
                             ),
                             child: Column(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               children: [
                                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Column(crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "${walletTransation.transactionAlias ?? ""}",
                                           style: TextStyle(
                                             fontSize: 16.sp,
                                             fontWeight: FontWeight.w700,
                                             // color: AppColors.primaryColor
                                           ),
                                         ),
                                         Text(
                                           "${_dateFormat.format(walletTransation.createdAt!)}",
                                           style: TextStyle(
                                             fontSize: 13.sp,
                                             fontWeight: FontWeight.w500,
                                             // color: AppColors.primaryColor
                                           ),
                                         ),
                                       ],
                                     ),
                                     Align(
                                       alignment: Alignment.centerRight,
                                       child: Row(

                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Column(
                                             children: [
                                               Text(
                                                 "amount".tr,
                                                 style: TextStyle(
                                                   color: Colors.grey,
                                                   fontWeight: FontWeight.w600,
                                                   fontSize: 16.sp,
                                                 ),
                                               ),
                                               Text(
                                                 "${walletTransation.amount!.toStringAsFixed(2) ?? ""} ${cont.userData.value.currency ?? ""}",
                                                 style: TextStyle(
                                                   color:
                                                   AppColors.primaryColor,
                                                   fontWeight: FontWeight.w800,
                                                   fontSize: 18.sp,
                                                 ),
                                               ),

                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                                 SizedBox(height: 10,),

                                 RichText(
                                   text: TextSpan(
                                     text: "balance".tr,
                                     style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14.sp,
                                       fontWeight: FontWeight.w500,
                                     ),
                                     children: [
                                       TextSpan(
                                           text: " " +
                                               "${walletTransation.transactions.first.openBalance!.toStringAsFixed(2) ?? ""} ${cont.userData.value.currency ?? ""}",
                                           style: TextStyle(
                                             color: AppColors.primaryColor,
                                           ))
                                     ],
                                   ),
                                 )
                               ],
                             ),
                           ),
                         );
                       },
                       itemCount: cont.walletTransaction.length,
                     ),
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
