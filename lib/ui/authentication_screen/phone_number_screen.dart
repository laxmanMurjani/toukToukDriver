import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';

import '../widget/custom_text_filed.dart';

class PhoneNumberScreen extends StatefulWidget {
  Map<String, dynamic> params;

  PhoneNumberScreen({required this.params});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final UserController _userController = Get.find();
  @override
  void initState() {
    super.initState();
    _userController.clearFormData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "register".tr,
      ),
      body: GetX<UserController>(
        builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return Center(child: NoInternetWidget());
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("enter_phone_number_to_continue".tr),
                SizedBox(height: 7.h),
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        print("  ==>  ${countryCode.dialCode}");
                        if (countryCode.dialCode != null) {
                          cont.countryCode = countryCode.dialCode!;
                        }
                      },
                      initialSelection: 'IN',
                      // favorite: ['+91', 'IN'],
                      // countryFilter: ['IT', 'FR', 'IN'],
                      showFlagDialog: true,
                      comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                      //Get the country information relevant to the initial selection
                      onInit: (code) => print(
                          "on init ${code!.name} ${code.dialCode} ${code.name}"),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      flex: 2,
                      child: CustomTextFiled(
                        controller: cont.phoneNumberController,
                        label: "phone".tr,
                        hint: "phone".tr,
                        inputType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: "submit".tr,
                  onTap: () {
                    if(cont.phoneNumberController.text.isEmpty){
                      cont.showError(msg: "please_enter_your_mobile_number".tr);
                      return;
                    }
                    cont.sendOtp(params: widget.params);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
