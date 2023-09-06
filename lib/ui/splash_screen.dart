import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/main.dart';
import 'package:mozlit_driver/preference/preference.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_in_up_screen.dart';
import 'package:mozlit_driver/ui/widget/dialog/update_app_dialog.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userLiveLocation;
String? deviceName;
String? deviceModelNumber;
String? deviceManufacture;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController _userController = Get.find();
  final UserController _homeController = Get.find();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
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
            child: Padding(
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
          child: Padding(
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
    print("position===> ${position!.longitude}");

    // setState(() {
    //   currentLat = position?.latitude;
    //   currentLat = position?.longitude;
    // });
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      String? area = place.street;
      String? sunLocality = place.subLocality;
      String? subAdministrativeArea = place.subAdministrativeArea;
      String? postalCode = place.postalCode;
      userLiveLocation =
          "$area, $sunLocality,$subAdministrativeArea,$postalCode";
      print("area==> $userLiveLocation");
      setState(() {});
    });

    return position;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceManufacture = androidInfo.manufacturer;
          deviceModelNumber = androidInfo.model;
          deviceName = androidInfo.brand;
        });
      } else {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceManufacture = iosDeviceInfo.utsname.machine;
          deviceModelNumber = iosDeviceInfo.model;
          deviceName = iosDeviceInfo.name;
        });
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  // bool isUpdate = false;



  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await initPlatformState();
      // await determinePosition();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefs = await SharedPreferences.getInstance();
      print(
          "prefs.containsKey(Database.seenOnBoarding)===>${prefs.containsKey(Database.seenOnBoarding)}");
      if (!prefs.containsKey(Database.seenOnBoarding)) {
        _showDialog();
      }


      if (prefs.containsKey(Database.seenOnBoarding)) {
        checkPermissionStatus();


        _userController.setLanguage();

        if(!AppString.testing_version_code_check_dialog!){
          if(Platform.isAndroid){
            if(int.parse(AppString.detectAndroidBuildNumber!) < int.parse(AppString.firebaseAndroidBuildNumber!) ||
                int.parse(AppString.detectAndroidVersionCode!) < int.parse(AppString.firebaseAndroidVersionCode!)){
              _userController.isUpdateApp.value = true;
            } else{
              _userController.isUpdateApp.value = false;
              Timer(const Duration(seconds: 3), () {
                if (_userController.userToken.value.accessToken != null) {
                  // _userController.currentUserApi();
                  // Get.off(()=> HomeScreen());
                  if(prefs.containsKey("base_url")){
                    setState(() {
                      ApiUrl.baseUrl = prefs.getString("base_url");
                    });
                  }
                  _userController.getUserProfileData();
                  log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_userController.selectedLanguage}");
                } else {
                  Get.off(() => SignInUpScreen());
                }
              });
            }}
          else{
            if(int.parse(AppString.detectIosBuildNumber!) < int.parse(AppString.firebaseIosBuildNumber!) &&
                int.parse(AppString.detectIosVersionCode!) <= int.parse(AppString.detectIosVersionCode!)){
              _userController.isUpdateApp.value = true;
            } else{
              _userController.isUpdateApp.value = false;
              Timer(const Duration(seconds: 3), () {
                if (_userController.userToken.value.accessToken != null) {
                  // _userController.currentUserApi();
                  // Get.off(()=> HomeScreen());
                  if(prefs.containsKey("base_url")){
                    setState(() {
                      ApiUrl.baseUrl = prefs.getString("base_url");
                    });
                  }
                  _userController.getUserProfileData();
                  log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_userController.selectedLanguage}");
                } else {
                  Get.off(() => SignInUpScreen());
                }
              });
            }
          }
        }
      }


    });


    super.initState();

  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(
              "Touk Touk Driver would like to collect location data to enable your current location to provide you the service for taxi booking and navigation even when the app is closed or not in use.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () async{
                    Database.setSeenLocationAlertDialog();
                    Get.back();

                    checkPermissionStatus();


                    _userController.setLanguage();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(!AppString.testing_version_code_check_dialog!){
                      if(Platform.isAndroid){
                        if(int.parse(AppString.detectAndroidBuildNumber!) < int.parse(AppString.firebaseAndroidBuildNumber!) ||
                            int.parse(AppString.detectAndroidVersionCode!) < int.parse(AppString.firebaseAndroidVersionCode!)){
                          _userController.isUpdateApp.value = true;
                        } else{
                          _userController.isUpdateApp.value = false;
                          Timer(const Duration(seconds: 3), () {
                            if (_userController.userToken.value.accessToken != null) {
                              // _userController.currentUserApi();
                              // Get.off(()=> HomeScreen());
                              if(prefs.containsKey("base_url")){
                                setState(() {
                                  ApiUrl.baseUrl = prefs.getString("base_url");
                                });
                              }
                              _userController.getUserProfileData();
                              log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_userController.selectedLanguage}");
                            } else {
                              Get.off(() => SignInUpScreen());
                            }
                          });
                        }}
                      else{
                        if(int.parse(AppString.detectIosBuildNumber!) < int.parse(AppString.firebaseIosBuildNumber!) &&
                            int.parse(AppString.detectIosVersionCode!) <= int.parse(AppString.detectIosVersionCode!)){
                          _userController.isUpdateApp.value = true;
                        } else{
                          _userController.isUpdateApp.value = false;
                          Timer(const Duration(seconds: 3), () {
                            if (_userController.userToken.value.accessToken != null) {
                              // _userController.currentUserApi();
                              // Get.off(()=> HomeScreen());
                              if(prefs.containsKey("base_url")){
                                setState(() {
                                  ApiUrl.baseUrl = prefs.getString("base_url");
                                });
                              }
                              _userController.getUserProfileData();
                              log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_userController.selectedLanguage}");
                            } else {
                              Get.off(() => SignInUpScreen());
                            }
                          });
                        }
                      }
                    }
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          );
        });
  }

  checkPermissionStatus()async{
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      Geolocator.requestPermission();
      // We didn't ask for permission yet or he permission has been denied before but not permanently.
      print("Permission is denined.");
    }else if(status == LocationPermission.always){
      //permission is already granted.
      location.enableBackgroundMode(enable: true);
      print("Permission is already granted.");
    }else if(status  == LocationPermission.deniedForever){
      //permission is permanently denied.
      openAppSettings();
      print("Permission is permanently denied");
    }
  }

  @override
  Widget build(BuildContext context) {

    print("sdsdsdvv==>${AppString.isForceCancleButtonShow}");

    return  Scaffold(backgroundColor: Colors.black,
    //AppColors.primaryColor,
        body: Stack(
      children: [

        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.black,
          //AppColors.primaryColor,
        ),
        Center(
          child: Image.asset(
            AppImage.logoT,
            height: 240,
            width: 240,
          ),
        ),
        // Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Column(mainAxisAlignment: MainAxisAlignment.end,children: [
        //       Text('By',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.white),),
        //       Image.asset(
        //         AppImage.mozilitNameLogo,
        //         width: MediaQuery.of(context).size.width*0.7,
        //       ),
        //       SizedBox(height: 25)
        //     ],)),
       _userController.isUpdateApp.value ? CustomAlertDialog(
         title: "Update App",
         message: "We are regularly upgrading your experience. New version of this app is available on ${Platform.isAndroid ? "Play Store" : "App Store"}, Please update app.",
         onPostivePressed: () async{
           await _userController.sendUpdateApp();
         },
         onNegativePressed: (){
           _userController.isUpdateApp.value = false;

           setState(() {});

           if (_userController.userToken.value.accessToken != null) {
             _userController.getUserProfileData();
             log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_userController.selectedLanguage}");
           } else {
             Get.off(() => SignInUpScreen());
           }
           // Navigator.pop(context);
         },
         positiveBtnText: 'Update',
         negativeBtnText: 'Cancel',
         negativeButtonShow: !AppString.isForceCancleButtonShow!,
         positiveButtonShow: true,) : SizedBox(),
        AppString.testing_version_code_check_dialog! ? CustomAlertDialog(
          title: "Check version History",
          message: "detectUser${Platform.isAndroid ? "Android" : "Ios"}BuildNumber ==>${Platform.isAndroid?AppString.detectAndroidBuildNumber:AppString.detectIosBuildNumber}\ndetectUser${Platform.isAndroid ? "Android" : "Ios"}VersionCode ===> ${Platform.isAndroid ? AppString.detectAndroidVersionCode : AppString.detectIosVersionCode} \n\n"
              "firebaseUser${Platform.isAndroid ? "Android": "Ios"}BuildNumber ===>${Platform.isAndroid?AppString.firebaseAndroidBuildNumber:AppString.firebaseIosBuildNumber}\ndetectUser${Platform.isAndroid ? "Android" : "Ios"}VersionCode ===> ${Platform.isAndroid ? AppString.firebaseAndroidVersionCode : AppString.firebaseIosVersionCode}",
        ) : SizedBox()
      ],
    ));
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
