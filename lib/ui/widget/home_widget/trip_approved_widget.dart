import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/enum/provider_ui_selection_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/ui/chat_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/dialog/add_toll_charge_dialog.dart';
import 'package:mozlit_driver/ui/widget/dialog/otp_dialog.dart';
import 'package:mozlit_driver/ui/widget/dialog/reason_for_cancelling_dialog.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

// bool isBreakDown = false;

class TripApprovedWidget extends StatefulWidget {
  const TripApprovedWidget({Key? key}) : super(key: key);

  @override
  State<TripApprovedWidget> createState() => _TripApprovedWidgetState();
}

class _TripApprovedWidgetState extends State<TripApprovedWidget> {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();
  MultiDestination currentDestination = MultiDestination();
  GlobalKey _repaintBoundaryKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  String chetUnRead = '0';
  String _otp = "";
  @override
  void initState() {
    // TODO: implement initState
    print(
        "kkkkkk===>${_homeController.homeActiveTripModel.value.requests[0].requestId}");
    _databaseReference = _firebaseDatabase.ref(
        (_homeController.homeActiveTripModel.value.requests[0].requestId ?? "")
            .toString());
    _databaseReference.onValue.listen((event) {
      _databaseReference.orderByChild("read").equalTo(2).get().then((value) {
        print("chil00d.key===>${value.children.length}");
        chetUnRead = value.children.length.isEqual(0)
            ? "0"
            : value.children.length.toString();
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return Container();
        }

        String btnStatusTitle = "arrived".tr;

        if (cont.providerUiSelectionType.value ==
            ProviderUiSelectionType.startedRequest) {
          btnStatusTitle = "arrived".tr;
        }
        if (cont.providerUiSelectionType.value ==
            ProviderUiSelectionType.arrivedRequest) {
          btnStatusTitle = "start_ride".tr;
        }
        RequestElement requestElement = RequestElement();
        if (cont.homeActiveTripModel.value.requests.isNotEmpty) {
          requestElement = cont.homeActiveTripModel.value.requests[0];
        }

        bool isShowBtnTapWhenDropped = false;
        String? multiPleLocationText;

        if (cont.providerUiSelectionType.value ==
            ProviderUiSelectionType.pickedUpRequest) {
          if (cont.homeActiveTripModel.value.multiDestination.isNotEmpty) {
            for (int i = 0;
                i < cont.homeActiveTripModel.value.multiDestination.length;
                i++) {
              currentDestination =
                  cont.homeActiveTripModel.value.multiDestination[i];

              if (currentDestination.finalDestination == 0 &&
                  currentDestination.isPickedup == 0) {
                multiPleLocationText = "${"arrived_location".tr} ${i + 1}".tr;
                isShowBtnTapWhenDropped = true;
                break;
              } else if (currentDestination.finalDestination == 1) {
                isShowBtnTapWhenDropped = true;
                break;
              }
            }
          } else {
            isShowBtnTapWhenDropped = true;
          }
        }

        return Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cont.providerUiSelectionType.value ==
                    ProviderUiSelectionType.startedRequest ||
                cont.providerUiSelectionType.value ==
                    ProviderUiSelectionType.arrivedRequest)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     determinePosition();
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 10),
                  //     child: Container(
                  //       height: 50.w,
                  //       width: 50.w,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(10.r),
                  //           boxShadow: [
                  //             AppBoxShadow.defaultShadow(),
                  //           ]),
                  //       child: Center(
                  //         child: Image.asset(
                  //           AppImage.icGPS,
                  //           width: 25.w,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(ChatScreen(), arguments: [
                            requestElement.request?.user?.picture != null
                                ? "${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture}"
                                : "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png",
                            //"${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture ?? "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png"}",
                            "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
                            "${requestElement.request?.user?.countryCode ?? ""}${requestElement.request?.user?.mobile ?? ""}"
                          ]);
                        },
                        child: Stack(
                          children: [
                            Container(height: 50,width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle
                              ),
                              padding: EdgeInsets.all(5),
                              child: Image.asset(AppImage.message,
                                width: 50, height: 50,),
                            ),
                            chetUnRead == "0"
                                ? SizedBox()
                                : Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 10),
                              height: 15,
                              width: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle),
                              child: Text(chetUnRead,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.w),
                      InkWell(
                        onTap: () {
                          _homeController.homeActiveTripModel.value.requests[0]
                              .request?.else_mobile ==
                              null
                              ? _userController.makePhoneCall(
                              phoneNumber:
                              "${requestElement.request?.user?.countryCode ?? ""}${requestElement.request?.user?.mobile ?? ""}")
                              : _userController.makePhoneCall(
                              phoneNumber:
                              "${_homeController.homeActiveTripModel.value.requests[0].request?.else_mobile ?? ""}");
                        },
                        child: Image.asset(AppImage.phone, width: 50, height: 50),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ],
              ),
            SizedBox(
              height: 15,
            ),
            cont.providerUiSelectionType.value ==
                    ProviderUiSelectionType.pickedUpRequest
                ? (cont.homeActiveTripModel.value.is_instant_ride_check != 1)
                    ?  cont.homeActiveTripModel.value.requests.first.request!.bkd_for_reqid == null ?
            InkWell(
                        onTap: () {
                          _showBreakDownDialog();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Image.asset(AppImage.breakDown),
                        ),
                      )
                    // ? SizedBox()
                    : SizedBox()
                : SizedBox():SizedBox(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cont.providerUiSelectionType.value ==
                          ProviderUiSelectionType.arrivedRequest ||
                      cont.providerUiSelectionType.value ==
                          ProviderUiSelectionType.pickedUpRequest)
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 7.h, horizontal: 10.w),
                          margin: EdgeInsets.only(
                              top: 10.h, left: 20.w,right: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            // boxShadow: [
                            //   AppBoxShadow.defaultShadow(),
                            // ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImage.pointClock,
                                width: 30.w,
                              ),
                              SizedBox(width: 10.w),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 50,
                                lineThickness: 2.w,
                                dashLength: 7.w,
                                dashColor: Colors.black,
                                dashGradient: [AppColors.primaryColor2,AppColors.primaryColor],
                                dashRadius: 0.0,
                                dashGapLength: 0.w,
                              ),
                              SizedBox(width: 10.w),
                              Image.asset(
                                AppImage.carArrived,
                                width:
                                40.w,
                                height: 30.h,
                              ),
                              SizedBox(width: 10.w),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 50,
                                lineThickness: 2.w,
                                dashLength: 7.w,
                                dashGradient: [AppColors.primaryColor2,AppColors.primaryColor],
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 0.w,
                              ),
                              SizedBox(width: 8.w),
                              Image.asset(
                                AppImage.mapPin,
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                      margin: EdgeInsets.only(
                          top: 10.h, left: 20.w,right: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        // boxShadow: [
                        //   AppBoxShadow.defaultShadow(),
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.pointClock,
                            width: 30.w,
                          ),
                          SizedBox(width: 10.w),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: 50,
                            lineThickness: 2.w,
                            dashLength: 7.w,
                            dashColor: Colors.black,
                            dashGradient: [AppColors.primaryColor2,AppColors.primaryColor],
                            dashRadius: 0.0,
                            dashGapLength: 0.w,
                          ),
                          SizedBox(width: 10.w),
                          Stack(
                            children: [
                              Image.asset(
                                AppImage.carArrived,
                                width:
                                35.w,
                                height: 35.h,
                              ),
                              Container(
                                color: AppColors.white.withOpacity(0.8),
                                width: 50,height: 35
                              )
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 50,
                                lineThickness: 2.w,
                                dashLength: 7.w,
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 0.w,
                              ),
                              Container(
                                color: AppColors.white.withOpacity(0.8),
                                width: 50,height: 30,
                              )
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Stack(
                            children: [
                              Image.asset(
                                AppImage.mapPin,
                                width: 30,
                                height: 30,
                              ), Container(
                                color: AppColors.white.withOpacity(0.8),
                                width:30,height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    padding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(85),
                          child: CustomFadeInImage(
                            url: requestElement.request?.user?.picture != null
                                ? "${ApiUrl.baseImageUrl}/${requestElement.request?.user?.picture}"
                                : "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",
                            fit: BoxFit.cover,
                            height: 55.w,
                            width: 55.w,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.w500,
                                //     fontSize: 14.sp,
                                //   ),
                                // ),

                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      requestElement.request?.moduleType == "DELIVERY"?
                                      "${requestElement.request?.user?.firstName ?? ""}\n${requestElement.request?.user?.lastName ?? ""}" :
                                      "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),

                                    SizedBox(width: 3,),

                                    cont.homeActiveTripModel.value.userVerifyCheck == null? SizedBox() :
                                    cont.homeActiveTripModel.value.userVerifyCheck == 'verified'?
                                    Image.asset(AppImage.verifiedIcon,height: 18,width: 18,) : SizedBox()
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     RatingBar.builder(
                                //       initialRating: _strToDouble(
                                //           s: requestElement
                                //                   .request?.user?.rating ??
                                //               "0"),
                                //       minRating: 1,
                                //       direction: Axis.horizontal,
                                //       allowHalfRating: true,
                                //       ignoreGestures: true,
                                //       itemCount: 5,
                                //       itemPadding: EdgeInsets.symmetric(
                                //           horizontal: 0.5.w),
                                //       itemBuilder: (context, _) => Icon(
                                //         Icons.star,
                                //         color: Colors.amber,
                                //       ),
                                //       itemSize: 12.w,
                                //       onRatingUpdate: (rating) {},
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [


                                    Text(
                                      '${requestElement.request?.user?.rating ?? "0"}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primaryColor),
                                    ),SizedBox(
                                      width: 3,
                                    ),Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Colors.orange[300],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        if(requestElement.request?.moduleType == "DELIVERY"
                            && cont.providerUiSelectionType.value !=
                                ProviderUiSelectionType.pickedUpRequest) Container(
                          height: 60.h,
                          width: 1.4.w,
                          color: Colors.black,
                        ),
                        if(requestElement.request?.moduleType == "DELIVERY"
                            && cont.providerUiSelectionType.value !=
                                ProviderUiSelectionType.pickedUpRequest)  SizedBox(
                          width: 8.w,
                        ),
                        if(requestElement.request?.moduleType == "DELIVERY"
                            && cont.providerUiSelectionType.value !=
                                ProviderUiSelectionType.pickedUpRequest
                        )
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "package_details".tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Container(
                                  height: 45.h,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "${requestElement.request?.deliveryPackageDetails}",
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  if (!isShowBtnTapWhenDropped)
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        InkWell(
                          onTap: cont.homeActiveTripModel.value.requests.first
                                      .request!.bkd_for_reqid !=
                                  null
                              ? () {
                                  Get.snackbar("Alert",
                                      "You can not cancel the ride because you are on a breakdown ride.",
                                      backgroundColor:
                                          Colors.red.withOpacity(0.8),
                                      colorText: Colors.white);
                                }
                              : () {
                                  _showCancelDialog(
                                      requestId: "${requestElement.requestId}");
                                },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(55)),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: AppColors.lightGray.withOpacity(0.5),
                              //     blurRadius: 16.r,
                              //     spreadRadius: 2.w,
                              //     offset: Offset(0, 12.h),
                              //   )
                              // ],
                            ),
                            child: Text(
                              'cancel'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (cont.providerUiSelectionType.value ==
                                ProviderUiSelectionType.startedRequest) {
                              _updateStatus(checkStatus: CheckStatus.ARRIVED);
                            }
                            if (cont.providerUiSelectionType.value ==
                                ProviderUiSelectionType.arrivedRequest) {
                              if (cont.homeActiveTripModel.value.rideOtp == 1) {
                                Get.defaultDialog(
                                    radius: 55,

                                    title: "",
                                    content: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                                      clipBehavior: Clip.antiAlias,
                                      width: MediaQuery.of(context).size.width*0.95,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20.r)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 10.h),
                                          Image.asset(
                                            AppImage.otp,
                                            width: 70.w,
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "otp_verification".tr,
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          PinCodeTextField(
                                            appContext: context,
                                            length: 4,
                                            obscureText: false,textStyle: TextStyle(color: AppColors.primaryColor2,fontSize: 35),
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            animationType: AnimationType.fade,enableActiveFill: true,
                                            keyboardType: TextInputType.number,
                                            // boxShadows: [BoxShadow(
                                            //   color: Colors.grey.withOpacity(0.5),
                                            //   spreadRadius: 5,
                                            //   blurRadius: 7,
                                            //   offset: Offset(0, 3), // changes position of shadow
                                            // ),],

                                            pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                fieldHeight: 70,
                                                borderWidth: 2,
                                                fieldWidth: 49,

                                                activeFillColor:AppColors.white,
                                                activeColor: AppColors.primaryColor,
                                                disabledColor: AppColors.primaryColor,
                                                errorBorderColor: Colors.red,
                                                inactiveColor: AppColors.primaryColor,
                                                selectedColor: AppColors.primaryColor,
                                                selectedFillColor: AppColors.white,
                                                inactiveFillColor: AppColors.white
                                            ),
                                            animationDuration: Duration(milliseconds: 300),
                                            backgroundColor: Colors.transparent,

                                            onCompleted: (v) {
                                              print("Completed===>${v}");
                                              _otp = v;
                                              print("value00===>${_otp}");
                                            },
                                            onChanged: (value) {
                                              print("value===>${value}");
                                              _otp = value;
                                            },
                                            beforeTextPaste: (text) {
                                              print("Allowing to paste $text");
                                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                              return true;
                                            },
                                          ),
                                          // OtpTextField(
                                          //   numberOfFields: 4,
                                          //   borderColor: AppColors.primaryColor,
                                          //   showFieldAsBox: true,
                                          //   fillColor: Colors.white,
                                          //   enabledBorderColor: AppColors.primaryColor,
                                          //   focusedBorderColor: AppColors.primaryColor,
                                          //   disabledBorderColor: AppColors.gray,
                                          //   autoFocus: true,
                                          //   onCodeChanged: (String code) {
                                          //     //handle validation or checks here
                                          //     _otp = code;
                                          //   },
                                          //   //runs when every textfield is filled
                                          //   onSubmit: (String verificationCode) {
                                          //     _otp = verificationCode;
                                          //     print("object  ==>  $_otp");
                                          //   }, // end onSubmit
                                          // ),
                                          SizedBox(height: 10.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                                            child: CustomButton(
                                              text: "submit".tr,
                                              onTap: () {
                                                if (_otp != requestElement.request?.otp){
                                                  cont.showError(msg: "wrong_otp".tr);
                                                  return;
                                                }else{
                                                  Get.back(result: true);
                                                  cont.showSnack(msg: "otp_verified".tr);
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                    )
                                ).then((value) {
                                  if (value is bool) {
                                    if (value == true) {
                                      _updateStatus(
                                          checkStatus: CheckStatus.PICKEDUP);
                                    }
                                  }
                                });
                              } else {
                                _updateStatus(
                                    checkStatus: CheckStatus.PICKEDUP);
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(55)),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: AppColors.lightGray.withOpacity(0.5),
                              //     blurRadius: 16.r,
                              //     spreadRadius: 2.w,
                              //     offset: Offset(0, 12.h),
                              //   )
                              // ],
                            ),
                            child: Text(
                              btnStatusTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: CustomButton(
                        //     text: 'cancel'.tr,
                        //     textColor: Colors.red,
                        //     bgColor: Colors.white,
                        //     fontWeight: FontWeight.w400,
                        //     fontSize: 14.sp,
                        //     onTap: () {
                        //       _showCancelDialog(
                        //           requestId: "${requestElement.requestId}");
                        //     },
                        //   ),
                        // ),
                        // SizedBox(width: 10.w),
                        // Expanded(
                        //   child: CustomButton(
                        //     text: btnStatusTitle,
                        //     textColor: Colors.white,
                        //     bgColor: AppColors.appColor,
                        //     fontWeight: FontWeight.w400,
                        //     fontSize: 14.sp,
                        //     onTap: () {
                        //       if (cont.providerUiSelectionType.value ==
                        //           ProviderUiSelectionType.startedRequest) {
                        //         _updateStatus(checkStatus: CheckStatus.ARRIVED);
                        //       }
                        //       if (cont.providerUiSelectionType.value ==
                        //           ProviderUiSelectionType.arrivedRequest) {
                        //         if (cont.homeActiveTripModel.value.rideOtp ==
                        //             1) {
                        //           Get.dialog(OtpDialog()).then((value) {
                        //             if (value is bool) {
                        //               if (value == true) {
                        //                 _updateStatus(
                        //                     checkStatus: CheckStatus.PICKEDUP);
                        //               }
                        //             }
                        //           });
                        //         } else {
                        //           _updateStatus(
                        //               checkStatus: CheckStatus.PICKEDUP);
                        //         }
                        //       }
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  if (isShowBtnTapWhenDropped)
                    InkWell(
                      onTap: () {
                        if (multiPleLocationText != null) {
                          Map<String, String> params = {};
                          params["location_id"] = "${currentDestination.id}";
                          params["request_id"] =
                              "${currentDestination.requestId}";
                          params["status"] = CheckStatus.PICKEDUP;
                          cont.updateMultipleDestination(params: params);
                          return;
                        }
                        Get.dialog(AddTollChargeDialog());
                        // _showDeclineDialog(context);
                        // cont.waitingTimeSec.value = 0;
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        margin: EdgeInsets.symmetric(horizontal: 45),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(55),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: AppColors.lightGray.withOpacity(0.5),
                          //     blurRadius: 16.r,
                          //     spreadRadius: 2.w,
                          //     offset: Offset(0, 12.h),
                          //   )
                          // ],
                        ),
                        child: Text(
                          multiPleLocationText ?? "end_ride".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  // TextButton(onPressed: () {
                  //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.id}");
                  //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.requestId}");
                  // }, child: Text("ddddddddd")),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10.h),
                  //   child: CustomButton(
                  //     text: multiPleLocationText ?? "End Ride",
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 14.sp,
                  //     onTap: () {
                  //       if (multiPleLocationText != null) {
                  //         Map<String, String> params = {};
                  //         params["location_id"] = "${currentDestination.id}";
                  //         params["request_id"] =
                  //             "${currentDestination.requestId}";
                  //         params["status"] = CheckStatus.PICKEDUP;
                  //         cont.updateMultipleDestination(params: params);
                  //         return;
                  //       }
                  //       Get.dialog(AddTollChargeDialog());
                  //       // _showDeclineDialog(context);
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10.h),
          ],
        );
      }),
    );
  }

  Future<void> _showBreakDownDialog() async {
    Get.defaultDialog(
        titlePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        title: "Vehicle BreakDown? Tell us more",
        titleStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        content: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10),
                // margin:
                //     EdgeInsets.symmetric(horizontal: 25.w, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5.r)),
                child: TextFormField(
                  maxLines: 5,
                  // controller: cont.breakDownController,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Description",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
        cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 120,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Colors.grey.withOpacity(0.2)),
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text("Cancel"),
          ),
        ),
        confirm: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              print("currentDestination.id===>${_formKey.currentState}");
              print("currentDestination.id===>${currentDestination.requestId}");
              Map<String, String> params = {};
              params["location_id"] = "${currentDestination.id}";
              params["request_id"] = "${currentDestination.requestId}";
              params["status"] = CheckStatus.PICKEDUP;
              print("object");
              _homeController.updateMultipleDestination(params: params);
              // setState(() {
              //   isBreakDown = true;
              // });
              List placemarks = await placemarkFromCoordinates(
                  _homeController.userCurrentLocation!.latitude,
                  _homeController.userCurrentLocation!.longitude);
              Placemark place = placemarks[0];
              _homeController.breakDownDriverId.value =
                  currentDestination.requestId;
              _homeController.breakDownDestinationLat.value =
                  currentDestination.latitude!;
              _homeController.breakDownDestinationLong.value =
                  currentDestination.longitude!;
              _homeController.breakDownDestinationAddress.value =
                  currentDestination.dAddress!;

              _homeController.breakDownSourceLat.value =
                  _homeController.userCurrentLocation!.latitude;
              _homeController.breakDownSourceLong.value =
                  _homeController.userCurrentLocation!.longitude;
              print("place.name===>${place.name}");
              print("place.name===>${place.subLocality}");
              _homeController.breakDownSourceAddress.value =
                  "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

              params["status"] = "DROPPED";
              params["_method"] = "PATCH";
              params["breakdown"] = "1";
              params["breakdown_comment"] =
                  _userController.breakDownController.text;
              _homeController.updateTrip(data: params);
              // params["_method"] = CheckStatus.PATCH.toString();
              // params["status"] = CheckStatus.COMPLETED.toString();
              // await _homeController.updateBreakDownTrip(
              //     data: params);
              // params["_method"] = CheckStatus.PATCH;
              // params["status"] = CheckStatus.COMPLETED;
              // _homeController.updateBreakDownTrip(data: params);
              Get.back();
              Get.back();
            }
            _userController.breakDownController.clear();
          },
          child: Container(
            width: 120,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppColors.primaryColor),
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text("Submit", style: TextStyle(color: AppColors.white)),
          ),
        ));
    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: true, // user must tap button!
    //   builder: (BuildContext context) {
    //     return Center(
    //       child: SingleChildScrollView(
    //         child: AlertDialog(
    //           backgroundColor: Colors.grey,
    //           iconColor: Colors.white,
    //           // icon: Align(
    //           //     alignment: Alignment.topRight,
    //           //     child: IconButton(
    //           //         onPressed: () async {
    //           //           setState(() {
    //           //             isBreakDown = false;
    //           //           });
    //           //           Get.back();
    //           //           List placemarks = await placemarkFromCoordinates(
    //           //               _homeController.userCurrentLocation!.latitude,
    //           //               _homeController.userCurrentLocation!.longitude);
    //           //           print("placemarks===>${placemarks[2]}");
    //           //           Placemark place = placemarks[0];
    //           //           print(
    //           //               "aaaaa===> '${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}'");
    //           //           print(
    //           //               "currentDestination.longitude===>${currentDestination.dAddress}");
    //           //           print(
    //           //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.latitude}");
    //           //           print(
    //           //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.longitude}");
    //           //         },
    //           //         icon: Icon(Icons.close))),
    //           content: Form(
    //
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 Container(
    //                   height: 200,
    //                   // margin:
    //                   //     EdgeInsets.symmetric(horizontal: 25.w, vertical: 10),
    //                   clipBehavior: Clip.antiAlias,
    //                   decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.circular(20.r)),
    //                   child: TextFormField(
    //                     maxLines: 20,
    //                     // controller: cont.breakDownController,
    //                     validator: (text) {
    //                       if (text == null || text.isEmpty) {
    //                         return 'Description is required';
    //                       }
    //                       return null;
    //                     },
    //                     style: TextStyle(
    //                         fontSize: 18,
    //                         color: AppColors.primaryColor,
    //                         fontWeight: FontWeight.w500),
    //                     decoration: InputDecoration(
    //                       contentPadding: EdgeInsets.symmetric(
    //                           horizontal: 20, vertical: 25),
    //                       border: InputBorder.none,
    //                       focusedBorder: InputBorder.none,
    //                       enabledBorder: InputBorder.none,
    //                       hintText: "Description",
    //                       hintStyle: TextStyle(
    //                           fontSize: 18,
    //                           color: AppColors.primaryColor,
    //                           fontWeight: FontWeight.w500),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //                 // TextButton(onPressed: () {
    //                 //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.finalDestination}");
    //                 //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.requestId}");
    //                 //
    //                 // }, child: Text("dddddd")),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
    //                   child: CustomButton(
    //                     text: "Submit",
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 19,
    //                     onTap: () async {
    //                       // if (_formKey.currentState!.validate()) {
    //                       //
    //                       //   print(
    //                       //       "currentDestination.id===>${_formKey.currentState}");
    //                       //   print(
    //                       //       "currentDestination.id===>${currentDestination.requestId}");
    //                       //   Map<String, String> params = {};
    //                       //   params["location_id"] = "${currentDestination.id}";
    //                       //   params["request_id"] =
    //                       //   "${currentDestination.requestId}";
    //                       //   params["status"] = CheckStatus.PICKEDUP;
    //                       //   print("object");
    //                       //   _homeController.updateMultipleDestination(
    //                       //       params: params);
    //                       //   // setState(() {
    //                       //   //   isBreakDown = true;
    //                       //   // });
    //                       //   List placemarks = await placemarkFromCoordinates(
    //                       //       _homeController.userCurrentLocation!.latitude,
    //                       //       _homeController.userCurrentLocation!.longitude);
    //                       //   Placemark place = placemarks[0];
    //                       //   _homeController.breakDownDriverId.value =
    //                       //       currentDestination.requestId;
    //                       //   _homeController.breakDownDestinationLat.value =
    //                       //   currentDestination.latitude!;
    //                       //   _homeController.breakDownDestinationLong.value =
    //                       //   currentDestination.longitude!;
    //                       //   _homeController.breakDownDestinationAddress.value =
    //                       //   currentDestination.dAddress!;
    //                       //
    //                       //   _homeController.breakDownSourceLat.value =
    //                       //       _homeController.userCurrentLocation!.latitude;
    //                       //   _homeController.breakDownSourceLong.value =
    //                       //       _homeController.userCurrentLocation!.longitude;
    //                       //   print("place.name===>${place.name}");
    //                       //   print("place.name===>${place.subLocality}");
    //                       //   _homeController.breakDownSourceAddress.value =
    //                       //   "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    //                       //
    //                       //   params["status"] = "DROPPED";
    //                       //   params["_method"] = "PATCH";
    //                       //   params["breakdown"] = "1";
    //                       //   params["breakdown_comment"] =
    //                       //       _userController.breakDownController.text;
    //                       //   _homeController.updateTrip(data: params);
    //                       //   // params["_method"] = CheckStatus.PATCH.toString();
    //                       //   // params["status"] = CheckStatus.COMPLETED.toString();
    //                       //   // await _homeController.updateBreakDownTrip(
    //                       //   //     data: params);
    //                       //   // params["_method"] = CheckStatus.PATCH;
    //                       //   // params["status"] = CheckStatus.COMPLETED;
    //                       //   // _homeController.updateBreakDownTrip(data: params);
    //                       //   Get.back();
    //                       //   Get.back();
    //                       // }
    //                       // _userController.breakDownController.clear();
    //                     },
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //           // actions: <Widget>[
    //           //   TextButton(
    //           //     child: Text('Close'),
    //           //     onPressed: () {
    //           //       Get.back();
    //           //     },
    //           //   ),
    //           // ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  //
  // Future<void> _showBreakDownDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: SingleChildScrollView(
  //           child: AlertDialog(
  //             backgroundColor: Colors.grey,
  //             iconColor: Colors.white,
  //             // icon: Align(
  //             //     alignment: Alignment.topRight,
  //             //     child: IconButton(
  //             //         onPressed: () async {
  //             //           setState(() {
  //             //             isBreakDown = false;
  //             //           });
  //             //           Get.back();
  //             //           List placemarks = await placemarkFromCoordinates(
  //             //               _homeController.userCurrentLocation!.latitude,
  //             //               _homeController.userCurrentLocation!.longitude);
  //             //           print("placemarks===>${placemarks[2]}");
  //             //           Placemark place = placemarks[0];
  //             //           print(
  //             //               "aaaaa===> '${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}'");
  //             //           print(
  //             //               "currentDestination.longitude===>${currentDestination.dAddress}");
  //             //           print(
  //             //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.latitude}");
  //             //           print(
  //             //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.longitude}");
  //             //         },
  //             //         icon: Icon(Icons.close))),
  //             content: Form(
  //               key: _formKey,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Container(
  //                     height: 200,
  //                     // margin:
  //                     //     EdgeInsets.symmetric(horizontal: 25.w, vertical: 10),
  //                     clipBehavior: Clip.antiAlias,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20.r)),
  //                     child: TextFormField(
  //                       maxLines: 20,
  //                       controller: _userController.breakDownController,
  //                       validator: (text) {
  //                         if (text == null || text.isEmpty) {
  //                           return 'Description is required';
  //                         }
  //                         return null;
  //                       },
  //                       style: TextStyle(
  //                           fontSize: 18,
  //                           color: AppColors.primaryColor,
  //                           fontWeight: FontWeight.w500),
  //                       decoration: InputDecoration(
  //                         contentPadding: EdgeInsets.symmetric(
  //                             horizontal: 20, vertical: 25),
  //                         border: InputBorder.none,
  //                         focusedBorder: InputBorder.none,
  //                         enabledBorder: InputBorder.none,
  //                         hintText: "Description",
  //                         hintStyle: TextStyle(
  //                             fontSize: 18,
  //                             color: AppColors.primaryColor,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   // TextButton(onPressed: () {
  //                   //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.finalDestination}");
  //                   //   print("currentDestination.id===>${_homeController.homeActiveTripModel.value.multiDestination.first.requestId}");
  //                   //
  //                   // }, child: Text("dddddd")),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
  //                     child: CustomButton(
  //                       text: "Submit",
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 19,
  //                       onTap: () async {
  //                         if (_formKey.currentState!.validate()) {
  //
  //                           print(
  //                               "currentDestination.id===>${_formKey.currentState}");
  //                           print(
  //                               "currentDestination.id===>${currentDestination.requestId}");
  //                           Map<String, String> params = {};
  //                           params["location_id"] = "${currentDestination.id}";
  //                           params["request_id"] =
  //                           "${currentDestination.requestId}";
  //                           params["status"] = CheckStatus.PICKEDUP;
  //                           print("object");
  //                           _homeController.updateMultipleDestination(
  //                               params: params);
  //                           // setState(() {
  //                           //   isBreakDown = true;
  //                           // });
  //                           List placemarks = await placemarkFromCoordinates(
  //                               _homeController.userCurrentLocation!.latitude,
  //                               _homeController.userCurrentLocation!.longitude);
  //                           Placemark place = placemarks[0];
  //                           _homeController.breakDownDriverId.value =
  //                               currentDestination.requestId;
  //                           _homeController.breakDownDestinationLat.value =
  //                           currentDestination.latitude!;
  //                           _homeController.breakDownDestinationLong.value =
  //                           currentDestination.longitude!;
  //                           _homeController.breakDownDestinationAddress.value =
  //                           currentDestination.dAddress!;
  //
  //                           _homeController.breakDownSourceLat.value =
  //                               _homeController.userCurrentLocation!.latitude;
  //                           _homeController.breakDownSourceLong.value =
  //                               _homeController.userCurrentLocation!.longitude;
  //                           print("place.name===>${place.name}");
  //                           print("place.name===>${place.subLocality}");
  //                           _homeController.breakDownSourceAddress.value =
  //                           "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
  //
  //                           params["status"] = "DROPPED";
  //                           params["_method"] = "PATCH";
  //                           params["breakdown"] = "1";
  //                           params["breakdown_comment"] =
  //                               _userController.breakDownController.text;
  //                           _homeController.updateTrip(data: params);
  //                           // params["_method"] = CheckStatus.PATCH.toString();
  //                           // params["status"] = CheckStatus.COMPLETED.toString();
  //                           // await _homeController.updateBreakDownTrip(
  //                           //     data: params);
  //                           // params["_method"] = CheckStatus.PATCH;
  //                           // params["status"] = CheckStatus.COMPLETED;
  //                           // _homeController.updateBreakDownTrip(data: params);
  //                           Get.back();
  //                           Get.back();
  //                         }
  //                         _userController.breakDownController.clear();
  //                       },
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             // actions: <Widget>[
  //             //   TextButton(
  //             //     child: Text('Close'),
  //             //     onPressed: () {
  //             //       Get.back();
  //             //     },
  //             //   ),
  //             // ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<Position?> determinePosition() async {
    LocationPermission permission;

    // Test if location services are enabled.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetSnackBar(
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
      Get.showSnackbar(GetSnackBar(
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
    if (position != null) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _homeController.userCurrentLocation = latLng;
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude),
        zoom: 14.4746,
      );
      _homeController.googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      if (_homeController.userImageMarker != null) {
        _homeController.showMarker(
            latLng: _homeController.userCurrentLocation!,
            oldLatLng: _homeController.userCurrentLocation!);
      } else {
        _capturePng();
      }
    }
    return position;
  }

  Future<Uint8List?> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      _homeController.userImageMarker = pngBytes;
      var bs64 = base64Encode(pngBytes!);
      print(pngBytes);
      print(bs64);
      if (_homeController.userCurrentLocation != null) {
        _homeController.showMarker(
            latLng: _homeController.userCurrentLocation!,
            oldLatLng: LatLng(0, 0));
      }
      return pngBytes;
    } catch (e) {
      print(e);
      _homeController.isCaptureImage.value = false;
    }
    return null;
  }

  double _strToDouble({required String s}) {
    double rating = 0;
    try {
      rating = double.parse(s);
    } catch (e) {
      rating = 0;
    }
    return rating;
  }

  void _updateStatus({required String checkStatus}) {
    Map<String, String> params = {};
    params["status"] = checkStatus;
    params["_method"] = "PATCH";
    _homeController.updateTrip(data: params);
  }

  String _waitingTimeIntToString(int value) {
    int hours = value ~/ 3600;
    int minutes = (value % 3600) ~/ 60;
    int seconds = value % 60;
    return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  Future<void> _showCancelDialog({required String requestId}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('are_you_sure_want_to_cancel_this_request'.tr),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('no'.tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('yes'.tr),
              onPressed: () {
                Get.back();
                Get.bottomSheet(ReasonForCancelling(
                  cancelId: requestId,
                ));
              },
            ),
          ],
        );
      },
    );
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:dotted_line/dotted_line.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mozlit_driver/api/api.dart';
// import 'package:mozlit_driver/controller/home_controller.dart';
// import 'package:mozlit_driver/controller/user_controller.dart';
// import 'package:mozlit_driver/enum/error_type.dart';
// import 'package:mozlit_driver/enum/provider_ui_selection_type.dart';
// import 'package:mozlit_driver/model/home_active_trip_model.dart';
// import 'package:mozlit_driver/ui/chat_screen.dart';
// import 'package:mozlit_driver/ui/widget/custom_button.dart';
// import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
// import 'package:mozlit_driver/ui/widget/dialog/add_toll_charge_dialog.dart';
// import 'package:mozlit_driver/ui/widget/dialog/otp_dialog.dart';
// import 'package:mozlit_driver/ui/widget/dialog/reason_for_cancelling_dialog.dart';
// import 'package:mozlit_driver/util/app_constant.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// bool isBreakDown = false;
//
// class TripApprovedWidget extends StatefulWidget {
//   const TripApprovedWidget({Key? key}) : super(key: key);
//
//   @override
//   State<TripApprovedWidget> createState() => _TripApprovedWidgetState();
// }
//
// class _TripApprovedWidgetState extends State<TripApprovedWidget> {
//   final HomeController _homeController = Get.find();
//   final UserController _userController = Get.find();
//   MultiDestination currentDestination = MultiDestination();
//   GlobalKey _repaintBoundaryKey = new GlobalKey();
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
//   late DatabaseReference _databaseReference;
//   String chetUnRead = '0';
//   @override
//   void initState() {
//     // TODO: implement initState
//     print(
//         "kkkkkk===>${_homeController.homeActiveTripModel.value.requests[0].requestId}");
//     _databaseReference = _firebaseDatabase.ref(
//         (_homeController.homeActiveTripModel.value.requests[0].requestId ?? "")
//             .toString());
//     _databaseReference.onValue.listen((event) {
//       _databaseReference.orderByChild("read").equalTo(2).get().then((value) {
//         print("chil00d.key===>${value.children.length}");
//         chetUnRead = value.children.length.isEqual(0)
//             ? "0"
//             : value.children.length.toString();
//         setState(() {});
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: GetX<HomeController>(builder: (cont) {
//         if (cont.error.value.errorType == ErrorType.internet) {
//           return Container();
//         }
//
//         String btnStatusTitle = "arrived".tr;
//
//         if (cont.providerUiSelectionType.value ==
//             ProviderUiSelectionType.startedRequest) {
//           btnStatusTitle = "arrived".tr;
//         }
//         if (cont.providerUiSelectionType.value ==
//             ProviderUiSelectionType.arrivedRequest) {
//           btnStatusTitle = "start_ride".tr;
//         }
//         RequestElement requestElement = RequestElement();
//         if (cont.homeActiveTripModel.value.requests.isNotEmpty) {
//           requestElement = cont.homeActiveTripModel.value.requests[0];
//         }
//
//         bool isShowBtnTapWhenDropped = false;
//         String? multiPleLocationText;
//
//         if (cont.providerUiSelectionType.value ==
//             ProviderUiSelectionType.pickedUpRequest) {
//           if (cont.homeActiveTripModel.value.multiDestination.isNotEmpty) {
//             for (int i = 0;
//                 i < cont.homeActiveTripModel.value.multiDestination.length;
//                 i++) {
//               currentDestination =
//                   cont.homeActiveTripModel.value.multiDestination[i];
//
//               if (currentDestination.finalDestination == 0 &&
//                   currentDestination.isPickedup == 0) {
//                 multiPleLocationText = "${"arrived_location".tr} ${i + 1}".tr;
//                 isShowBtnTapWhenDropped = true;
//                 break;
//               } else if (currentDestination.finalDestination == 1) {
//                 isShowBtnTapWhenDropped = true;
//                 break;
//               }
//             }
//           } else {
//             isShowBtnTapWhenDropped = true;
//           }
//         }
//
//         return Column(
//           // mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (cont.providerUiSelectionType.value ==
//                     ProviderUiSelectionType.startedRequest ||
//                 cont.providerUiSelectionType.value ==
//                     ProviderUiSelectionType.arrivedRequest)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     determinePosition();
//                   //   },
//                   //   child: Padding(
//                   //     padding: EdgeInsets.only(left: 10),
//                   //     child: Container(
//                   //       height: 50.w,
//                   //       width: 50.w,
//                   //       decoration: BoxDecoration(
//                   //           color: Colors.white,
//                   //           borderRadius: BorderRadius.circular(10.r),
//                   //           boxShadow: [
//                   //             AppBoxShadow.defaultShadow(),
//                   //           ]),
//                   //       child: Center(
//                   //         child: Image.asset(
//                   //           AppImage.icGPS,
//                   //           width: 25.w,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.to(ChatScreen(), arguments: [
//                             requestElement.request?.user?.picture != null
//                                 ? "${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture}"
//                                 : "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png",
//                             //"${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture ?? "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png"}",
//                             "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
//                             "${requestElement.request?.user?.countryCode ?? ""}${requestElement.request?.user?.mobile ?? ""}"
//                           ]);
//                         },
//                         child: Container(
//                           height: 50.w,
//                           width: 50.w,
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.all(10.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.r),
//                             boxShadow: [
//                               AppBoxShadow.defaultShadow(),
//                             ],
//                           ),
//                           child: Stack(
//                             children: [
//                               Image.asset(AppImage.message,
//                                   width: 30, height: 30, fit: BoxFit.contain),
//                               chetUnRead == "0"
//                                   ? SizedBox()
//                                   : Container(
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 10),
//                                       height: 15,
//                                       width: 15,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                           color: Colors.red,
//                                           shape: BoxShape.circle),
//                                       child: Text(chetUnRead,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 10)),
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15.w),
//                       InkWell(
//                         onTap: () {
//                           _homeController.homeActiveTripModel.value.requests[0]
//                                       .request?.else_mobile ==
//                                   null
//                               ? _userController.makePhoneCall(
//                                   phoneNumber:
//                                       "${requestElement.request?.user?.countryCode ?? ""}${requestElement.request?.user?.mobile ?? ""}")
//                               : _userController.makePhoneCall(
//                                   phoneNumber:
//                                       "${_homeController.homeActiveTripModel.value.requests[0].request?.else_mobile ?? ""}");
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 50.w,
//                           width: 50.w,
//                           padding: EdgeInsets.only(right: 10.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.r),
//                             boxShadow: [
//                               AppBoxShadow.defaultShadow(),
//                             ],
//                           ),
//                           child: Image.asset(AppImage.call,
//                               fit: BoxFit.contain, width: 30, height: 30),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                     ],
//                   ),
//                 ],
//               ),
//             SizedBox(
//               height: 15,
//             ),
//             cont.providerUiSelectionType.value ==
//                     ProviderUiSelectionType.pickedUpRequest
//                 ? SizedBox()
//             // InkWell(
//             //         onTap: () {
//             //           _showBreakDownDialog();
//             //         },
//             //         child: Container(
//             //           height: 45,
//             //           width: 45,
//             //           margin:
//             //               EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             //           decoration: BoxDecoration(
//             //               color: Colors.white,
//             //               borderRadius: BorderRadius.circular(8)),
//             //           alignment: Alignment.center,
//             //           padding: EdgeInsets.all(5),
//             //           child: Image.asset(AppImage.breakDown),
//             //         ),
//             //       )
//                 : SizedBox(),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40)),
//                   color: Colors.white,
//                   boxShadow: [
//                     AppBoxShadow.defaultShadow(),
//                   ]),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (cont.providerUiSelectionType.value ==
//                           ProviderUiSelectionType.arrivedRequest ||
//                       cont.providerUiSelectionType.value ==
//                           ProviderUiSelectionType.pickedUpRequest)
//                     Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 7.h, horizontal: 10.w),
//                           margin: EdgeInsets.symmetric(
//                               vertical: 10.h, horizontal: 20.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.r),
//                             // boxShadow: [
//                             //   AppBoxShadow.defaultShadow(),
//                             // ],
//                           ),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 AppImage.icArrivedSelect,
//                                 width: 30.w,
//                               ),
//                               if (cont.providerUiSelectionType.value ==
//                                   ProviderUiSelectionType.pickedUpRequest) ...[
//                                 Expanded(
//                                     child: Divider(
//                                   color: AppColors.drawer,
//                                   thickness: 1.5.h,
//                                 )),
//                                 Image.asset(
//                                   AppImage.icPickupSelect,
//                                   width: 30.w,
//                                 ),
//                               ] else ...[
//                                 SizedBox(width: 10.w),
//                                 Expanded(
//                                   child: DottedLine(
//                                     direction: Axis.horizontal,
//                                     lineLength: double.infinity,
//                                     lineThickness: 2.w,
//                                     dashLength: 7.w,
//                                     dashColor: Colors.black,
//                                     dashRadius: 0.0,
//                                     dashGapLength: 5.w,
//                                   ),
//                                 ),
//                                 SizedBox(width: 5.w),
//                                 Image.asset(
//                                   AppImage.icPickup,
//                                   width: 30.w,
//                                 ),
//                               ],
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: DottedLine(
//                                   direction: Axis.horizontal,
//                                   lineLength: double.infinity,
//                                   lineThickness: 2.w,
//                                   dashLength: 7.w,
//                                   dashColor: Colors.black,
//                                   dashRadius: 0.0,
//                                   dashGapLength: 5.w,
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               Image.asset(
//                                 AppImage.icFinished,
//                                 width: 30.w,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
//                       margin: EdgeInsets.symmetric(
//                           vertical: 10.h, horizontal: 20.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10.r),
//                         // boxShadow: [
//                         //   AppBoxShadow.defaultShadow(),
//                         // ],
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             AppImage.flag,
//                             width: 30.w,
//                           ),
//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: DottedLine(
//                               direction: Axis.horizontal,
//                               lineLength: double.infinity,
//                               lineThickness: 2.w,
//                               dashLength: 7.w,
//                               dashColor: Colors.black,
//                               dashRadius: 0.0,
//                               dashGapLength: 5.w,
//                             ),
//                           ),
//                           SizedBox(width: 5.w),
//                           Image.asset(
//                             AppImage.flagUser,
//                             width: 30.w,
//                           ),
//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: DottedLine(
//                               direction: Axis.horizontal,
//                               lineLength: double.infinity,
//                               lineThickness: 2.w,
//                               dashLength: 7.w,
//                               dashColor: Colors.black,
//                               dashRadius: 0.0,
//                               dashGapLength: 5.w,
//                             ),
//                           ),
//                           SizedBox(width: 8.w),
//                           Image.asset(
//                             AppImage.flag1,
//                             width: 30.w,
//                           ),
//                         ],
//                       ),
//                     ),
//                   Container(
//                     // height: 78.h,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 15.w, vertical: 12.h),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(85),
//                                     child: _homeController
//                                                 .homeActiveTripModel
//                                                 .value
//                                                 .requests[0]
//                                                 .request
//                                                 ?.else_mobile ==
//                                             null
//                                         ? CustomFadeInImage(
//                                             height: 50.w,
//                                             width: 50.w,
//                                             url: requestElement.request?.user
//                                                         ?.picture !=
//                                                     null
//                                                 ? "${ApiUrl.baseImageUrl}${requestElement.request?.user?.picture}"
//                                                 : "https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png",
//                                             //"${ApiUrl.baseImageUrl}/${requestElement.request?.user?.picture ?? "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png"}",
//                                             fit: BoxFit.cover,
//                                           )
//                                         : CustomFadeInImage(
//                                             height: 50.w,
//                                             width: 50.w,
//                                             url:
//                                                 "https://www.elluminatiinc.com/wp-content/uploads/2020/06/txapfrsl/onlinetaxibookingappdevelopment.png",
//                                             //"${ApiUrl.baseImageUrl}/${requestElement.request?.user?.picture ?? "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png"}",
//                                             fit: BoxFit.cover,
//                                           ),
//                                   ),
//                                   SizedBox(
//                                     width: 10.w,
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           _homeController
//                                                       .homeActiveTripModel
//                                                       .value
//                                                       .requests[0]
//                                                       .request
//                                                       ?.else_mobile ==
//                                                   null
//                                               ? Text(
//                                                   "${requestElement.request?.user?.firstName ?? ""} ${requestElement.request?.user?.lastName ?? ""}",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         AppColors.primaryColor,
//                                                     fontSize: 14.sp,
//                                                   ),
//                                                 )
//                                               : Text(
//                                                   "${_homeController.homeActiveTripModel.value.requests[0].request?.book_someone_name ?? ""}",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         AppColors.primaryColor,
//                                                     fontSize: 14.sp,
//                                                   ),
//                                                 ),
//                                           // Row(
//                                           //   children: [
//                                           //     RatingBar.builder(
//                                           //       initialRating: _strToDouble(
//                                           //           s: requestElement.request
//                                           //                   ?.user?.rating ??
//                                           //               "0"),
//                                           //       minRating: 1,
//                                           //       direction: Axis.horizontal,
//                                           //       allowHalfRating: true,
//                                           //       ignoreGestures: true,
//                                           //       itemCount: 5,
//                                           //       itemPadding:
//                                           //           EdgeInsets.symmetric(
//                                           //               horizontal: 0.5.w),
//                                           //       itemBuilder: (context, _) =>
//                                           //           Icon(
//                                           //         Icons.star,
//                                           //         color: Colors.amber,
//                                           //       ),
//                                           //       itemSize: 12.w,
//                                           //       onRatingUpdate: (rating) {},
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.star,
//                                                 size: 15,
//                                                 color: Colors.grey[300],
//                                               ),
//                                               SizedBox(
//                                                 width: 3,
//                                               ),
//                                               Text(
//                                                   '${requestElement.request?.user?.rating ?? "0"}',
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: AppColors
//                                                           .primaryColor))
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           if (cont.providerUiSelectionType.value ==
//                               ProviderUiSelectionType.pickedUpRequest)
//                             Expanded(
//                               flex: 1,
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 1,
//                                     height: MediaQuery.of(context).size.height *
//                                         0.05,
//                                     color: AppColors.gray,
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               cont.waitingTime();
//                                             },
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 15.w,
//                                                   vertical: 5.h),
//                                               decoration: BoxDecoration(
//                                                 color: AppColors.primaryColor,
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: Text(
//                                                 "waiting_time".tr,
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 10),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 5.h,
//                                           ),
//                                           Text(
//                                             _waitingTimeIntToString(
//                                                 cont.waitingTimeSec.value),
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 13),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (!isShowBtnTapWhenDropped)
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.1,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             _showCancelDialog(
//                                 requestId: "${requestElement.requestId}");
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                             decoration: BoxDecoration(
//                               color: Color(0xffD9D9D9),
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   bottomLeft: Radius.circular(20)),
//                               // boxShadow: [
//                               //   BoxShadow(
//                               //     color: AppColors.lightGray.withOpacity(0.5),
//                               //     blurRadius: 16.r,
//                               //     spreadRadius: 2.w,
//                               //     offset: Offset(0, 12.h),
//                               //   )
//                               // ],
//                             ),
//                             child: Text(
//                               'cancel'.tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.primaryColor),
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             if (cont.providerUiSelectionType.value ==
//                                 ProviderUiSelectionType.startedRequest) {
//                               _updateStatus(checkStatus: CheckStatus.ARRIVED);
//                             }
//                             if (cont.providerUiSelectionType.value ==
//                                 ProviderUiSelectionType.arrivedRequest) {
//                               if (cont.homeActiveTripModel.value.rideOtp == 1) {
//                                 Get.dialog(OtpDialog()).then((value) {
//                                   if (value is bool) {
//                                     if (value == true) {
//                                       _updateStatus(
//                                           checkStatus: CheckStatus.PICKEDUP);
//                                     }
//                                   }
//                                 });
//                               } else {
//                                 _updateStatus(
//                                     checkStatus: CheckStatus.PICKEDUP);
//                               }
//                             }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 0.5,
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryColor,
//                               borderRadius: BorderRadius.zero,
//                               // boxShadow: [
//                               //   BoxShadow(
//                               //     color: AppColors.lightGray.withOpacity(0.5),
//                               //     blurRadius: 16.r,
//                               //     spreadRadius: 2.w,
//                               //     offset: Offset(0, 12.h),
//                               //   )
//                               // ],
//                             ),
//                             child: Text(
//                               btnStatusTitle,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         // Expanded(
//                         //   child: CustomButton(
//                         //     text: 'cancel'.tr,
//                         //     textColor: Colors.red,
//                         //     bgColor: Colors.white,
//                         //     fontWeight: FontWeight.w400,
//                         //     fontSize: 14.sp,
//                         //     onTap: () {
//                         //       _showCancelDialog(
//                         //           requestId: "${requestElement.requestId}");
//                         //     },
//                         //   ),
//                         // ),
//                         // SizedBox(width: 10.w),
//                         // Expanded(
//                         //   child: CustomButton(
//                         //     text: btnStatusTitle,
//                         //     textColor: Colors.white,
//                         //     bgColor: AppColors.appColor,
//                         //     fontWeight: FontWeight.w400,
//                         //     fontSize: 14.sp,
//                         //     onTap: () {
//                         //       if (cont.providerUiSelectionType.value ==
//                         //           ProviderUiSelectionType.startedRequest) {
//                         //         _updateStatus(checkStatus: CheckStatus.ARRIVED);
//                         //       }
//                         //       if (cont.providerUiSelectionType.value ==
//                         //           ProviderUiSelectionType.arrivedRequest) {
//                         //         if (cont.homeActiveTripModel.value.rideOtp ==
//                         //             1) {
//                         //           Get.dialog(OtpDialog()).then((value) {
//                         //             if (value is bool) {
//                         //               if (value == true) {
//                         //                 _updateStatus(
//                         //                     checkStatus: CheckStatus.PICKEDUP);
//                         //               }
//                         //             }
//                         //           });
//                         //         } else {
//                         //           _updateStatus(
//                         //               checkStatus: CheckStatus.PICKEDUP);
//                         //         }
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   if (isShowBtnTapWhenDropped)
//                     TextButton(onPressed: () {
//                        print("statusss===>${isShowBtnTapWhenDropped}");
//                     }, child: Text("sdsd")),
//                     InkWell(
//                       onTap: () {
//                         if (multiPleLocationText != null) {
//                           Map<String, String> params = {};
//                           params["location_id"] = "${currentDestination.id}";
//                           params["request_id"] =
//                               "${currentDestination.requestId}";
//                           params["status"] = CheckStatus.PICKEDUP;
//                           cont.updateMultipleDestination(params: params);
//                           return;
//                         }
//                         Get.dialog(AddTollChargeDialog());
//                         // _showDeclineDialog(context);
//                         cont.waitingTimeSec.value = 0;
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: EdgeInsets.symmetric(vertical: 14.h),
//                         margin: EdgeInsets.symmetric(horizontal: 45),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(20),
//                           // boxShadow: [
//                           //   BoxShadow(
//                           //     color: AppColors.lightGray.withOpacity(0.5),
//                           //     blurRadius: 16.r,
//                           //     spreadRadius: 2.w,
//                           //     offset: Offset(0, 12.h),
//                           //   )
//                           // ],
//                         ),
//                         child: Text(
//                           multiPleLocationText ?? "end_ride".tr,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   // Padding(
//                   //   padding: EdgeInsets.only(top: 10.h),
//                   //   child: CustomButton(
//                   //     text: multiPleLocationText ?? "End Ride",
//                   //     fontWeight: FontWeight.w400,
//                   //     fontSize: 14.sp,
//                   //     onTap: () {
//                   //       if (multiPleLocationText != null) {
//                   //         Map<String, String> params = {};
//                   //         params["location_id"] = "${currentDestination.id}";
//                   //         params["request_id"] =
//                   //             "${currentDestination.requestId}";
//                   //         params["status"] = CheckStatus.PICKEDUP;
//                   //         cont.updateMultipleDestination(params: params);
//                   //         return;
//                   //       }
//                   //       Get.dialog(AddTollChargeDialog());
//                   //       // _showDeclineDialog(context);
//                   //     },
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                 ],
//               ),
//             ),
//             // SizedBox(height: 10.h),
//           ],
//         );
//       }),
//     );
//   }
//
//   Future<void> _showBreakDownDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // user must tap button!
//       builder: (BuildContext context) {
//         return Center(
//           child: SingleChildScrollView(
//             child: AlertDialog(
//               backgroundColor: Colors.grey,
//               iconColor: Colors.white,
//               // icon: Align(
//               //     alignment: Alignment.topRight,
//               //     child: IconButton(
//               //         onPressed: () async {
//               //           setState(() {
//               //             isBreakDown = false;
//               //           });
//               //           Get.back();
//               //           List placemarks = await placemarkFromCoordinates(
//               //               _homeController.userCurrentLocation!.latitude,
//               //               _homeController.userCurrentLocation!.longitude);
//               //           print("placemarks===>${placemarks[2]}");
//               //           Placemark place = placemarks[0];
//               //           print(
//               //               "aaaaa===> '${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}'");
//               //           print(
//               //               "currentDestination.longitude===>${currentDestination.dAddress}");
//               //           print(
//               //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.latitude}");
//               //           print(
//               //               "currentDestination.longitude===>${_homeController.userCurrentLocation!.longitude}");
//               //         },
//               //         icon: Icon(Icons.close))),
//               content: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       height: 200,
//                       // margin:
//                       //     EdgeInsets.symmetric(horizontal: 25.w, vertical: 10),
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20.r)),
//                       child: TextFormField(
//                         maxLines: 20,
//                         controller: _userController.breakDownController,
//                         validator: (text) {
//                           if (text == null || text.isEmpty) {
//                             return 'Description is required';
//                           }
//                           return null;
//                         },
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: AppColors.primaryColor,
//                             fontWeight: FontWeight.w500),
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 25),
//                           border: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           hintText: "Description",
//                           hintStyle: TextStyle(
//                               fontSize: 18,
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                       child: CustomButton(
//                         text: "Submit",
//                         fontWeight: FontWeight.w500,
//                         fontSize: 19,
//                         onTap: () async {
//                           if (_formKey.currentState!.validate()) {
//                             print(
//                                 "currentDestination.id===>${currentDestination.id}");
//                             print(
//                                 "currentDestination.id===>${currentDestination.requestId}");
//                             Map<String, String> params = {};
//                             params["location_id"] = "${currentDestination.id}";
//                             params["request_id"] =
//                                 "${currentDestination.requestId}";
//                             params["status"] = CheckStatus.PICKEDUP;
//                             _homeController.updateMultipleDestination(
//                                 params: params);
//                             setState(() {
//                               isBreakDown = true;
//                             });
//                             List placemarks = await placemarkFromCoordinates(
//                                 _homeController.userCurrentLocation!.latitude,
//                                 _homeController.userCurrentLocation!.longitude);
//                             Placemark place = placemarks[0];
//                             _homeController.breakDownDriverId.value =
//                                 currentDestination.requestId;
//                             _homeController.breakDownDestinationLat.value =
//                                 currentDestination.latitude!;
//                             _homeController.breakDownDestinationLong.value =
//                                 currentDestination.longitude!;
//                             _homeController.breakDownDestinationAddress.value =
//                                 currentDestination.dAddress!;
//
//                             _homeController.breakDownSourceLat.value =
//                                 _homeController.userCurrentLocation!.latitude;
//                             _homeController.breakDownSourceLong.value =
//                                 _homeController.userCurrentLocation!.longitude;
//                             print("place.name===>${place.name}");
//                             print("place.name===>${place.subLocality}");
//                             _homeController.breakDownSourceAddress.value =
//                                 "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
//
//                             params["status"] = "DROPPED";
//                             params["_method"] = "PATCH";
//                             params["breakdown"] = "1";
//                             params["breakdown_comment"] =
//                                 _userController.breakDownController.text;
//                             _homeController.updateTrip(data: params);
//                             // params["_method"] = CheckStatus.PATCH.toString();
//                             // params["status"] = CheckStatus.COMPLETED.toString();
//                             // await _homeController.updateBreakDownTrip(
//                             //     data: params);
//                             // params["_method"] = CheckStatus.PATCH;
//                             // params["status"] = CheckStatus.COMPLETED;
//                             // _homeController.updateBreakDownTrip(data: params);
//                             Get.back();
//                             Get.back();
//                           }
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               // actions: <Widget>[
//               //   TextButton(
//               //     child: Text('Close'),
//               //     onPressed: () {
//               //       Get.back();
//               //     },
//               //   ),
//               // ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<Position?> determinePosition() async {
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.showSnackbar(GetSnackBar(
//           messageText: Text(
//             "location_permissions_are_denied".tr,
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           mainButton: InkWell(
//             onTap: () {},
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Text(
//                 "allow".tr,
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ));
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       await openAppSettings();
//     }
//     Position? position;
//     try {
//       position = await Geolocator.getCurrentPosition();
//     } catch (e) {
//       Get.showSnackbar(GetSnackBar(
//         messageText: Text(
//           e.toString(),
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         mainButton: InkWell(
//           onTap: () {},
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               "allow".tr,
//               style: TextStyle(
//                 color: Colors.orange,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ));
//       // showError(msg: e.toString());
//     }
//     if (position != null) {
//       LatLng latLng = LatLng(position.latitude, position.longitude);
//       _homeController.userCurrentLocation = latLng;
//       CameraPosition cameraPosition = CameraPosition(
//         target: LatLng(latLng.latitude, latLng.longitude),
//         zoom: 14.4746,
//       );
//       _homeController.googleMapController
//           ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//       if (_homeController.userImageMarker != null) {
//         _homeController.showMarker(
//             latLng: _homeController.userCurrentLocation!,
//             oldLatLng: _homeController.userCurrentLocation!);
//       } else {
//         _capturePng();
//       }
//     }
//     return position;
//   }
//
//   Future<Uint8List?> _capturePng() async {
//     try {
//       print('inside');
//       RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
//           ?.findRenderObject() as RenderRepaintBoundary?;
//       ui.Image? image = await boundary?.toImage(pixelRatio: 3);
//       ByteData? byteData =
//           await image?.toByteData(format: ui.ImageByteFormat.png);
//       var pngBytes = byteData?.buffer.asUint8List();
//       _homeController.userImageMarker = pngBytes;
//       var bs64 = base64Encode(pngBytes!);
//       print(pngBytes);
//       print(bs64);
//       if (_homeController.userCurrentLocation != null) {
//         _homeController.showMarker(
//             latLng: _homeController.userCurrentLocation!,
//             oldLatLng: LatLng(0, 0));
//       }
//       return pngBytes;
//     } catch (e) {
//       print(e);
//       _homeController.isCaptureImage.value = false;
//     }
//     return null;
//   }
//
//   double _strToDouble({required String s}) {
//     double rating = 0;
//     try {
//       rating = double.parse(s);
//     } catch (e) {
//       rating = 0;
//     }
//     return rating;
//   }
//
//   void _updateStatus({required String checkStatus}) {
//     Map<String, String> params = {};
//     params["status"] = checkStatus;
//     params["_method"] = "PATCH";
//     _homeController.updateTrip(data: params);
//   }
//
//   String _waitingTimeIntToString(int value) {
//     int hours = value ~/ 3600;
//     int minutes = (value % 3600) ~/ 60;
//     int seconds = value % 60;
//     return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
//   }
//
//   Future<void> _showCancelDialog({required String requestId}) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Text('are_you_sure_want_to_cancel_this_request'.tr),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('no'.tr),
//               onPressed: () {
//                 Get.back();
//               },
//             ),
//             TextButton(
//               child: Text('yes'.tr),
//               onPressed: () {
//                 Get.back();
//                 Get.bottomSheet(ReasonForCancelling(
//                   cancelId: requestId,
//                 ));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
