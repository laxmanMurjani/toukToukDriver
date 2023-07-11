import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/provider_ui_selection_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/home_screen.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class MessangerChatHead extends StatefulWidget {
  const MessangerChatHead({Key? key}) : super(key: key);

  @override
  State<MessangerChatHead> createState() => _MessangerChatHeadState();
}

class _MessangerChatHeadState extends State<MessangerChatHead> {
  final HomeController _homeController = Get.find();
  //final  _homeController = Get.lazyPut(()=>HomeController());

  // final UserController _userController = Get.put(UserController());
  Timer? _requestTimer;
  Color color = const Color(0xFFFFFFFF);
  BoxShape _currentShape = BoxShape.circle;
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;

  @override
  void initState() {
    super.initState();
      print("dshsssss===>${_homeController.isOverlay.value}");

    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    log("$res : HOME");
    _receivePort.listen((message) {
      log("message from UI: $message");
      setState(() {
        messageFromOverlay = 'message from UI: $message';
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () async {
          print("dfhdgfhdgf");
          // if (Platform.isAndroid) {
          //   final AndroidIntent intent = AndroidIntent(
          //     action: 'action_view',
          //     data: 'package:com.touktouktaxi.driver', // replace com.example.app with your applicationId
          //   );
          //   await intent.launch();
          // }
          if (Platform.isAndroid) {
            final extras = json.encode({
              "Amount": 'amount',
              "Operation": 'operation',
              "TransactionID": 'transActionId',
            });
            final intent = AndroidIntent(
              action: 'action_view',
              package: 'com.touktouktaxi.driver',
              componentName: 'com.touktouktaxi.driver.MainActivity',
              arguments: {"POS_EMULATOR_EXTRA": extras},
            );
            await intent.launch();
          }

          // Get.to(()=> HomeScreen());
          // if (_currentShape == BoxShape.rectangle) {
          //   await FlutterOverlayWindow.resizeOverlay(50, 100);
          //   setState(() {
          //     _currentShape = BoxShape.circle;
          //   });
          // } else {
          //   await FlutterOverlayWindow.resizeOverlay(
          //     50, 50
          //     // WindowSize.matchParent,
          //     // WindowSize.matchParent,
          //   );
          //   setState(() {
          //     _currentShape = BoxShape.rectangle;
          //   });
          // }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !_homeController.isOverlay.value ? SizedBox() : Container(height: 15,width: 15,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: Colors.red),child: Align(alignment: Alignment.center,
              child: Text('1',style: TextStyle(color: Colors.white),),),),
            Container(height: 50,width: 50,alignment: Alignment.center,margin: EdgeInsets.all(0),
              decoration: BoxDecoration(shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(AppImage.logoT,),),),
            ),
          ],
        ),
      ),
    );
  }
}
