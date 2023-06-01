import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/drawer_srceen/driver_document_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/earning_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/help_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/instant_ride.dart';
import 'package:mozlit_driver/ui/drawer_srceen/invite_friend.dart';
import 'package:mozlit_driver/ui/drawer_srceen/notification_manager.dart';
import 'package:mozlit_driver/ui/drawer_srceen/profile_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/setting_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/wallet_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/your_trips_Screen.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

import '../drawer_srceen/summery_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final UserController _userController = Get.find();
  List<String> title = [
    'your_trips'.tr,
    'earning'.tr,
    'instant_ride'.tr,
    'summary'.tr,
    'wallet'.tr,
    'card'.tr,
    'document'.tr,
    'setting'.tr,
    'notification_manager'.tr,
    'help'.tr,
    'share'.tr,
    'invite_friend'.tr,
    'logout'.tr,
  ];

  Future<void> share() async {
    await FlutterShare.share(
      title: 'choose_one'.tr,
      text: 'hey_checkout_this_app'.tr,
      linkUrl: 'https://play.google.com/store/apps/details?id=com.touktouktaxi.driver',
    );
  }

  // Future<void> shareFile() async {
  //   List<dynamic> docs = await DocumentsPicker.pickDocuments;
  //   if (docs == null || docs.isEmpty) return null;
  //
  //   await FlutterShare.shareFile(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     filePath: docs[0] as String,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      decoration: BoxDecoration(
        // color: AppColors.drawer,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(50.r),
        ),
        image: DecorationImage(
          image: AssetImage(
            AppImage.drawer,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return Column(
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      AppImage.icWhiteArrow,
                      width: 30.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              InkWell(
                onTap: () {
                  Get.to(() => ProfileScreen())?.then((value) {
                    Get.back();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 60.w,
                        width: 60.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.h)),
                        child: CustomFadeInImage(
                          url:cont.userData.value.avatar != null ? "${ApiUrl.baseImageUrl}${cont.userData.value.avatar}" : "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                              //"${ApiUrl.baseImageUrl}${cont.userData.value.avatar ?? "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png"}",
                          fit: BoxFit.cover,
                          // placeHolderWidget: Center(
                          //   child: Icon(
                          //     Icons.person,
                          //     color: Colors.grey,
                          //     size: 35.w,
                          //   ),
                          // ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${cont.userData.value.firstName ?? ""} ${cont.userData.value.lastName ?? ""}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "${cont.userData.value.email ?? ""}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.r),
                        bottomRight: Radius.circular(50.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          offset: Offset(0, -5),
                          blurRadius: 16,
                        )
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          title.length,
                          (index) => InkWell(
                            onTap: () {
                              Get.back();
                              index == 0
                                  ? Get.to(() => YourTripsScreen())
                                  : index == 1
                                      ? Get.to(() => EarningScreen())
                                      : index == 2
                                          ? Get.to(() => InstantRide())
                                          : index == 3
                                              ? Get.to(() => SummeryScreen())
                                              : index == 4
                                                  ? Get.to(() => WalletScreen())
                                                  : index == 5
                                                      ? Get.to(() =>
                                                          DriverDocumentScreen())
                                                      : index == 6
                                                          ? Get.to(() =>
                                                              DriverDocumentScreen())
                                                          : index == 7
                                                              ? Get.to(() =>
                                                                  SettingScreen())
                                                              : index == 8
                                                                  ? Get.to(() =>
                                                                      NotificationManagerScreen())
                                                                  : index == 9
                                                                      ? Get.to(() =>
                                                                          HelpScreen())
                                                                      : index ==
                                                                              10
                                                                          ? share()
                                                                          : index == 11
                                                                              ? Get.to(() => InviteFriendScreen())
                                                                              : index == 12
                                                                                  ? _showLogoutDialog()
                                                                                  : Container();
                            },
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5.h),
                                    Text(
                                      title[index],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    index == title.length - 1
                                        ? SizedBox()
                                        : Divider(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h)
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
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
                Text('are_you_sure_want_to_logout'.tr),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('no'.tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('yes'.tr),
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
