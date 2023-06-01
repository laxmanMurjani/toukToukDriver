import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/home_widget/trip_approved_widget.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/common.dart';

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({Key? key}) : super(key: key);

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  final DateFormat _dateFormat = DateFormat("dd MMM yyyy\nhh:mm a");
  final GlobalKey _startAddressKey = GlobalKey();
  final GlobalKey _endAddressKey = GlobalKey();
  final HomeController _homeController = Get.find();
  MultiDestination currentDestination = MultiDestination();
  @override
  void initState() {
    super.initState();

    _homeController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        RequestElement requestElement = RequestElement();
        if (cont.homeActiveTripModel.value.requests.isNotEmpty) {
          requestElement = cont.homeActiveTripModel.value.requests[0];
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ]),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15,),
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(85),
                            child: CustomFadeInImage(
                              height: 50.w,
                              width: 50.w,
                              url: requestElement.request?.user?.picture != null
                                  ? "${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture}"
                                  : "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",

                              //"${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture ?? "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png"}",

                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    cont.homeActiveTripModel.value.userVerifyCheck == null? SizedBox() :
                                    cont.homeActiveTripModel.value.userVerifyCheck == 'verified'?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Image.asset(AppImage.verifiedIcon,height: 20,width: 20,),
                                    ) : SizedBox()
                                  ],
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
                                      '${requestElement.request?.user?.rating ?? "0"}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor),
                                    )
                                  ],
                                )
                                // RatingBar.builder(
                                //   initialRating: _strToDouble(
                                //       s: requestElement.request?.user?.rating ??
                                //           "0"),
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
                                "${_dateFormat.format(requestElement.request?.assignedAt ?? DateTime.now())}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp),
                              ),
                              Text(
                                "${requestElement.request?.bookingId ?? ""}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                 SizedBox(height: 10,),
                  timelineRow(
                      "source".tr, '${requestElement.request?.sAddress ?? ""}'),
                  timelineLastRow("destination".tr,
                      '${requestElement.request?.dAddress ?? ""}'),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: divider(),
                  ),
                requestElement.request?.payment?.breakdown_amount == "0" ? SizedBox() :
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        Text(
                          "BreakDown Amount".tr,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Spacer(),
                        Text(
                          "${requestElement.request?.payment?.breakdown_amount?? "0"} ${cont.homeActiveTripModel.value.currency ?? ""}",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:30.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Toll Charge : ${cont.tollTaxController.text}".tr,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        Text(
                          "pay_via".tr,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // cont.homeActiveTripModel.value.requests.first.request!.selected_payment!.contains("online") ?
                        // Image.asset(AppImage.creditCard,
                        //     height: 25, width: 25, fit: BoxFit.contain) : Image.asset(AppImage.monyCash,
                        //     height: 25, width: 25, fit: BoxFit.contain),
                        // SizedBox(width: 10.w),
                        cont.homeActiveTripModel.value.requests.first.request!.selected_payment!.contains("online") ?    Text(
                          "${cont.homeActiveTripModel.value.requests.first.request!.selected_payment ?? ""}",
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                        ) : Text(
                          "${requestElement.request?.paymentMode ?? ""}",
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                        Spacer(),
                        Text(
                          "${requestElement.request?.payment?.total ?? "0"} ${cont.homeActiveTripModel.value.currency ?? ""}",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  requestElement.request!.payment!.breakdown_amount == "0" ?SizedBox() :   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        Text(
                          "total".tr,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${requestElement.request?.payment?.payable ?? "0"} ${cont.homeActiveTripModel.value.currency ?? ""}",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _homeController.homeActiveTripModel.value.breakdown_count_check != 0
                      ? Column(
                        children: [
                          // InkWell(
                          //     onTap: () {
                          //       // _showNewRideRequestDialog();
                          //       Map<String, String> params = {};
                          //       params["_method"] = CheckStatus.PATCH;
                          //       params["status"] = CheckStatus.COMPLETED;
                          //       // updateBreakDownTrip(data: params);
                          //       _homeController.updateTrip(data: params);
                          //       setState(() {
                          //         isBreakDown = false;
                          //       });
                          //       Get.back();
                          //     },
                          //     child: Container(
                          //       width: double.infinity,
                          //       padding: EdgeInsets.symmetric(vertical: 12.h),
                          //       margin: EdgeInsets.symmetric(horizontal: 30),
                          //       decoration: BoxDecoration(
                          //         color: AppColors.primaryColor,
                          //         borderRadius: BorderRadius.circular(20.r),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: AppColors.lightGray.withOpacity(0.5),
                          //             blurRadius: 10.r,
                          //             spreadRadius: 2.w,
                          //             offset: Offset(0, 3.h),
                          //           )
                          //         ],
                          //       ),
                          //       child: Text(
                          //         "end_ride".tr,
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //             fontSize: 14.sp,
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          SizedBox(height: 10,),
                          InkWell(
                              onTap: () async {
                                Map<String, String> params = {};
                                params["_method"] = CheckStatus.PATCH.toString();
                                params["status"] = CheckStatus.COMPLETED.toString();
                                await _homeController.updateBreakDownTrip(
                                    data: params, updateState: () => setState(() {}));
                                // Future.delayed(
                                //   Duration(seconds: 4),
                                //       () async {
                                // await sendNewUserRequest();

                                //   },
                                // );
                                // _homeController.getEstimatedFare();

                                Get.back();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.lightGray.withOpacity(0.5),
                                      blurRadius: 10.r,
                                      spreadRadius: 2.w,
                                      offset: Offset(0, 3.h),
                                    )
                                  ],
                                ),
                                child: Text(
                                  "look_for_new_ride".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ), SizedBox(height: 10,),
                        ],
                      )
                      : _homeController.homeActiveTripModel.value.requests.first.request!.selected_payment == "online" ?
                  SizedBox() : InkWell(
                          onTap: () {
                            // Get.snackbar("Alert", "payment_confirm".tr,
                            //     backgroundColor: Colors.green.withOpacity(0.8),
                            //     colorText: Colors.white);
                              Map<String, String> params = {};
                              params["_method"] = CheckStatus.PATCH;
                              params["status"] = CheckStatus.COMPLETED;
                              cont.updateTripPaymentConfirm(data: params);

                          },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightGray.withOpacity(0.5),
                            blurRadius: 10.r,
                            spreadRadius: 2.w,
                            offset: Offset(0, 3.h),
                          )
                        ],
                      ),
                      child: Text(
                        "confirm_payment".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                        ),
                  // CustomButton(
                  //   text: "confirm_payment".tr,
                  //   fontSize: 14.sp,
                  //   textColor: Colors.black,
                  //   bgColor: Colors.white,
                  //   fontWeight: FontWeight.w400,
                  //   onTap: () {
                  //     Map<String, String> params = {};
                  //     params["_method"] = CheckStatus.PATCH;
                  //     params["status"] = CheckStatus.COMPLETED;
                  //     cont.updateTrip(data: params);
                  //   },
                  // )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Future<void> _showNewRideRequestDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: SingleChildScrollView(
  //           child: AlertDialog(
  //             backgroundColor: Colors.grey,
  //             iconColor: Colors.white,
  //             // icon: Align(
  //             //     alignment: Alignment.topRight,
  //             //     child: IconButton(
  //             //         onPressed: () {
  //             //           Get.back();
  //             //         },
  //             //         icon: Icon(Icons.close))),
  //             content: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text("You want to book a new ride!"),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('No'),
  //                 onPressed: () {
  //
  //                 },
  //               ),
  //               TextButton(
  //                 child: Text('Yes'),
  //                 onPressed: () async {
  //
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  double _strToDouble({required String s}) {
    double rating = 0;
    try {
      rating = double.parse(s);
    } catch (e) {
      rating = 0;
    }
    return rating;
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.removeListener(() {});
  }
}
