import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/drawer_srceen/charging_station.dart';
import 'package:mozlit_driver/ui/drawer_srceen/profile_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/vehicle_profile_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/custom_text_filed.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/ui/widget/dialog/chooseLang.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/razor_pay.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api/api.dart';
import 'drawer_srceen/driver_document_screen.dart';
import 'drawer_srceen/earning_screen.dart';
import 'drawer_srceen/help_screen.dart';
import 'drawer_srceen/instant_ride.dart';
import 'drawer_srceen/invite_friend.dart';
import 'drawer_srceen/notification_manager.dart';
import 'drawer_srceen/setting_screen.dart';
import 'drawer_srceen/summery_screen.dart';
import 'drawer_srceen/wallet_screen.dart';
import 'drawer_srceen/your_trips_Screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = Get.find();
  final HomeController homeController = Get.find();
  // late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
      await  _userController.getChargingStation(liveLat: homeController.userCurrentLocation!.latitude.toString(),
            liveLong: homeController.userCurrentLocation!.longitude.toString()
        );
      },
    );
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    // _userController.clearFormData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      // appBar: CustomAppBar(text: "Profile Page"),
      backgroundColor: Colors.white,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  '${_userController.userData.value.firstName ?? ""} ${_userController.userData.value.lastName ?? ""}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.grey[300],
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('4.8',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primaryColor,
                                      )),
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ProfileScreen());
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(85),
                                    child: CustomFadeInImage(
                                      height: 40.w,
                                      width: 40.w,
                                      url: _userController
                                                  .userData.value.avatar !=
                                              null
                                          ? "${ApiUrl.baseImageUrl}${_userController.userData.value.avatar}"
                                          : "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png",
                                      //"${ApiUrl.baseImageUrl}${_userController.userData.value.avatar ?? "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png"}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                homeController.homeActiveTripModel.value.providerVerifyCheck == null? SizedBox() :
                                homeController.homeActiveTripModel.value.providerVerifyCheck == 'verified'?
                                Positioned(bottom:0, right:0,child: Container(height:20, width:20,decoration: BoxDecoration(
                                    color:Colors.white,shape: BoxShape.circle
                                ),
                                    child: Image.asset(AppImage.verifiedIcon,height: 20,width: 20,)),) : SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => YourTripsScreen());
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  height: 70,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Image.asset(
                                        AppImage.pastRide,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'past_rides'.tr,
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: 0,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => HelpScreen());
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  height: 70,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImage.help,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'help'.tr,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => SummeryScreen());
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  height: 70,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImage.summary,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'summary'.tr,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: AppColors.primaryColor,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // TextButton(onPressed: () {
                      //   _userController.getChargingStation(homeController);
                      //   // print("ddddddd===>${_userController.calDistance.map((e) => print("gggg===>${e.chargingStationDistance}"))}");
                      //   // _userController.calDistance.sort((a, b) => ,);
                      //   print("object");
                      //   print("object");
                      // }, child: Text("sdsdsd")),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(() => ChargingStation());
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'charging_stations'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Image.asset(
                      //         AppImage.chargingStation,
                      //         width: 28,
                      //         fit: BoxFit.contain,
                      //         height: 28,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => EarningScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'earning'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.earning,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => InstantRide());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'instant_ride'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.instantRide,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => DriverDocumentScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'document'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.document,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => WalletScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'wallet'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.walletNew,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => VehicleProfileScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'vehicle_details'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.walletNew,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      InkWell(
                        onTap: () {
                          Get.to(() => InviteFriendScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'invite_friend'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.inviteFriend,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ChooseLang());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('choose_language'.tr),
                            Icon(
                              Icons.language,
                              size: 28,
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          _showLogoutDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'logout'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.logOut,
                              width: 28,
                              fit: BoxFit.contain,
                              height: 28,
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // openCheckout() async {
  //   var options = {
  //     'key': 'rzp_test_M6NGOqKjONbfnL',
  //     'amount': 100,
  //     'name': 'Acme Corp.',
  //     'description': 'Fine T-Shirt',
  //     'retry': {'enabled': true, 'max_count': 1},
  //     'send_sms_hash': true,
  //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'choose_onew'.tr,
      text: 'hey_User'.tr,
      linkUrl: 'https://play.google.com/store/apps/details?id=com.touktouktaxi.driver',
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Get.back();
                _userController.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
