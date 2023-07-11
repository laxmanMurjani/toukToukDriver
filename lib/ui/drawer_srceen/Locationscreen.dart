import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
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

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  void toggleSwitch1(bool value) {
    if (isSwitch == false) {
      setState(() {
        isSwitch = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitch = false;
      });
    }
  }

  String? _mapStyle;

  @override
  void initState() {
    // TODO: implement initState
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 275.h),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          AppImage.back,
                          width: 25.w,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.perm_identity_outlined, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "nio_demo".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "done".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            height: 20.h,
                            width: 20.h,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                            child: Container(
                              height: 10.h,
                              width: 10.h,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "from_to".tr,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                          )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 11),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DottedLine(
                            direction: Axis.vertical,
                            dashColor: Colors.black,
                            lineLength: 30,
                            dashLength: 5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            height: 20.h,
                            width: 20.h,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurpleAccent),
                            child: Container(
                              height: 10.h,
                              width: 10.h,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "where_to".tr,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("pick_from_map".tr),
                          Spacer(),
                          Switch(
                            onChanged: toggleSwitch,
                            value: isSwitched,
                            activeColor: AppColors.primaryColor,
                            activeTrackColor: AppColors.primaryColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("round_trip".tr),
                          Spacer(),
                          Switch(
                            onChanged: toggleSwitch1,
                            value: isSwitch,
                            activeColor: AppColors.primaryColor,
                            activeTrackColor: AppColors.primaryColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(_polyLine),
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(_mapStyle);
              _controller = controller;
              determinePosition();
            },
          ),
        ],
      ),
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
          messageText: Text(
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
                  fontSize: 16,
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ));
      // showError(msg: e.toString());
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
    _controller?.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppString.googleMapKey!, const PointLatLng(21.1702, 72.8311), const PointLatLng(21.1418, 72.7709),
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
}
