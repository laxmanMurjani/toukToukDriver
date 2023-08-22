import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/util/app_constant.dart';

Widget divider() {
  return Container(
    width: double.infinity,
    height: 1.5.h,
    color: AppColors.bgColor,
  );
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  print("lat1===>${lat1}");
  print("lon1===>${lon1}");
  print("lat2===>${lat2}");
  print("lon2===>${lon2}");
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  print("dddistance===> ${12742 * asin(sqrt(a))}");
  String total = (12742 * asin(sqrt(a))).toStringAsFixed(2);
   double finalTotal = double.parse(total);
  print("sssss===> $finalTotal");
  return finalTotal;
}

Widget timelineRow(String title, String subTile) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(""),
            ),
            Container(
              width: 1,
              height: 40,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
              ),
              child: Text(""),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${title}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "${subTile}",
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget timelineLastRow(String title, String subTile) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: new BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(""),
            ),
            Container(
              width: 3,
              height: 20,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
              ),
              child: Text(""),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${title}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "${subTile}",
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    ],
  );
}

/// request fack call

Future<void> makeFakeCallInComing({String? callerName, String? mobileNumber,String? imageUser}) async {
  await Future.delayed(const Duration(seconds: 1), () async {
    // _currentUuid = _uuid.v4();
    print("sdksndkd===>${imageUser}");
    final params = CallKitParams(
      id: '12',
      nameCaller: callerName,
      appName: 'Touk Touk Driver',
      avatar: "https://play-lh.googleusercontent.com/9Qm10YEcGa9e4xh4FOiVyoTHE5aNrB9TfFWC2dgvmzbZxhQX0VQKDDz5L3GJBcxIyg=w280-h280",
      handle: mobileNumber,
      type: 0,
      duration: 100000,
      textAccept: 'Accept',
      textDecline: 'Reject',
      // missedCallNotification:  NotificationParams(
      //   showNotification: true,
      //   isShowCallback: true,
      //   subtitle: 'Missed call',
      //   callbackText: 'Call back',
      // ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android:  AndroidParams(
        isCustomNotification: false,
        isShowLogo: true,
        // ringtonePath: 'system_ringtone_default',
        backgroundColor: '#000000',
        isCustomSmallExNotification: false,
        // backgroundUrl: AppImage.fullLogo,
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios:  IOSParams(
        iconName: 'Touk Touk Driver',
        handleType: mobileNumber,
        supportsVideo: false,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        // ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  });
}
