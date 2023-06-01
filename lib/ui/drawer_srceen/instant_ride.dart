import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/QrCodeScanScreen.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mozlit_driver/svg_icon.dart';

class InstantRide extends StatefulWidget {
  const InstantRide({Key? key}) : super(key: key);

  @override
  _InstantRideState createState() => _InstantRideState();
}

class _InstantRideState extends State<InstantRide> {
  GoogleMapController? _controller;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final List<Marker> _markers = [];
  PolylineId id = PolylineId('poly');
  final List<Polyline> _polyLine = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSwitched = false;
  bool isSwitch = false;
  final GlobalKey _phoneNumberKey = GlobalKey();
  final GlobalKey _endAddressKey = GlobalKey();
  LatLng? _cameraMoveLatlng;
  final HomeController _homeController = Get.find();
  String? _mapStyle;
  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
    _homeController.instantRideClearData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GetX<UserController>(builder: (userCont) {
        if (userCont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return GetX<HomeController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }

          String? profileUrl;
          if (userCont.userData.value.avatar != null) {
            profileUrl =
                "${ApiUrl.baseImageUrl}${userCont.userData.value.avatar ?? ""}";
          }

          bool isInitLatLng = cont.latLngWhereTo1 != null;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Image.asset(
                                AppImage.back,
                                width: 20.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(width: 5.w),
                          Text(
                            "instant_ride".tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: () async {
                              if (isInitLatLng) {
                                cont.fareWithOutAuth();
                              }
                            },
                            child: Text(
                              "done".tr,
                              style: TextStyle(
                                color:
                                    isInitLatLng ? Colors.black : Colors.grey,
                                fontSize: 15.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Stack(
                        children: [
                          if (_phoneNumberKey.currentContext
                                      ?.findRenderObject() !=
                                  null &&
                              _endAddressKey.currentContext
                                      ?.findRenderObject() !=
                                  null)
                            Transform(
                              transform: Matrix4.translationValues(0, 0, 0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w,
                                    top: ((_phoneNumberKey.currentContext
                                                    ?.findRenderObject()
                                                as RenderBox)
                                            .size
                                            .height /
                                        2)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: DottedLine(
                                    direction: Axis.vertical,
                                    dashColor: Colors.black,
                                    lineLength: (((_phoneNumberKey
                                                            .currentContext
                                                            ?.findRenderObject()
                                                        as RenderBox)
                                                    .size
                                                    .height /
                                                2) +
                                            ((_endAddressKey.currentContext
                                                            ?.findRenderObject()
                                                        as RenderBox)
                                                    .size
                                                    .height /
                                                2)) +
                                        10.h,
                                    dashLength: 3,
                                  ),
                                ),
                              ),
                            ),
                          Column(
                            children: [
                              Row(
                                key: _phoneNumberKey,
                                children: [
                                  Image.asset(
                                    AppImage.srcIcon,
                                    width: 18.w,
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                      child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        boxShadow: [
                                          AppBoxShadow.defaultShadow(),
                                        ]),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 15.w),
                                        CountryCodePicker(
                                          onChanged: (CountryCode countryCode) {
                                            print(
                                                "  ==>  ${countryCode.dialCode}");
                                            if (countryCode.dialCode != null) {
                                              cont.countryCode.value =
                                                  countryCode.dialCode!;
                                            }
                                          },
                                          initialSelection:
                                              cont.countryCode.value,
                                          // favorite: ['+91', 'IN'],
                                          // countryFilter: ['IT', 'FR', 'IN'],
                                          showFlagDialog: true,
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                          ),
                                          comparator: (a, b) => b.name!
                                              .compareTo(a.name.toString()),
                                          //Get the country information relevant to the initial selection
                                          onInit: (code) => print(
                                              "on init ${code!.name} ${code.dialCode} ${code.name}"),
                                          padding: EdgeInsets.zero,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                cont.tempMobileNumberController,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "phone_number".tr,
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Color(0xff9F9F9F),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 0.w,
                                                vertical: 12.h,
                                              ),
                                              isDense: true,
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (s) async {
                                              // await cont.getLocationFromAddress(
                                              //     address: s);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  SizedBox(width: 10.w),
                                  InkWell(
                                    onTap: () {
                                      cont.removeUnFocusManager();
                                      Get.to(() => QrCodeScanScreen());
                                    },
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      padding: EdgeInsets.all(7.w),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            AppBoxShadow.defaultShadow(),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      child: Image.asset(AppImage.icQrScan),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                key: _endAddressKey,
                                children: [
                                  Image.asset(
                                    AppImage.multiDestIcon,
                                    width: 18.w,
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                      child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        boxShadow: [
                                          AppBoxShadow.defaultShadow(),
                                        ]),
                                    child: TextFormField(
                                      focusNode: cont.locationWhereToFocusNode,
                                      controller: cont.tempLocationWhereTo1,

                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "where_to".tr,
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xff9F9F9F)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 12.h),
                                      ),
                                      onChanged: (s) async {
                                        await cont.getLocationFromAddress(
                                          address: s,
                                        );
                                      },
                                    ),
                                  )),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("pick_from_map".tr),
                          Spacer(),
                          Switch(
                            onChanged: (v) {
                              cont.isPickFromMap.value = v;
                            },
                            value: cont.isPickFromMap.value,
                            activeColor: AppColors.primaryColor,
                            activeTrackColor: AppColors.primaryColor,
                            inactiveThumbColor: AppColors.gray,
                            inactiveTrackColor:
                                AppColors.lightGray.withOpacity(0.8),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                mapToolbarEnabled: false,
                                zoomControlsEnabled: false,
                                rotateGesturesEnabled: false,
                                onMapCreated: (GoogleMapController controller) {
                                  controller.setMapStyle(_mapStyle);
                                  _controller = controller;
                                  determinePosition();
                                },
                                onCameraIdle: () {
                                  print("CameraMove ==>   onCameraIdle");
                                  if (_cameraMoveLatlng != null &&
                                      cont.isPickFromMap.value) {
                                    cont.searchAddressList.clear();
                                    if (cont
                                        .locationWhereToFocusNode.hasFocus) {
                                      cont
                                          .getLocationAddress(
                                              latLng: _cameraMoveLatlng!,
                                              isFromAddress: false)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    }
                                  }
                                },
                                onCameraMoveStarted: () {
                                  print("CameraMove ==>   onCameraMoveStarted");
                                },
                                onCameraMove: (CameraPosition cameraPosition) {
                                  print(
                                      "CameraMove ==>  ${cameraPosition.target}");
                                  _cameraMoveLatlng = cameraPosition.target;
                                },
                                onTap: (LatLng latLng) {
                                  showMarker(latLng: latLng);
                                },
                              ),
                              if (cont.isPickFromMap.value)
                                Image.asset(
                                  AppImage.icPin,
                                  width: 30.w,
                                )
                            ],
                          ),
                          if (!cont.isPickFromMap.value) ...[
                            Container(
                              margin: EdgeInsets.only(
                                  right: 15.w, left: 15.w, top: 70.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (cont.searchAddressList.isNotEmpty)
                                        ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                          ),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            AutocompletePrediction
                                                autocompletePrediction =
                                                cont.searchAddressList[index];
                                            return InkWell(
                                              onTap: () {
                                                if (cont
                                                    .locationWhereToFocusNode
                                                    .hasFocus) {
                                                  cont.tempLocationWhereTo1
                                                          .text =
                                                      autocompletePrediction
                                                              .description ??
                                                          "";
                                                }
                                                cont
                                                    .getPlaceIdToLatLag(
                                                        placeId:
                                                            autocompletePrediction
                                                                .placeId!)
                                                    .then((value) {
                                                  cont.removeUnFocusManager();
                                                  setState(() {});
                                                });
                                                cont.searchAddressList.clear();
                                              },
                                              child: Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(autocompletePrediction
                                                                  .description ??
                                                              ""),
                                                          // Text(
                                                          //   autocompletePrediction.description ??
                                                          //       "",
                                                          //   style: TextStyle(
                                                          //     color: Colors.grey,
                                                          //   ),
                                                          // ),
                                                          if (cont.searchAddressList
                                                                      .length -
                                                                  1 !=
                                                              index)
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5.h),
                                                              width: double
                                                                  .infinity,
                                                              height: 1.h,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              cont.searchAddressList.length,
                                          shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                        ),
                                    ]),
                              ),
                            )
                          ],
                          Container(
                            padding: EdgeInsets.only(
                              right: 20.w,
                              left: 20.w,
                              bottom: 15.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 6.r,
                                  offset: Offset(0, 5.h),
                                )
                              ],
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(38.r),
                              ),
                            ),
                            child: SizedBox(
                              height: 10.h,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
      }),
    );
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetBar(
          messageText:  Text(
            "location_permissions_are_denied".tr,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          mainButton: InkWell(
            onTap: () {},
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "allow".tr,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
    }
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.showSnackbar(GetBar(
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        mainButton: InkWell(
          onTap: () {},
          child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "allow".tr,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ));
    }
    if (position != null) {
      showMarker(latLng: LatLng(position.latitude, position.longitude));
    }
    return position;
  }

  Future<void> showMarker({required LatLng latLng}) async {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 14.4746,
    );

    _markers.add(Marker(markerId: const MarkerId("first"), position: latLng));
    _controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppString.googleMapKey!,
        const PointLatLng(21.1702, 72.8311),
        const PointLatLng(21.1418, 72.7709),
        travelMode: TravelMode.driving);
    List<LatLng> points = <LatLng>[];
    for (var element in result.points) {
      points.add(LatLng(element.latitude, element.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: points,
      width: 3,
    );
    _polyLine.add(polyline);

    setState(() {});
  }

  openAlertBox() {
    return showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.orange,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(29.0.r),
                ),
              ),
              content: Container(
                height: 270.h,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(29.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 12),
                      blurRadius: 16.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 14.h,
                    ),
                    for (int i = 0; i < 6; i++)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 8.w),
                                SvgPicture.string(
                                  pendingIcon,
                                  height: 18.h,
                                  width: 21.w,
                                  allowDrawingOutsideViewBox: true,
                                  fit: BoxFit.fill,
                                  color: Color(0xff9F9F9F),
                                )
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(
                                  left: 25.w, top: 6.h, bottom: 6.h),
                              child: Divider(
                                thickness: 2,
                                color: Color(0xffD1D1D1),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ));
        });
  }
}
