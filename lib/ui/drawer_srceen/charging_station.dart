import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/charging_station_cal_distance_model.dart';
import 'package:mozlit_driver/model/charging_station_model.dart';
import 'package:mozlit_driver/ui/profile_page.dart';
import 'package:mozlit_driver/ui/splash_screen.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ChargingStation extends StatefulWidget {
  const ChargingStation({Key? key}) : super(key: key);

  @override
  State<ChargingStation> createState() => _ChargingStationState();
}

class _ChargingStationState extends State<ChargingStation> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  // List<ChargingStationCalDistanceModel> calDistance = [];
  @override
  void initState() {
    // TODO: implement initState
    // getCalculateDistanceWiseData();
    //print(userController.chargingStationModel.value.chargingStation[i].address);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      userController.getChargingStation(liveLat: homeController.userCurrentLocation!.latitude.toString(),
      liveLong: homeController.userCurrentLocation!.longitude.toString()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GetX<HomeController>(builder: (homeCont) {
      if (homeCont.error.value.errorType == ErrorType.internet) {
        return NoInternetWidget();
      }

      return Scaffold(
        // appBar: CustomAppBar(text: "Profile Page"),
        appBar: CustomAppBar(
          text: "Charging Station".tr,
        ),
        backgroundColor: Colors.white,
        body: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
            child: cont.chargingStationModel.value.chargingStation!.isEmpty
                ? Center(child: Text("No data found"))
                : ListView.builder(
                    itemCount:
                    cont.chargingStationModel.value.chargingStation!.length,
                    itemBuilder: (context, index) {
                      // print("cont.chargingStationModel==> ${cont.totalList.length}");
                      return customSavedAddressesWid(
                          cont.chargingStationModel.value.chargingStation![index].station!,
                          cont.chargingStationModel.value.chargingStation![index].desination!,
                          cont.chargingStationModel.value.chargingStation![index].km!,
                          cont.chargingStationModel.value.chargingStation![index].time!,
                          callOnTap: () => () {
                                print("call On Tap");
                                _makePhoneCall(
                                    'tel:+91${cont.chargingStationModel.value.chargingStation![index].phone}');
                              },
                          locationArrowOnTap: () => () {
                                print("locationArrowOnTap");
                                openMap(lat: cont.chargingStationModel.value.chargingStation![index].latitude!,
                                long: cont.chargingStationModel.value.chargingStation![index].longitude!
                                );
                              });
                    },
                  ),
          );
        }),
      );
    });
  }



  Widget customSavedAddressesWid(String stationName, String add, String kmText,String time,
      {Function? locationArrowOnTap, Function? callOnTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          AppBoxShadow.defaultShadow(),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(stationName,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(add,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.29,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffF1F2F3),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Text("$kmText",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                    Text("${time.replaceAll("hours", "h").replaceAll("mins", "m")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              InkWell(
                onTap: callOnTap!.call(),
                child: Container(
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: Colors.grey,
                      // borderRadius: BorderRadius.only(
                      //   topRight: Radius.circular(10),
                      //   bottomLeft: Radius.circular(10),
                      // ),
                      ),
                  child: Image.asset(AppImage.call,
                      fit: BoxFit.contain, width: 35, height: 35),
                ),
              ),
              InkWell(
                onTap: locationArrowOnTap!.call(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.29,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Image.asset(AppImage.locationArrow,
                      fit: BoxFit.contain, height: 40, width: 40),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openMap({String? lat,String? long}) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
