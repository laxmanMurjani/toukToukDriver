import 'dart:convert';
import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/user_module_type.dart';
import 'package:mozlit_driver/model/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'languages.dart';

class UserDetails {
  Future<void> saveUserDetails(LoginResponseModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("user", jsonEncode(userModel.toJson()));
  }

  Future<void> saveUserModuleType(UserModuleType userModuleType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("user_module_type", userModuleType.name);

  }

  Future<void> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("user");
  }

  // Future<void> saveLanguage(int selectedLanguage) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setInt("languages",selectedLanguage);
  // }


  Future<LoginResponseModel> get getSaveUserDetails async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("user");
    log("message  ==>  $userData");
    if (userData == null) {
      return LoginResponseModel();
    }
    return loginResponseModelFromJson(userData);
  }
  Future<UserModuleType> get getSaveUserModuleType async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("user_module_type");
    log("message  ==>  $userData");
    print("userData$userData");
    if (userData == null) {
      return UserModuleType.TAXI;
    }
    return userData.userModuleType;
  }

  // Future<int> get getSaveLanguages async{
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int? selectedLanguage = sharedPreferences.getInt("languages");
  //   log("message  ================================================================>  $selectedLanguage");
  //   return selectedLanguage!;
  // }

  Future<void> saveTutorialShow({bool isTutorialShow = false}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isTutorialShow", isTutorialShow);
  }

  Future<bool> get isTutorialShow async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isTutorialShow") ?? false;
  }
}
