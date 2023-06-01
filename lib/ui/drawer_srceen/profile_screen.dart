import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/change_password_sceen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_fade_in_image.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/dialog/account_delete_dialog.dart';
import 'package:mozlit_driver/ui/widget/dialog/show_qr_dialog.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

import '../widget/custom_text_filed.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _userController.clearFormData();
    _userController.imageFilePah = null;
    _userController.firstNameController.text =
        _userController.userData.value.firstName ?? "";
    _userController.lastNameController.text =
        _userController.userData.value.lastName ?? "";
    _userController.phoneNumberController.text =
        _userController.userData.value.mobile ?? "";
    _userController.emailController.text = "";
        //_userController.userData.value.email ?? "";

    _userController.carModelController.text =
        _userController.userData.value.service?.serviceModel ?? "";
    _userController.carNumberController.text =
        _userController.userData.value.service?.serviceNumber ?? "";
    _userController.carServiceController.text =
        _userController.userData.value.service?.serviceType?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(
        text: "profile".tr,
      ),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }

        String? profileUrl;
        if (cont.userData.value.avatar != null) {
          profileUrl =
              "${ApiUrl.baseImageUrl}${cont.userData.value.avatar ?? ""}";
        }
        return Stack(
          children: [
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Image.asset(
            //     AppImage.logoOpacity,
            //     width: 300,
            //     height: 300,
            //   ),
            // ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
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
                                        _imagePick();
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
                                        _photoPick();
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
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomFadeInImage(
                            height: 196.w,
                            width: 185.w,
                            url:
                                "${cont.imageFilePah ?? profileUrl ?? 'https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png'}",
                            placeHolder: AppImage.icUserPlaceholder,
                            fit: BoxFit.cover,
                          ),
                        ),
                        _homeController.homeActiveTripModel.value.providerVerifyCheck == null? SizedBox() :
                        _homeController.homeActiveTripModel.value.providerVerifyCheck == 'verified'?
                        Positioned(bottom:8.h, right:8.h,child: Container(height:50, width:50,decoration: BoxDecoration(
                            color:Colors.white,shape: BoxShape.circle
                        ),
                            child: Image.asset(AppImage.verifiedIcon,height: 50,width: 50,)),) : SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.firstNameController,
                        "first_name".tr, "first_name".tr, double.infinity),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.lastNameController,
                        "last_name".tr, "last_name".tr, double.infinity),
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  //   child: customAppTextFieldWidget(cont.emailController,
                  //       "email".tr, "email".tr, double.infinity,
                  //       isReadOnly: true),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 55,
                              width: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.white,
                                  boxShadow: [AppBoxShadow.defaultShadow()]),
                              child: Row(
                                children: [
                                  CountryCodePicker(
                                    onChanged: (s) {},
                                    textStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    hideMainText: true,
                                    initialSelection:
                                        cont.userData.value.countryCode ??
                                            "+91",
                                    // favorite: ['+91', 'IN'],
                                    // countryFilter: ['IT', 'FR', "IN"],
                                    showFlagDialog: true,
                                    comparator: (a, b) =>
                                        b.name!.compareTo(a.name.toString()),
                                    //Get the country information relevant to the initial selection
                                    onInit: (code) => print(
                                        "on init ${code!.name} ${code.dialCode} ${code.name}"),
                                  ),
                                  Image.asset(
                                    AppImage.downArrow1,
                                    height: 15,
                                    width: 15,
                                    fit: BoxFit.contain,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 55,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.white,
                                  boxShadow: [AppBoxShadow.defaultShadow()]),
                              child: TextField(
                                controller: cont.phoneNumberController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 3.0),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        height: 1),
                                    hintText: "Phone Number".tr,
                                    fillColor: AppColors.white),
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                                // textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      if(_userController.userData.value.mobile!.contains(cont.phoneNumberController.text)){
                        print("same");
                        cont.updateProfile();
                      } else {

                        print("other");
                        cont.sendProfileOtp();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      alignment: Alignment.center,
                      height: 55,
                      width: 150,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text("save".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Container(
                  //                 height: 55,
                  //                 width: 110,
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(20),
                  //                     color: AppColors.primaryColor),
                  //                 child: Row(
                  //                   children: [
                  //                     CountryCodePicker(
                  //                       onChanged: (s) {},
                  //                       textStyle: TextStyle(color: Colors.white),
                  //                       hideMainText: true,
                  //
                  //                       initialSelection:
                  //                           cont.userData.value.countryCode ??
                  //                               "+91",
                  //                       // favorite: ['+91', 'IN'],
                  //                       // countryFilter: ['IT', 'FR', "IN"],
                  //                       showFlagDialog: true,
                  //                       comparator: (a, b) =>
                  //                           b.name!.compareTo(a.name.toString()),
                  //                       //Get the country information relevant to the initial selection
                  //                       onInit: (code) => print(
                  //                           "on init ${code!.name} ${code.dialCode} ${code.name}"),
                  //                     ),
                  //                     Image.asset(
                  //                       AppImage.downArrow,
                  //                       height: 15,
                  //                       width: 15,
                  //                       fit: BoxFit.contain,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: 20,
                  //               ),
                  //               Container(
                  //                 width: 200,
                  //                 height: 50,
                  //                 alignment: Alignment.center,
                  //                 child: TextField(
                  //                   controller: cont.phoneNumberController,
                  //                   readOnly: true,
                  //                   decoration: InputDecoration(
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(15.0),
                  //                       ),
                  //                       filled: true,
                  //                       hintStyle: TextStyle(
                  //                           color: AppColors.white, height: 1),
                  //                       hintText: "Phone Number".tr,
                  //                       fillColor: AppColors.primaryColor),
                  //                   style: TextStyle(
                  //                       color: AppColors.white,
                  //                       fontWeight: FontWeight.bold),
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  //   child: customAppTextFieldWidget(cont.carServiceController,
                  //       "car_type".tr, "car_type".tr, double.infinity,
                  //       isReadOnly: true),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  //   child: customAppTextFieldWidget(cont.carModelController,
                  //       "car_name".tr, "car_name".tr, double.infinity,
                  //       isReadOnly: true),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  //   child: customAppTextFieldWidget(cont.carNumberController,
                  //       "car_number".tr, "car_number".tr, double.infinity,
                  //       isReadOnly: true),
                  // ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => ChangePasswordScreen());
              },
              child: Container(
                alignment: Alignment.center,
                height: 65,
                width: 150,
                decoration: BoxDecoration(
                    color: Color(0xFFF1F2F3),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(50))),
                child: Text("change_password".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            InkWell(
              onTap: () {
                Get.dialog(
                  AccountDeleteDialog(),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 65,
                width: 150,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(50))),
                child: Text("delete_account".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _imagePick() async {
    _userController.removeUnFocusManager();

    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      _userController.imageFilePah = image.path;
      setState(() {});
    }
  }

  Future<void> _photoPick() async {
    _userController.removeUnFocusManager();

    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);
    if (image != null) {
      _userController.imageFilePah = image.path;
      setState(() {});
    }
    print("imagePath==> ${_userController.imageFilePah}");
  }

  Widget customAppTextFieldWidget(TextEditingController controller,
      String hintText, String titleText, double width,
      {bool? isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(titleText,
          //     style: TextStyle(
          //         fontSize: 16,
          //         color: AppColors.primaryColor,
          //         fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Container(
            width: width,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [AppBoxShadow.defaultShadow()],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              readOnly: isReadOnly!,
              scrollPadding: EdgeInsets.symmetric(horizontal: 10),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                  ),
                  filled: true,isDense: true,
                  hintStyle: TextStyle(color: AppColors.white, height: 1),
                  hintText: hintText.tr,
                  fillColor: AppColors.white),
              style: TextStyle(color: AppColors.primaryColor),
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
