import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/earning_model.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EarningScreen extends StatefulWidget {
  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  final DateFormat _dateFormat = DateFormat("hh:mm a");
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getEarning();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(
        text: "earnings".tr,
      ),
      backgroundColor: AppColors.bgColor,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        EarningModel earningModel = cont.earningModel.value;
        double totalEarning = 0;
        earningModel.rides.forEach((element) {
          totalEarning += element.payment?.providerPay ?? 0;
        });
        List<ChartData> chartData = [];
        chartData.add(ChartData(
            "Fill",
            double.tryParse("${earningModel.ridesCount ?? 0}") ?? 0,
            AppColors.primaryColor));
        chartData.add(ChartData(
            "UnFill",
            (double.tryParse("${earningModel.ridesCount ?? 0}") ?? 0) -
                (double.tryParse("${earningModel.target ?? 0}") ?? 0),
            AppColors.lightGray));
        return Stack(
          children: [
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 100.0),
            //     child: Image.asset(
            //       AppImage.logoOpacity,
            //       width: 300,
            //       height: 300,
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "today's_completed_target".tr,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "total_earning".tr,
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "${cont.userData.value.currency ?? ""} $totalEarning",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 120.w,
                                width: 120.w,
                                child: SfCircularChart(
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${earningModel.ridesCount}/${earningModel.target}',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 3.h),
                                            Text(
                                              'total_trips'.tr,
                                              style: TextStyle(
                                                  color: AppColors.lightGray,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                  series: <CircularSeries>[
                                    // Renders doughnut chart
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartData,
                                      pointColorMapper: (ChartData data, _) =>
                                          data.color,
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      radius: '100%',
                                      cornerStyle: CornerStyle.bothFlat,
                                      animationDelay: 0.1,
                                      innerRadius: '80%',
                                      name: "er",
                                    )
                                  ],
                                  backgroundColor: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.h),
                        Divider(
                          thickness: 1.5.h,
                          color: AppColors.bgColor,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: _ListTilewidget(
                            title1: "time".tr,
                            title2: "distance".tr,
                            title3: "amount".tr,
                          ),
                        ),
                        Divider(
                          thickness: 1.5.h,
                          color: AppColors.bgColor,
                        ),
                        ListView.separated(
                          itemCount: earningModel.rides.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Ride ride = earningModel.rides[index];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: _ListTilewidget(
                                  title1:
                                      "${_dateFormat.format(ride.createdAt ?? DateTime.now())}",
                                  title2: "${ride.distance ?? "0"} ${"km".tr}",
                                  title3:
                                      "${ride.payment?.providerPay ?? "0"}${cont.userData.value.currency ?? ""}"),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1.5.h,
                              color: AppColors.bgColor,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  _ListTilewidget({title1, title2, title3}) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
              child: Text(title1,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      fontSize: 15)),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              child: Text(title2,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      fontSize: 15)),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              child: Text(title3,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
