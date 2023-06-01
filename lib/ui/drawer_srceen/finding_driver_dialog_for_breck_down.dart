import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class FindingDriverForBreakDownDialog extends StatefulWidget {
  const FindingDriverForBreakDownDialog({Key? key}) : super(key: key);

  @override
  State<FindingDriverForBreakDownDialog> createState() =>
      FindingDriverForBreakDownDialogState();
}

class FindingDriverForBreakDownDialogState
    extends State<FindingDriverForBreakDownDialog> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    print("check karo ki aaya he");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0x705C5C5C)),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          Container(
            height: (homeController
                            .homeActiveTripModel.value.breakdown_count_check !=
                        0 &&
                    homeController.breakdownNewRideModel.value.userReqDetails!
                            .first.breakdownStatus ==
                        "searching")
                ? MediaQuery.of(context).size.height * 0.5
                :
                // ( homeController.homeActiveTripModel.value.breakdown_count_check  != 0 &&
                // homeController.breakdownNewRideModel.value.userReqDetails!.first.breakdownStatus ==  "notassign" ) ?
                // MediaQuery.of(context).size.height * 0.6 :
                MediaQuery.of(context).size.height * 0.57,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(0.0)),
            ),
            child: Column(
              children: [
                Divider(
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.32,
                  endIndent: MediaQuery.of(context).size.width * 0.32,
                ),
                SizedBox(height: 15.h),
                (homeController.homeActiveTripModel.value
                                .breakdown_count_check !=
                            0 &&
                        homeController.breakdownNewRideModel.value
                                .userReqDetails!.first.breakdownStatus ==
                            "notassign")
                    ? Text(
                        "sorry_for_inconvenience_time_Our_partner".tr,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        "We_are_searching_for_new_driver_please_wait_till_we_get_the_new_driver"
                            .tr,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                SizedBox(
                  height: 15,
                ),
                // Text(
                //   "89",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 28.sp,
                //   ),
                // ),
                SizedBox(
                  height: 15,
                ),
                (homeController.homeActiveTripModel.value
                                .breakdown_count_check !=
                            0 &&
                        homeController.breakdownNewRideModel.value
                                .userReqDetails!.first.breakdownStatus ==
                            "notassign")
                    ? SizedBox()
                    : Lottie.asset(AppImage.timerJson, fit: BoxFit.contain),
                // Container(
                //   // margin: EdgeInsets.symmetric(vertical: 20),
                //   width: 300,
                //   height: 18,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(40)),
                //     child: LinearProgressIndicator(
                //       backgroundColor: Colors.grey,
                //       // color: ,
                //       valueColor: AlwaysStoppedAnimation<Color>(
                //         Colors.black,
                //       ),
                //       // minHeight: 18,
                //       // value: 0.75,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),

                Image.asset(
                  AppImage.auto4,
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 15,
                ),
                (homeController.homeActiveTripModel.value
                                .breakdown_count_check !=
                            0 &&
                        homeController.breakdownNewRideModel.value
                                .userReqDetails!.first.breakdownStatus ==
                            "searching")
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          // _showNewRideRequestDialog();
                          Map<String, String> params = {};
                          homeController.endBreakDownTrip();
                          // params["_method"] = CheckStatus.PATCH;
                          // params["status"] = CheckStatus.COMPLETED;
                          // // updateBreakDownTrip(data: params);
                          // homeController.updateTrip(data: params);
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
                            "end_ride".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),

                (homeController.homeActiveTripModel.value
                                .breakdown_count_check !=
                            0 &&
                        homeController.breakdownNewRideModel.value
                                .userReqDetails!.first.breakdownStatus ==
                            "searching")
                    ? SizedBox()
                    : InkWell(
                        onTap: () async {
                          Map<String, String> params = {};
                          params["_method"] = CheckStatus.PATCH.toString();
                          params["status"] = CheckStatus.COMPLETED.toString();
                          await homeController
                              .repeatGetEstimatedFare(() => setState(() {}));
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
                      ),
                SizedBox(
                  height: 10,
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // TweenAnimationBuilder<Duration>(
                //     duration: Duration(minutes: 20),
                //     tween:
                //         Tween(begin: Duration(minutes: 20), end: Duration.zero),
                //     onEnd: () {
                //       print('Timer ended');
                //     },
                //     builder:
                //         (BuildContext context, Duration value, Widget? child) {
                //       final minutes = value.inMinutes;
                //       final seconds = value.inSeconds % 60;
                //       return Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 5),
                //           child: Text('Drop off by $minutes:$seconds',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: AppColors.primaryColor,
                //                   // fontWeight: FontWeight.bold,
                //                   fontSize: 14)));
                //     }),
                // Text(
                //   'Drop off by 19:50',
                //   style: TextStyle(
                //     fontSize: 16.sp,
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       isBookForSomeOne = false;
                //     });
                //     Get.bottomSheet(
                //       ReasonForCancelling(),
                //     );
                //   },
                //   child: Container(
                //     margin: EdgeInsets.symmetric(
                //       horizontal: 30.w,
                //     ),
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
                //     decoration: BoxDecoration(
                //         color: AppColors.primaryColor,
                //         borderRadius: BorderRadius.circular(20) // boxShadow: [
                //         //   BoxShadow(
                //         //       color: Colors.grey,
                //         //       blurRadius: 3)
                //         // ],
                //         ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SizedBox(
                //           width: 15,
                //         ),
                //         Text(
                //           "cancel".tr,
                //           style:
                //               TextStyle(color: Colors.white, fontSize: 16.sp),
                //         ),
                //         SizedBox(width: 20),
                //         Card(
                //           color: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(50.0),
                //           ),
                //           child: Icon(
                //             Icons.close,
                //             size: 20,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
