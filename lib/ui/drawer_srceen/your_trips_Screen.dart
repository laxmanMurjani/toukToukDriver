import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/trip_history_model.dart';
import 'package:mozlit_driver/ui/drawer_srceen/past_trips_details_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class YourTripsScreen extends StatefulWidget {
  @override
  _YourTripsScreenState createState() => _YourTripsScreenState();
}

class _YourTripsScreenState extends State<YourTripsScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy KK:mm a");
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.getTripHistoryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(text: "your_trips".tr),
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return cont.tripHistoryModelList.isEmpty
            ? Center(
                child: Text("No Data Found"),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: cont.tripHistoryModelList.length,
                itemBuilder: (context, index) {
                  TripHistoryModel tripDataModel =
                      cont.tripHistoryModelList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => PastTripDetailsScreen(
                            tripId: tripDataModel.id,
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.only(bottom: 10.h),
                      width: MediaQuery.of(context).size.width,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          AppBoxShadow.defaultShadow(),
                        ],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            // borderRadius: BorderRadius.circular(15.r),
                            // child: Image.asset(
                            //   AppImage.root,
                            //   fit: BoxFit.cover,
                            //   height: 150.h,
                            //   width: MediaQuery.of(context).size.width,
                            // ),
                            clipBehavior: Clip.antiAlias,
                            child: CustomFadeInImage(
                              url: tripDataModel.staticMap ?? "",
                              width: double.infinity,
                              placeHolder: AppImage.root,
                              height: 125.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_dateFormat.format(tripDataModel.finishedAt ?? DateTime.now())}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${tripDataModel.bookingId ?? ""}",
                                        style: TextStyle(
                                          color: AppColors.lightGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 35.h,
                                  width: 1.5.w,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  color: AppColors.underLineColor,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "${tripDataModel.serviceType?.name ?? ""}",
                                      style: TextStyle(
                                        color: AppColors.lightGray,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
