import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/enum/provider_ui_selection_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/common.dart';

class AvailableRequestWidget extends StatefulWidget {
  const AvailableRequestWidget({Key? key}) : super(key: key);

  @override
  State<AvailableRequestWidget> createState() => _AvailableRequestWidgetState();
}

class _AvailableRequestWidgetState extends State<AvailableRequestWidget> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: GetX<HomeController>(builder: (cont) {

        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        RequestElement requestElement = RequestElement();
        if (cont.homeActiveTripModel.value.requests.isNotEmpty) {
          requestElement = cont.homeActiveTripModel.value.requests[0];
        }
        return Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(55),bottom: Radius.circular(55))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(requestElement.request?.moduleType == "TAXI"?
                              "TAXI".tr : "DELIVERY".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text("REQUEST".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "time_remaining".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        Container(
                          width: 85,height: 65,
                          alignment:  Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor2,
                              borderRadius: BorderRadius.circular(35)
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImage.clock,color: AppColors.white,height: 25,width: 25),
                              SizedBox(width: 8,),
                              Text(
                                "${cont.timeLeftToRespond.value}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 100.h,
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               "pick_up_location".tr,
                  //               style: TextStyle(
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             SizedBox(height: 15.h),
                  //             // Spacer(),
                  //             Text(
                  //               "${requestElement.request?.sAddress ?? ""}",
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //               ),
                  //               overflow: TextOverflow.ellipsis,
                  //               maxLines: 4,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         width: 1,
                  //         height: 70.h,
                  //         margin: EdgeInsets.symmetric(horizontal: 10.w),
                  //         color: AppColors.gray,
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               "drop_location".tr,
                  //               style: TextStyle(
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             SizedBox(height: 15.h),
                  //             // Spacer(),
                  //             Text(
                  //               "${requestElement.request?.dAddress ?? ""}",
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //               ),
                  //               overflow: TextOverflow.ellipsis,
                  //               maxLines: 4,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'trip_details'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16, color: AppColors.primaryColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        timelineRow("source".tr,
                            '${requestElement.request?.sAddress ?? ""}'),
                        timelineLastRow("destination".tr,
                            '${requestElement.request?.dAddress ?? ""}',),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Container(
                  //     height: 1.h,
                  //     width: double.infinity,
                  //     color: AppColors.gray,
                  //   ),
                  // ),
                  Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    padding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(85),
                          child: CustomFadeInImage(
                            url: requestElement.request?.user?.picture != null
                                ? "${ApiUrl.baseImageUrl}/${requestElement.request?.user?.picture}"
                                : "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",
                            fit: BoxFit.cover,
                            height: 55.w,
                            width: 55.w,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
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
                                // Row(
                                //   children: [
                                //     RatingBar.builder(
                                //       initialRating: _strToDouble(
                                //           s: requestElement
                                //                   .request?.user?.rating ??
                                //               "0"),
                                //       minRating: 1,
                                //       direction: Axis.horizontal,
                                //       allowHalfRating: true,
                                //       ignoreGestures: true,
                                //       itemCount: 5,
                                //       itemPadding: EdgeInsets.symmetric(
                                //           horizontal: 0.5.w),
                                //       itemBuilder: (context, _) => Icon(
                                //         Icons.star,
                                //         color: Colors.amber,
                                //       ),
                                //       itemSize: 12.w,
                                //       onRatingUpdate: (rating) {},
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [


                                    Text(
                                      '${requestElement.request?.user?.rating ?? "0"}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primaryColor),
                                    ),SizedBox(
                                      width: 3,
                                    ),Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Colors.orange[300],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(requestElement.request?.moduleType == "DELIVERY")
                    Container(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(requestElement.request?.deliveryPackageDetails != "" )
                              Text("package_details".tr,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor),),
                            Text(
                              "${requestElement.request?.deliveryPackageDetails}",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor),),

                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          cont.rejectTrip();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(55)),
                          ),
                          child: Text(
                            'decline'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                          ),
                        ),
                      ),
                      // SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                      InkWell(
                        onTap: () {
                          cont.updateTrip();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(55)),
                          ),
                          child: Text(
                            'accept'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            // SizedBox(height: 10.h),
          ],
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
}
