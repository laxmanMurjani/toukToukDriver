import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/model/document_model.dart';
import 'package:mozlit_driver/ui/drawer_srceen/document_image_show.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class DriverDocumentChangeScreen extends StatefulWidget {
  bool isForceFullyAdd;
  Document? document;

  DriverDocumentChangeScreen({this.isForceFullyAdd = false, this.document});

  @override
  _DriverDocumentChangeScreenState createState() => _DriverDocumentChangeScreenState();
}

class _DriverDocumentChangeScreenState
    extends State<DriverDocumentChangeScreen> {
  final UserController _userController = Get.find();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // _userController.getDocument();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isForceFullyAdd) {
          // _showLogoutDialog();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          text: widget.document!.name,
          onBackPress: widget.isForceFullyAdd
              ? () {
                  // Get.back();
                  _showLogoutDialog();
                }
              : null,
        ),
        backgroundColor: AppColors.bgColor,
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
              Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 100.0),
                  //   child: Image.asset(
                  //     AppImage.logoOpacity,
                  //     width: 300,
                  //     height: 300,
                  //   ),
                  // ),
                  //  Image.network( "${ApiUrl.baseImageUrl}/storage/${widget.document!.providerDocuments?.url ?? ""}",height: 100,width: 100),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.85,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: AppColors.primaryColor, width: 1)),
                    child:widget.document!.imagePath != null ? Image.file(File(widget.document!.imagePath! )) :
                    GestureDetector(
                      onTap: () {
                        // Get.to(DocumentImageShow(),arguments: ["${ApiUrl.baseImageUrl}/storage/${widget.document!.providerDocuments?.url ?? ""}"]);
                      },
                      child:widget.document!.providerDocuments == null ? Image.network("https://etoride.etomotors.com/storage/provider/documents/DrivingLicense.jpg") : Image.network(
                         "${ApiUrl.baseImageUrl}/storage/${widget.document!.providerDocuments?.url ?? ""}",
                        fit: BoxFit.fitHeight,
                        // height: 200,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Choose option",
                                style: TextStyle(color: Colors.blue),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Divider(
                                      height: 1,
                                      color: Colors.blue,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Get.back();
                                        _imagePick(document: widget.document!);
                                      },
                                      title: Text("Gallery"),
                                      leading: Icon(
                                        Icons.account_box,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.blue,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Get.back();
                                        _photoPick(document: widget.document!);
                                      },
                                      title: Text("Camera"),
                                      leading: Icon(
                                        Icons.camera,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                      //_imagePick(document: document);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 45,
                      width: 200,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("edit".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      //_imagePick(document: document);
                      cont.uploadDocument(
                          documentId: widget.document!.id,
                          documentImagePath: widget.document!.imagePath);
                      widget.document!.imagePath = null;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 45,
                      width: 200,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("save".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Padding(
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         CustomButton(
                  //           text: "add_document".tr,
                  //           onTap: () {
                  //             cont.uploadDocument();
                  //           },
                  //         ),
                  //         SizedBox(height: 15.h)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
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
