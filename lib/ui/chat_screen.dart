import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/model/chat_msg_model.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:mozlit_driver/util/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer_srceen/help_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  final HomeController _homeController = Get.find();
  List<ChatMsgModel> _chatMsgList = [];
  final DateFormat _dateFormat = DateFormat("hh:mm a");
  final TextEditingController _msgController = TextEditingController();
  StreamSubscription<DatabaseEvent>? _chatListener;
  bool _isLoading = true;
  var data = Get.arguments;

  @override
  void initState() {
    super.initState();
    _databaseReference = _firebaseDatabase.ref(
        (_homeController.homeActiveTripModel.value.requests[0].requestId ?? "")
            .toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _chatListener = _databaseReference.onValue.listen((event) {
        _chatMsgList.clear();
        List<ChatMsgModel> chatMsgList = [];

        for (final child in event.snapshot.children) {
          DatabaseReference starCountRef = FirebaseDatabase.instance.ref(
              '${_homeController.homeActiveTripModel.value.requests[0].requestId.toString()}/${child.key}');
          starCountRef.child("sender").onValue.listen((DatabaseEvent event) {
            final data = event.snapshot.value;
            print("datata===>${data}");
            if (data == "user") {
              print("enter user");
              _databaseReference.child(child.key.toString()).update({
                "read": 10,
              });
            }
            // updateStarCount(data);
          });
          log("message  ==>   ${child.key}   ${jsonEncode(child.value)}");
          chatMsgList.add(chatMsgModelFromJson(jsonEncode(child.value)));
        }
        _chatMsgList.addAll(chatMsgList.reversed.toList());
        _isLoading = false;
        setState(() {});
      });
    });
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        print('Phone Number ${data[2]}');
        makePhoneCall(phoneNumber: data[2]);
        break;
      case 1:
        Get.to(() => HelpScreen());
        break;
    }
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Alert', "Could not launch $phoneNumber",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
      // showError(msg: "Could not launch $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("_chatMsgList===>${_chatMsgList.length}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        actions: <Widget>[
          // Icon(Icons.more_horiz),
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            icon: Icon(
              Icons.more_horiz,
              color: AppColors.primaryColor,
            ),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Call')),
              PopupMenuItem<int>(value: 1, child: Text('Help')),
            ],
          ),
        ],
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Container(
                  width: 60.w,
                  height: 60.w,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
                    // boxShadow: [AppBoxShadow.defaultShadow()]
                  ),
                  child: CustomFadeInImage(
                    url: data[0] ??
                        'https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${data[1] ?? ""}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            "Active Now",
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 10),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xff73D863),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Icon(
                //   Icons.more_horiz,
                //   color: AppColors.primaryColor,
                // ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // boxShadow: [
                //   AppBoxShadow.defaultShadow(),
                // ],
                borderRadius: BorderRadius.circular(30.r),
                // color: Colors.white,
              ),
              child: _isLoading
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10.h),
                          Text(
                            "loading".tr,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ))
                  : ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      itemBuilder: (context, index) {
                        ChatMsgModel _chatMsgModel = _chatMsgList[index];
                        DateTime _dateTime = DateTime.now();

                        try {
                          _dateTime = DateTime.fromMillisecondsSinceEpoch(
                            _chatMsgModel.timestamp ?? 0,
                          );
                        } catch (e) {}
                        if (_chatMsgModel.sender == "user") {
                          return Row(
                            children: [
                              Container(
                                width: 250.w,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                // decoration: BoxDecoration(color: Colors.red),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 5.h),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            AppBoxShadow.defaultShadow(),
                                          ],
                                        ),
                                        child: Text(
                                            "${_chatMsgModel.text ?? ""}")),
                                    SizedBox(height: 3.h),
                                    Text(
                                      _dateFormat.format(_dateTime),
                                      style: TextStyle(fontSize: 10.sp),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 250.w,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                // decoration: BoxDecoration(color: Colors.red),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 5.h),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          AppBoxShadow.defaultShadow(),
                                        ],
                                      ),
                                      child: Text(
                                        "${_chatMsgModel.text ?? ""}",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      _dateFormat.format(_dateTime),
                                      style: TextStyle(fontSize: 10.sp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: _chatMsgList.length,
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                AppBoxShadow.defaultShadow(),
              ],
              borderRadius: BorderRadius.circular(
                15.r,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "type_something_here".tr,
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      _sendMsg();
                    },
                    child: Card(
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                  AppImage.send_fill,
                                ))
                            // Icon(
                            //   Icons.send_rounded,
                            //   color: Colors.white,
                            // ),
                            )))
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  void _sendMsg() {
    if (_msgController.text.isEmpty) {
      return;
    }
    RequestElement datum = RequestElement();
    if (_homeController.homeActiveTripModel.value.requests.isNotEmpty) {
      datum = _homeController.homeActiveTripModel.value.requests[0];
    }
    FocusManager.instance.primaryFocus?.unfocus();
    ChatMsgModel _chatMsgModel = ChatMsgModel();
    _chatMsgModel.sender = "provider";
    _chatMsgModel.timestamp = DateTime.now().millisecondsSinceEpoch;
    _chatMsgModel.type = "text";
    _chatMsgModel.text = _msgController.text;
    _chatMsgModel.read = 1;
    _chatMsgModel.driverId = datum.providerId;
    _chatMsgModel.userId = datum.request?.userId ?? "0";

    // _homeController.sendChat(id: datum.providerId.toString(), msg: _msgController.text);
    print(
        "rrrrrr===>${_homeController.homeActiveTripModel.value.user_device_token}");
    _databaseReference.push().set(_chatMsgModel.toJson());
    NotificationService.sendNotification(
        _msgController.text,
        "User",
        _homeController.homeActiveTripModel.value.user_device_token.toString(),
        "");

    _msgController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _chatListener?.cancel();
  }
}
