import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mozlit_driver/api/api.dart';
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

class VehicleProfileScreen extends StatefulWidget {
  @override
  _VehicleProfileScreenState createState() => _VehicleProfileScreenState();
}

class _VehicleProfileScreenState extends State<VehicleProfileScreen> {
  final UserController _userController = Get.find();
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
    _userController.emailController.text =
        _userController.userData.value.email ?? "";

    _userController.carModelController.text =
        _userController.userData.value.service?.serviceModel ?? "";
    _userController.carNumberController.text =
        _userController.userData.value.service?.serviceNumber ?? "";
    _userController.carServiceController.text =
        _userController.userData.value.service?.serviceType?.name ?? "";

    _userController.carCompanyNameController.text =
        _userController.userData.value.service?.car_camp_name ?? "";
        _userController.carColorController.text =
        _userController.userData.value.service?.car_color ?? "";

        print("ccccccc====>${_userController.carModelController.text}  == ${_userController.carNumberController.text}");
        print("ccccccc====>${_userController.carServiceController.text}  == ${_userController.carCompanyNameController.text}");
        print("ccccccc====>${_userController.carColorController.text}  ");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(
        text: "vehicle_details".tr,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.carServiceController,
                        "car_type".tr, "car_type".tr, double.infinity,
                        isReadOnly: true),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.carModelController,
                        "car_name".tr, "car_name".tr, double.infinity,
                        isReadOnly: true),
                  ), SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.carCompanyNameController,
                        "car_model".tr, "car_model".tr, double.infinity,
                        isReadOnly: true),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.carNumberController,
                        "car_number".tr, "car_number".tr, double.infinity,
                        isReadOnly: true),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: customAppTextFieldWidget(cont.carColorController,
                        "car_color".tr, "car_color".tr, double.infinity,
                        isReadOnly: true),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     cont.updateProfile();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 45),
                  //     alignment: Alignment.center,
                  //     height: 55,
                  //     width: 150,
                  //     decoration: BoxDecoration(
                  //         color: AppColors.primaryColor,
                  //         borderRadius: BorderRadius.all(Radius.circular(50))),
                  //     child: Text("save".tr,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             color: AppColors.white,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold)),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        );
      }),
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
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [AppBoxShadow.defaultShadow()],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              scrollPadding: EdgeInsets.symmetric(horizontal: 10),
              readOnly: isReadOnly!,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: AppColors.primaryColor, height: 1),
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
