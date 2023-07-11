import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/logging_dio_interceptor.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';

class ApiService {
  static final Dio _dio = Dio();

  UserController _userController = Get.find();

  ApiService() {
    _dio.interceptors.add(LoggingDioInterceptor());
  }

  Future<void> postRequest({
    required String url,
    dynamic params,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String) onError,
  }) async {
    try {
      print('Method => POST , API URL ==> $url');
      print('Params ==> $params');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      _dio.options.headers.addAll(headers);
      var response = await _dio.post(url, data: params);
      log("response  ===>  $response");
      if (response.statusCode != 200) {
        onError(ErrorType.none,
            "${response.data['message'] ?? response.data['error']}");
      } else {
        log("response000  ===>  ${response.statusCode}");
        log("response000  ===>  ${response.data['message']}");
        log("response  ===>  1  ${response.data.runtimeType}  ${response.data is HashMap}  ${response.data is Map}");
        if (response.data is HashMap || response.data is Map) {
          log("response  ===>  12");
          if (response.data["status"] != null ||
              response.data["error"] != null) {
            log("response  ===>  123    ${response.data["error"]}");
            if ((response.data["status"] != null &&
                    response.data["status"] == false) ||
                response.data["error"] != null) {
              log("response  ===>  1234");
              onError(ErrorType.none,
                  "${response.data['message'] ?? response.data['error']}");
              return;
            }
            log("response  ===>  12345");
          }
          log("response  ===>  123456");
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
        // onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error  ===>  $e  ${e.response}  ${e.type}  ${e.requestOptions.uri}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, e.message);
      }
      if (e.response != null) {
        print('Error  ===>  ${e.response?.data}  ${e.type} 123  ${e.requestOptions.uri}');
        onError(ErrorType.none, "${e.response?.data['message'] ?? e.response?.data['error']}");
      }
    }catch(e){
      onError(ErrorType.none, "$e");

    }
    return;
  }

  Future<void> getRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => GET , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.get(url);
      log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }
    return;
  }

  Future<void> deleteRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => DELETE , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.delete(url);
      log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }
    return;
  }

  Future<void> putRequest({
    required String url,
    dynamic params,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => PUT , API URL ==> $url');
      print('Params ==> $params');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization": "Token ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      _dio.options.headers.addAll(headers);
      var response = await _dio.put(url, data: params);
      log("response   ===>   $response");
      onSuccess(json.decode(response.toString()));
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none, e.response?.data['message']);
      }
    }
    return;
  }
}

ApiService apiService = ApiService();
