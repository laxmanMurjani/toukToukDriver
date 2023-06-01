import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_in_up_screen.dart';
import '../model/login_response_model.dart';
import 'api.dart';

class LoggingDioInterceptor implements Interceptor {
  UserController _userController = getX.Get.find();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log("message ==> response  $err ${err.response?.statusCode}    ${err.response?.data}");
    log("message ==> response  ${err.requestOptions.baseUrl}   123 ${err.requestOptions.uri}    ");
    if (err.response?.statusCode == 401 &&
        err.requestOptions.uri.toString() != ApiUrl.login &&
        err.requestOptions.uri.toString() != ApiUrl.sendotpBoth) {
      _userController.userToken.value = LoginResponseModel();
      _userController.userToken.refresh();
      getX.Get.offAll(() => SignInUpScreen());
    }
    handler.next(err);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    log("message ==> response  $response ${response.statusCode}    ${response.data}  ${response.requestOptions.uri}");
    if (response.statusCode == 401 &&
        response.requestOptions.uri.toString() != ApiUrl.login &&
        response.requestOptions.uri.toString() != ApiUrl.sendotpBoth) {
      _userController.userToken.value = LoginResponseModel();
      _userController.userToken.refresh();
      getX.Get.offAll(() => SignInUpScreen());
    }
    handler.next(response);
  }
}
