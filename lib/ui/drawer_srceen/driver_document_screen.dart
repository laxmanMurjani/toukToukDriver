import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/document_model.dart';
import 'package:mozlit_driver/ui/drawer_srceen/driver_document_change_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class DriverDocumentScreen extends StatefulWidget {
  bool isForceFullyAdd;

  DriverDocumentScreen({this.isForceFullyAdd = false});

  @override
  _DriverDocumentScreenState createState() => _DriverDocumentScreenState();
}

class _DriverDocumentScreenState extends State<DriverDocumentScreen> {
  final UserController _userController = Get.find();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getDocument();
    });
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return WillPopScope(
      onWillPop: () {
        if (widget.isForceFullyAdd) {
          _showLogoutDialog();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          text: "document".tr,
          onBackPress: widget.isForceFullyAdd
              ? () {
                  // Get.back();
                  _showLogoutDialog();
                }
              : null,
        ),
        backgroundColor: AppColors.bgColor,
        // body: GetX<UserController>(builder: (cont) {
        //   if (cont.error.value.errorType == ErrorType.internet) {
        //     return NoInternetWidget();
        //   }
        //   return Stack(
        //     alignment: Alignment.topCenter,
        //     children: [
        //       if (cont.documentList.isEmpty) ...[
        //         Center(
        //           child: Text("data_not_found".tr),
        //         )
        //       ],
        //       ListView.builder(
        //         itemCount: cont.documentList.length,
        //         padding: EdgeInsets.only(top: 15.h, bottom: 60.h),
        //         itemBuilder: (BuildContext context, int index) {
        //           Document document = cont.documentList[index];
        //           return Container(
        //             margin:
        //                 EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        //             width: MediaQuery.of(context).size.width,
        //             // height: 202,
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               boxShadow: [
        //                 AppBoxShadow.defaultShadow(),
        //               ],
        //               borderRadius: BorderRadius.circular(10.r),
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Padding(
        //                   padding: EdgeInsets.symmetric(
        //                       horizontal: 20, vertical: 10),
        //                   child: Text("${document.name ?? ""}",
        //                       style: TextStyle(
        //                           fontSize: 17,
        //                           color: AppColors.primaryColor,
        //                           fontWeight: FontWeight.bold)),
        //                 ),
        //                 SizedBox(
        //                   height: 5,
        //                 ),
        //                 // TextButton(
        //                 //     onPressed: () {
        //                 //       print(
        //                 //           "fbfsf===>${"${ApiUrl.baseImageUrl}storage/${document.providerDocuments?.url ?? ""}"}");
        //                 //     },
        //                 //     child: Text("fbfsf")),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     InkWell(
        //                       onTap: () async {
        //                         Get.dialog(
        //                           Column(
        //                             mainAxisSize: MainAxisSize.min,
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.center,
        //                             mainAxisAlignment: MainAxisAlignment.center,
        //                             children: [
        //                               Container(
        //                                 margin: EdgeInsets.all(50),
        //                                 height: 250.h,
        //                                 clipBehavior: Clip.antiAlias,
        //                                 decoration: BoxDecoration(
        //                                   color: Colors.white,
        //                                   borderRadius:
        //                                       BorderRadius.circular(20.r),
        //                                   boxShadow: [
        //                                     AppBoxShadow.defaultShadow(),
        //                                   ],
        //                                 ),
        //                                 child: CustomFadeInImage(
        //                                   url: document.imagePath ??
        //                                       "${ApiUrl.baseImageUrl}storage/${document.providerDocuments?.url ?? ""}",
        //                                   fit: BoxFit.contain,
        //                                   height: 200,
        //                                   width: 250,
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         );
        //                       },
        //                       child: Container(
        //                         width: 115,
        //                         height: 46,
        //                         alignment: Alignment.center,
        //                         decoration: BoxDecoration(
        //                           color: Color(0xffF1F2F3),
        //                           borderRadius: BorderRadius.only(
        //                             topRight: Radius.circular(10),
        //                             bottomLeft: Radius.circular(10),
        //                           ),
        //                         ),
        //                         child: Image.asset(AppImage.preview,
        //                             fit: BoxFit.contain, width: 25, height: 25),
        //                       ),
        //                     ),
        //                     InkWell(
        //                       onTap: () async {
        //                         _imagePick(document: document);
        //                       },
        //                       child: Container(
        //                         width: 115,
        //                         height: 46,
        //                         alignment: Alignment.center,
        //                         decoration: BoxDecoration(
        //                           color: AppColors.primaryColor,
        //                           borderRadius: BorderRadius.only(
        //                             topLeft: Radius.circular(10),
        //                             bottomRight: Radius.circular(10),
        //                           ),
        //                         ),
        //                         child: Image.asset(AppImage.edit,
        //                             fit: BoxFit.contain, height: 25, width: 25),
        //                       ),
        //                     ),
        //                   ],
        //                 )
        //               ],
        //             ),
        //           );
        //         },
        //       ),
        //       Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Padding(
        //           padding:
        //               EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               CustomButton(
        //                 text: "add_document".tr,
        //                 onTap: () {
        //                   cont.uploadDocument();
        //                 },
        //               ),
        //               SizedBox(height: 15.h)
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   );
        // }),

        body: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
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
              if (cont.documentList.isEmpty) ...[
                Center(
                  child: Text("data_not_found".tr),
                )
              ],
              ListView.builder(
                itemCount: cont.documentList.length,
                padding: EdgeInsets.only(top: 15.h, bottom: 60.h),
                itemBuilder: (BuildContext context, int index) {
                  Document document = cont.documentList[index];
                  return InkWell(
                    onTap: () {
                      Get.to(()=>DriverDocumentChangeScreen(document: document),preventDuplicates:false);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      width: MediaQuery.of(context).size.width,
                      // height: 202,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          AppBoxShadow.defaultShadow(),
                        ],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: Text("${document.name ?? ""}",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                          // TextButton(onPressed: () {
                          //   print("ssssss====>${ApiUrl.baseImageUrl}/storage/${document.providerDocuments?.url}");
                          // }, child: Text("ddd"))
                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          );
        }),
      ),
    );
  }

  Future<void> _imagePick({required Document document}) async {
    _userController.removeUnFocusManager();

    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);

    log("FGile pAth ===>  ${image?.path}");
    if (image != null) {
      document.imagePath = image.path;
      setState(() {});
    }
  }

  Future<void> _photoPick({required Document document}) async {
    _userController.removeUnFocusManager();

    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);

    log("FGile pAth ===>  ${image?.path}");
    if (image != null) {
      document.imagePath = image.path;
      setState(() {});
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('are_you_sure_want_to_logout'.tr),
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
                _userController.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
