import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/summery_model.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class SummeryScreen extends StatefulWidget {
  @override
  _SummeryScreenState createState() => _SummeryScreenState();
}

class _SummeryScreenState extends State<SummeryScreen> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();

  int selectedSummaryIndex = 0;
  String filter = 'today';
  String _selectedItem = 'Today';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getSummery(
          providerId: _homeController
              .homeActiveTripModel.value.providerDetails!.service!.providerId
              .toString(),
          filter: filter);
      // _userController.getSummery(providerId: _homeController.tripDetails.value.providerId,filter:);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "summary".tr,
      ),
      backgroundColor: AppColors.bgColor,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        SummeryModel summeryModel = _userController.summeryModel.value;
        return Stack(
          children: [
            AwesomeDropDown(
              dropDownList: ["Today", "Weekly", "Monthly", "Yearly"],
              selectedItem: _selectedItem,
              onDropDownItemClick: (selectedItem) {
                _selectedItem = selectedItem;
                if (_selectedItem == "Today") {
                  setState(() {
                    selectedSummaryIndex = 0;
                    filter = "today";
                    _userController.getSummery(
                        providerId: _homeController.homeActiveTripModel.value
                            .providerDetails!.service!.providerId
                            .toString(),
                        filter: filter);
                  });
                } else if (_selectedItem == "Weekly") {
                  setState(() {
                    selectedSummaryIndex = 1;
                    filter = "current_week";
                    _userController.getSummery(
                        providerId: _homeController.homeActiveTripModel.value
                            .providerDetails!.service!.providerId
                            .toString(),
                        filter: filter);
                  });
                } else if (_selectedItem == "Monthly") {
                  setState(() {
                    selectedSummaryIndex = 2;
                    filter = "current_month";
                    _userController.getSummery(
                        providerId: _homeController.homeActiveTripModel.value
                            .providerDetails!.service!.providerId
                            .toString(),
                        filter: filter);
                  });
                } else {
                  setState(() {
                    selectedSummaryIndex = 3;
                    filter = "current_year";
                    _userController.getSummery(
                        providerId: _homeController.homeActiveTripModel.value
                            .providerDetails!.service!.providerId
                            .toString(),
                        filter: filter);
                  });
                }
              },
            ), //   dropDownList: summaryList,
            //   onDropDownItemClick: (selectedItem) {
            //     setState(() {});
            //     // _selectedItem = selectedItem;
            //     if (selectedItem == "Today") {
            //       print("Today");
            //     } else if (selectedItem == "Weekly") {
            //       print("Weekly");
            //     } else if (selectedItem == "Monthly") {
            //       print("Monthly");
            //     } else {
            //       print("Yearly");
            //     }
            //   },
            // ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 17.h),
                    _summeryListCard(
                        title: "total_no_of_rides".tr,
                        description: "${summeryModel.rides ?? "0"}",
                        icon: Icons.car_repair,
                        bgColor: AppColors.summeryColor1),
                    SizedBox(height: 10.h),
                    _summeryListCard(
                        title: "revenue".tr,
                        description:
                            "${(double.tryParse((summeryModel.revenue ?? 0).toString()) ?? 0).toStringAsFixed(2)} ${cont.userData.value.currency ?? ""}",
                        icon: Icons.car_repair,
                        bgColor: AppColors.summeryColor2),
                    SizedBox(height: 10.h),
                    _summeryListCard(
                        title: "no._of_scheduled_rides".tr,
                        description: "${summeryModel.scheduledRides ?? 0}",
                        icon: Icons.timer,
                        bgColor: AppColors.summeryColor3),
                    SizedBox(height: 10.h),
                    _summeryListCard(
                        title: "cancelled_ride".tr,
                        description: "${summeryModel.cancelRides ?? 0}",
                        icon: Icons.cancel_rounded,
                        bgColor: AppColors.summeryColor4),
                    SizedBox(height: 10.h),
                    _summeryListCard(
                        title: "total_km_distance".tr,
                        description: "${summeryModel.totalKmDistance ?? 0}",
                        icon: Icons.social_distance_outlined,
                        bgColor: AppColors.underLineColor),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summeryListCard({title, description, icon, bgColor}) {
    return Container(
        height: 60.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            AppBoxShadow.defaultShadow(),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 12.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 70.w,
              decoration: BoxDecoration(
                color: bgColor,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.w,
                ),
              ),
            ),
          ],
        ));
  }
}
