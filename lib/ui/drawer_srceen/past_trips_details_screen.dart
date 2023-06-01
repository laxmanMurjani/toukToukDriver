import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/trip_history_details_model.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/dialog/dispute_dialog.dart';
import 'package:mozlit_driver/ui/widget/dialog/trip_receipt_dialog.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/common.dart';

class PastTripDetailsScreen extends StatefulWidget {
  int tripId;

  PastTripDetailsScreen({this.tripId = 0});

  @override
  _PastTripDetailsScreenState createState() => _PastTripDetailsScreenState();
}

class _PastTripDetailsScreenState extends State<PastTripDetailsScreen> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();
  final GlobalKey _startAddressKey = GlobalKey();
  final GlobalKey _endAddressKey = GlobalKey();

  final DateFormat _dateFormat = DateFormat("dd MMM yyyy\nhh:mm a");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getTripDetails(id: widget.tripId);
      Future.delayed(Duration(milliseconds: 200), () => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 10, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    key: _key,
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        Get.bottomSheet(DisputeDialog(tripId: widget.tripId),
                            isScrollControlled: true);
                      });
                    },
                    child: Text('dispute'.tr),
                    value: 'dispute'.tr,
                  ),
                ],
                elevation: 8.0,
              );
            }),
        text: "past_trip_details".tr,
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Get.bottomSheet(TripReceiptDialog(), isScrollControlled: true);
        },
        child: Container(
          height: 55,
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20.r),
            // boxShadow: [
            //   AppBoxShadow.defaultShadow(),
            // ],
          ),
          child: Center(
            child: Text(
              "view_receipt".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp),
            ),
          ),
        ),
      ),
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        TripHistoryDetailModel tripDataModel =
            cont.tripHistoryDetailModel.value;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15.w, 15.5.h, 15.w, 0),
                padding: EdgeInsets.only(bottom: 15.h),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        // borderRadius: BorderRadius.circular(20.r),
                        child: CustomFadeInImage(
                      url: tripDataModel.staticMap ??
                          "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                      width: double.infinity,
                      height: 255.h,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(85),
                            child: CustomFadeInImage(
                              height: 50.w,
                              width: 50.w,
                              url:
                                  "${ApiUrl.baseImageUrl}${tripDataModel.user?.picture ?? ""}",
                              placeHolder: AppImage.icUserPlaceholder,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${tripDataModel.user?.firstName ?? ""} ${tripDataModel.user?.lastName ?? ""}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.grey[300],
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${tripDataModel.rating?.providerRating ?? 0}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor),
                                    )
                                  ],
                                ),
                                // RatingBar.builder(
                                //   initialRating: _strToDouble(
                                //       s: (tripDataModel
                                //                   .rating?.providerRating ??
                                //               0)
                                //           .toString()),
                                //   minRating: 1,
                                //   direction: Axis.horizontal,
                                //   allowHalfRating: true,
                                //   ignoreGestures: true,
                                //   itemCount: 5,
                                //   itemPadding:
                                //       EdgeInsets.symmetric(horizontal: 0.5.w),
                                //   itemBuilder: (context, _) => Icon(
                                //     Icons.star,
                                //     color: Colors.amber,
                                //   ),
                                //   itemSize: 12.w,
                                //   onRatingUpdate: (rating) {},
                                // ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_dateFormat.format(tripDataModel.finishedAt ?? DateTime.now())}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                "${tripDataModel.bookingId ?? ""}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Text(
                    //     "Address",
                    //     style: TextStyle(
                    //         color: Colors.black, fontWeight: FontWeight.w600),
                    //   ),
                    // ),
                    // SizedBox(height: 15.h),
                    // Stack(
                    //   children: [
                    //     if (_startAddressKey.currentContext
                    //                 ?.findRenderObject() !=
                    //             null &&
                    //         _endAddressKey.currentContext?.findRenderObject() !=
                    //             null)
                    //       Transform(
                    //         transform: Matrix4.translationValues(0, 0, 00),
                    //         child: Padding(
                    //           padding: EdgeInsets.only(
                    //               left: 38.w,
                    //               top: ((_startAddressKey.currentContext
                    //                           ?.findRenderObject() as RenderBox)
                    //                       .size
                    //                       .height /
                    //                   2)),
                    //           child: Align(
                    //             alignment: Alignment.centerLeft,
                    //             child: DottedLine(
                    //               direction: Axis.vertical,
                    //               dashColor: Colors.black,
                    //               lineLength: (((_startAddressKey.currentContext
                    //                                       ?.findRenderObject()
                    //                                   as RenderBox)
                    //                               .size
                    //                               .height /
                    //                           2) +
                    //                       ((_endAddressKey.currentContext
                    //                                       ?.findRenderObject()
                    //                                   as RenderBox)
                    //                               .size
                    //                               .height /
                    //                           2)) +
                    //                   10.h,
                    //               dashLength: 3,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     Column(
                    //       children: [
                    //         Padding(
                    //           key: _startAddressKey,
                    //           padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //           child: Row(
                    //             children: [
                    //               SizedBox(width: 10.w),
                    //               // Image.asset(
                    //               //   AppImage.srcIcon,
                    //               //   width: 18.w,
                    //               // ),
                    //               Icon(
                    //                 Icons.circle,
                    //                 color: AppColors.primaryColor,
                    //                 size: 16,
                    //               ),
                    //               SizedBox(width: 5.w),
                    //               Expanded(
                    //                 child: Text(
                    //                   "${tripDataModel.sAddress ?? ""}",
                    //                   style: TextStyle(
                    //                     fontSize: 12.sp,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(height: 10.h),
                    //         Padding(
                    //           key: _endAddressKey,
                    //           padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //           child: Row(
                    //             children: [
                    //               SizedBox(width: 10.w),
                    //               // Image.asset(
                    //               //   AppImage.multiDestIcon,
                    //               //   width: 18.w,
                    //               // ),
                    //               Icon(
                    //                 Icons.circle,
                    //                 color: AppColors.primaryColor,
                    //                 size: 16,
                    //               ),
                    //               SizedBox(width: 5.w),
                    //               Expanded(
                    //                 child: Text(
                    //                   "${tripDataModel.dAddress ?? ""}",
                    //                   style: TextStyle(
                    //                     fontSize: 12.sp,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    timelineRow("source".tr, '${tripDataModel.sAddress ?? ""}'),
                    timelineLastRow(
                        "destination".tr, '${tripDataModel.dAddress ?? ""}'),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Text(
                            "pay_via".tr,
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(width: 10.w),
                          Image.asset(
                            AppImage.creditCard,
                            fit: BoxFit.contain,
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${tripDataModel.paymentMode ?? ""}",
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 12.sp),
                          ),
                          Spacer(),
                          Text(
                            "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                            "comments".tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${(tripDataModel.rating == null ||tripDataModel.rating!.userComment == "null" || tripDataModel.rating!.userComment!.isEmpty) ? "No Comments".tr : tripDataModel.rating?.userComment }",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  double _strToDouble({required String s}) {
    double rating = 0;
    try {
      rating = double.parse(s);
    } catch (e) {
      rating = 0;
    }
    return rating;
  }

  void _dispute() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 5.h),
        height: MediaQuery.of(context).size.height * 0.18,
        width: 200.w,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: AppColors.primaryColor,
                    size: 25,
                  ),
                  SizedBox(width: 100.w),
                  Text(
                    'dispute'.tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Divider(thickness: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "you".tr,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "driver_unprofessional".tr,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 20.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "open".tr,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
