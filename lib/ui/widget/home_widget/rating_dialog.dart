import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/base_controller.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/dialog/rating_feedback_dialog.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class RatingDialog extends StatefulWidget {
  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final BaseController _baseController = BaseController();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40.r),
                ),
              ),
              child: GetX<HomeController>(builder: (cont) {
                if (cont.error.value.errorType == ErrorType.internet) {
                  return NoInternetWidget();
                }
                RequestElement requestElement = RequestElement();
                if (cont.homeActiveTripModel.value.requests.isEmpty) {
                  return Container(
                    height: 300.h,
                    alignment: Alignment.center,
                    child: Text("no_data_found".tr),
                  );
                }
                requestElement = cont.homeActiveTripModel.value.requests[0];
                RequestElement datum =
                    cont.homeActiveTripModel.value.requests[0];
                User provider = datum.request?.user ?? User();

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "${"ratings_your_trip_with".tr} ${provider.firstName ?? ""} ${provider.lastName ?? ""}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15.h),

                      Container(
                        height: 90.w,
                        width: 90.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.bgColor
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              height: 70.w,
                              width: 70.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CustomFadeInImage(
                                //url: "${ApiUrl.baseImageUrl}${provider.picture}",
                                url:requestElement.request?.user?.picture!=null?
                                "${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture}" :
                                "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",
                                placeHolder: AppImage.icUserPlaceholder,
                                fit: BoxFit.cover,
                              ),
                            ),
                            cont.homeActiveTripModel.value.userVerifyCheck == null? SizedBox() :
                            cont.homeActiveTripModel.value.userVerifyCheck == 'verified'?
                            Positioned(bottom:0, right:0,child: Container(height:25, width:25,decoration: BoxDecoration(
                                color:Colors.white,shape: BoxShape.circle
                            ),
                                child: Image.asset(AppImage.verifiedIcon,height: 25,width: 25,)),) : SizedBox()
                          ],
                        ),
                      ),
                      SizedBox(height: 7.h),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppColors.primaryColor,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                          _rating = rating;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.to(RatingFeedbackDialog(
                                rating: _rating.toInt(),
                              ));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              alignment: Alignment.center,
                              child: Text("feedback_for_the_user".tr,

                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                          // InkWell(
                          //   child: Container(
                          //     height: 55,
                          //     width: MediaQuery.of(context).size.width * 0.42,
                          //     decoration: BoxDecoration(
                          //         color: AppColors.bgColor,
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(5))),
                          //     alignment: Alignment.center,
                          //     child: Text("Feedback for \nETO",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 15,
                          //           color: AppColors.primaryColor,
                          //         )),
                          //   ),
                          // ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {},
                      //       child: Container(
                      //         height: 55,
                      //         width: MediaQuery.of(context).size.width * 0.42,
                      //         decoration: BoxDecoration(
                      //             color: AppColors.bgColor,
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(5))),
                      //         alignment: Alignment.center,
                      //         child: Text("Feedback for the\ndriver",
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 15,
                      //               color: AppColors.primaryColor,
                      //             )),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       child: Container(
                      //         height: 55,
                      //         width: MediaQuery.of(context).size.width * 0.42,
                      //         decoration: BoxDecoration(
                      //             color: AppColors.bgColor,
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(5))),
                      //         alignment: Alignment.center,
                      //         child: Text("Feedback for \nETO",
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 15,
                      //               color: AppColors.primaryColor,
                      //             )),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 10.w, vertical: 5.h),
                      //   decoration: BoxDecoration(
                      //       color: Color(0xffE3E3E3),
                      //       border: Border.all(
                      //         color: Colors.transparent,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10.r)),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: "Leave a Feedback",
                      //         hintStyle: TextStyle(fontSize: 12),
                      //         isDense: true,
                      //         contentPadding: EdgeInsets.zero),
                      //     // minLines: 4,
                      //     // maxLines: 4,
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 15.w, vertical: 15.h),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.black45,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10.r)),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: "write_your_comment".tr,
                      //         isDense: true,
                      //         contentPadding: EdgeInsets.zero),
                      //     minLines: 4,
                      //     maxLines: 4,
                      //   ),
                      // ),
                      SizedBox(height: 30.h),
                      InkWell(
                        onTap: () async {
                          String? msg = await cont.providerRate(
                              rating: "5", comment: "null");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "submit".tr,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
