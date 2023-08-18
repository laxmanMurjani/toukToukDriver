import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/api/api_service.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/splash_screen.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/firebase_service.dart';
import 'package:mozlit_driver/util/languages.dart';
import 'package:mozlit_driver/util/remote_config_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wakelock/wakelock.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // try {
  //   // showLoader();
  //   await apiService.getRequest(
  //     url: ApiUrl.ringTone,
  //     onSuccess: (Map<String, dynamic> data) {
  //       print('daataa: ${data['response']}');
  //       print('krunal:');
  //       // dismissLoader();
  //       // tripHistoryModelList.clear();
  //       // tripHistoryModelList
  //       //     .addAll(tripHistoryModelFromJson(jsonEncode(data["response"])));
  //     },
  //     onError: (ErrorType? errorType, String? msg) {
  //       // showError(msg: msg);
  //     },
  //   );
  // } catch (e) {
  //   print("Error ==>$e");
  //   // showError(msg: "$e");
  // }
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'app notification', // id
    'App Related Notification', // title
    playSound: true,
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('wav')
  // playSound: true
);

Location location = Location();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Wakelock.enable();
  location.enableBackgroundMode(enable: true);
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  await RemoteConfigService.setupRemoteConfig();
  AppString.googleMapKey =firebaseRemoteConfig.getString("map_key");
  ApiUrl.baseUrl =firebaseRemoteConfig.getString("base_url");
  AppString.isForceCancleButtonShow = Platform.isAndroid ? firebaseRemoteConfig.getBool("isForceUpdateAndroid") : firebaseRemoteConfig.getBool("isForceUpdateIos");
  AppString.firebaseAndroidBuildNumber =firebaseRemoteConfig.getString("androidBuildNumber");
  AppString.firebaseAndroidVersionCode =firebaseRemoteConfig.getString("androidVersionCode");
  AppString.firebaseIosBuildNumber =firebaseRemoteConfig.getString("iosBuildNumber");
  AppString.firebaseIosVersionCode =firebaseRemoteConfig.getString("iosVersionCode");
  AppString.testing_version_code_check_dialog = firebaseRemoteConfig.getBool("testing_version_code_check_dialog");

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if(Platform.isAndroid){
    AppString.detectAndroidBuildNumber = packageInfo.version.replaceAll(".", "");
    AppString.detectAndroidVersionCode = packageInfo.buildNumber;
  } else {
    AppString.detectIosBuildNumber = packageInfo.version.replaceAll(".", "");
    AppString.detectIosVersionCode = packageInfo.buildNumber;
  }


  print("sdnmdn===>${AppString.googleMapKey}  ${AppString.firebaseAndroidBuildNumber}  ${AppString.firebaseAndroidVersionCode}  ${AppString.detectAndroidBuildNumber}  ${AppString.detectAndroidVersionCode}  ${AppString.isForceCancleButtonShow}");



  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  // late LocationSettings locationSettings;
  //
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   locationSettings = AndroidSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 0,
  //       forceLocationManager: true,
  //       intervalDuration: const Duration(seconds: 1),
  //       //(Optional) Set foreground notification config to keep the app alive
  //       //when going to the background
  //       // foregroundNotificationConfig: const ForegroundNotificationConfig(
  //       //   notificationText:
  //       //   "ETO Ride Driver Running Background",
  //       //   notificationTitle: "ETO Ride Driver",
  //       //   enableWakeLock: true,
  //       // )
  //   );
  // }
  // else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  //   locationSettings = AppleSettings(
  //     accuracy: LocationAccuracy.high,
  //     activityType: ActivityType.automotiveNavigation,
  //     distanceFilter: 0,
  //     pauseLocationUpdatesAutomatically: true,
  //     // Only set to true if our app will be started up in the background.
  //     showBackgroundLocationIndicator: false,
  //   );
  // } else {
  //   locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 0,
  //   );
  // }

  // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
  //         (Position? position) {
  //       print(position == null ? 'Unknown' : 'llllat==>${position.latitude.toString()},lonng==> ${position.longitude.toString()}');
  //     });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserController _userController = Get.put(UserController());
  final HomeController _homeController = Get.put(HomeController());
  //final  _homeController = Get.lazyPut(()=>HomeController());

  @override
  void initState() {
    super.initState();
    FirebaseService.loginUpdateToken('');
    log("///////////////////////////////////////////////////////////////////////${_userController.selectedLanguage.value}");

    FirebaseMessaging.onBackgroundMessage((message) {
      log("RemoteMessage  ===>  12   ${message.data}");
      print("RemoteMessage  ===>  12   ${message.data}");
      return Future.value(true);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      log("RemoteMessage  ===>  ${message.data}");
      print("RemoteMessage  ===>  ${message.data}");

      final sound = "wav.wav";

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android:AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              importance: Importance.high,
              sound: RawResourceAndroidNotificationSound(sound.split(".").first),
              icon: "@mipmap/ic_launcher",

            ),
          ),
        );
      } else if (notification != null && appleNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   AppleNotification? appleNotification = message.notification?.apple;
    //   log("RemoteMessage  ===>  ${message.data}");
    //   print("RemoteMessage  ===>  ${message.data}");
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           playSound: true,
    //           importance: Importance.high,
    //           sound: RawResourceAndroidNotificationSound('notification'),
    //           icon: "@mipmap/ic_launcher",
    //         ),
    //       ),
    //     );
    //   } else if (notification != null && appleNotification != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //           iOS: DarwinNotificationDetails(
    //         presentAlert: true,
    //         presentBadge: true,
    //         presentSound: true,
    //         sound: "notification"
    //
    //       )),
    //     );
    //   }
    // });

  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Languages(),
        locale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),
        theme: ThemeData(
            primarySwatch: _primaryColor,
            // textTheme: GoogleFonts.montserratTextTheme(
            //   Theme.of(context).textTheme,
            // ),
            fontFamily: 'Poppins'
        ),
        home: child,
        // home: HomeScreen(),
      ),
      child: SplashScreen(),
    );
  }

  MaterialColor _primaryColor = MaterialColor(AppColors.primaryColor.value, {
    50: AppColors.primaryColor,
    100: AppColors.primaryColor,
    200: AppColors.primaryColor,
    300: AppColors.primaryColor,
    400: AppColors.primaryColor,
    500: AppColors.primaryColor,
    600: AppColors.primaryColor,
    700: AppColors.primaryColor,
    800: AppColors.primaryColor,
    900: AppColors.primaryColor,
  });
}
