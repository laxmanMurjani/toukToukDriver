import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as location;
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/user_module_type.dart';
import 'package:mozlit_driver/model/breakdown_new_ride_model.dart';
import 'package:mozlit_driver/model/dispute_model.dart';
import 'package:mozlit_driver/model/estimated_fare_model.dart';
import 'package:mozlit_driver/model/fare_with_out_auth_model.dart';
import 'package:mozlit_driver/model/send_new_user_request_model.dart';
import 'package:mozlit_driver/model/summery_model.dart';
import 'package:mozlit_driver/model/trip_history_details_model.dart';
import 'package:mozlit_driver/model/trip_history_model.dart';
import 'package:mozlit_driver/ui/drawer_srceen/driver_document_screen.dart';
import 'package:mozlit_driver/ui/drawer_srceen/signup_driver_document_screen.dart';
import 'package:mozlit_driver/ui/splash_screen.dart';
import 'package:mozlit_driver/ui/widget/dialog/instant_ride_confirm_dialog.dart';
import 'package:mozlit_driver/ui/widget/dialog/ride_update_dialog.dart';
import 'package:mozlit_driver/ui/widget/home_widget/trip_approved_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' as vectorMath;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/api/api_service.dart';
import 'package:mozlit_driver/controller/base_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/enum/provider_ui_selection_type.dart';
import 'package:mozlit_driver/model/home_active_trip_model.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class HomeController extends BaseController {
  final UserController _userController = Get.find();
  Rx<ProviderUiSelectionType> providerUiSelectionType =
      ProviderUiSelectionType.none.obs;
  Rx<HomeActiveTripModel> homeActiveTripModel = HomeActiveTripModel().obs;
  Rx<EstimatedFareModel> estimatedFareModel = EstimatedFareModel().obs;
  Rx<SendNewUserRequestModel> sendNewUserRequestModel = SendNewUserRequestModel().obs;
  // RxList<BreakDownNewRideModel> breakdownNewRideModel = <BreakDownNewRideModel>[].obs;
  Rx<BreakDownNewRideModel> breakdownNewRideModel = BreakDownNewRideModel().obs;
  RxInt timeLeftToRespond = 60.obs;
  Timer? _timer;
  Timer? _getTripTimer;
  RxString homeAddress = "".obs;
  RxInt breakDownDriverId = 0.obs;
  RxDouble breakDownDestinationLat = 0.0.obs;
  RxDouble breakDownDestinationLong = 0.0.obs;
  RxString breakDownDestinationAddress = "".obs;
  RxDouble breakDownSourceLat = 0.0.obs;
  RxDouble breakDownSourceLong = 0.0.obs;
  RxString breakDownSourceAddress = "".obs;

  RxInt waitingTimeSec = 0.obs;
  Uint8List? userImageMarker;
  LatLng? userCurrentLocation;
  RxBool isCaptureImage = false.obs;
  Rx<TripHistoryDetailModel> tripHistoryDetailModel =
      TripHistoryDetailModel().obs;
  RxList<DisputeModel> disputeList = <DisputeModel>[].obs;
  GoogleMapController? googleMapController;
  Rx<CameraPosition> googleMapInitCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ).obs;
  RxList<Polyline> googleMapPolyLine = <Polyline>[].obs;
  Rx<TripHistoryDetailModel> tripDetails = TripHistoryDetailModel().obs;
  RxMap<MarkerId, Marker> googleMarkers = <MarkerId, Marker>{}.obs;
  PolylineId id = PolylineId('poly');
  MarkerId _markerId = const MarkerId("first");
  MarkerId _startPointCap = const MarkerId("startPointCap");
  MarkerId _endPointCap = const MarkerId("endPointCap");

  RxInt _currentDestinationId = 0.obs;
  LatLng? _rideCurrentDestinationLatLng;
  location.Location _location = location.Location.instance;
  GooglePlace googlePlace = GooglePlace(AppString.googleMapKey!);

  FocusNode locationWhereToFocusNode = FocusNode();
  LatLng? latLngWhereTo1;
  TextEditingController tempLocationWhereTo1 = TextEditingController();
  TextEditingController tempLocationFromTo = TextEditingController();
  TextEditingController tempMobileNumberController = TextEditingController();
  TextEditingController tollTaxController = TextEditingController();
  RxList<AutocompletePrediction> searchAddressList =
      <AutocompletePrediction>[].obs;

  RxList<TripHistoryModel> tripHistoryModelList = <TripHistoryModel>[].obs;
  RxString countryCode = "${AppString.defaultCountryCode}".obs;
  RxBool isPickFromMap = false.obs;
  Rx<FareWithOutAuthModel> fareWithOutAuthModel = FareWithOutAuthModel().obs;

  RxBool isSwipeCompleted = false.obs;
  LatLng googleMapLatLng = LatLng(0, 0);
  RxList<Reason> reasonList = <Reason>[].obs;
  Rx<UserModuleType> responseUserModuleType = UserModuleType.TAXI.obs;


  @override
  void onInit() {
    super.onInit();
    // getTrip();
    // BackgroundLocation.getLocationUpdates((location) {
    //   print("location  ==>  $location");
    // });
    // _location.changeSettings(distanceFilter: 10);
    // _location.onLocationChanged.listen((event) {
    //   if (userCurrentLocation?.longitude == 0 &&
    //       userCurrentLocation?.latitude == 0) {
    //     showMarker(
    //         latLng: LatLng(event.latitude ?? 0, event.longitude ?? 0),
    //         oldLatLng: LatLng(event.latitude ?? 0, event.longitude ?? 0));
    //   } else {
    //     showMarker(
    //         latLng: LatLng(event.latitude ?? 0, event.longitude ?? 0),
    //         oldLatLng: userCurrentLocation ?? LatLng(0, 0));
    //   }
    //   userCurrentLocation = LatLng(event.latitude ?? 0, event.longitude ?? 0);
    // });


      _location.changeSettings(distanceFilter: 10);
      _location.onLocationChanged.listen((event) {


        if(userCurrentLocation != null){
          print("checkin location");
          if (userCurrentLocation?.longitude == 0 &&
              userCurrentLocation?.latitude == 0) {
            showMarker(
                latLng: LatLng(event.latitude ?? 0, event.longitude ?? 0),
                oldLatLng: LatLng(event.latitude ?? 0, event.longitude ?? 0));
          } else {
            showMarker(
                latLng: LatLng(event.latitude ?? 0, event.longitude ?? 0),
                oldLatLng: userCurrentLocation ?? LatLng(0, 0));
          }
          userCurrentLocation = LatLng(event.latitude ?? 0, event.longitude ?? 0);
        }

      });


    homeActiveTripModel.listen((HomeActiveTripModel p0) {
      print("object  ==>  ${p0.accountStatus}");
      if (p0.accountStatus == "document") {
        Get.to(() => SignUpDriverDocumentScreen(isForceFullyAdd: true));
        // Get.to(() => DriverDocumentScreen(isForceFullyAdd: true));
      }
      if (p0.requests.isNotEmpty) {
        reasonList.clear();
        reasonList.addAll(p0.reasons);
        startTripTime();
        RequestElement requestElement = p0.requests[0];
        if(requestElement.request?.moduleType == "TAXI" ){
          responseUserModuleType.value = UserModuleType.TAXI;
        }
        if(requestElement.request?.moduleType == "DELIVERY"){
          responseUserModuleType.value = UserModuleType.DELIVERY;
        }
        if(_userController.selectedUserModuleType.value == UserModuleType.BOTH){
          responseUserModuleType.value = UserModuleType.BOTH;
        }
        if (requestElement.request?.status == CheckStatus.SEARCHING) {
          if (providerUiSelectionType.value !=
              ProviderUiSelectionType.searchingRequest) {
            timeLeftToRespond.value = requestElement.timeLeftToRespond ?? 60;
            _startTimer();
          }
          providerUiSelectionType.value =
              ProviderUiSelectionType.searchingRequest;
        }
        if (requestElement.request?.status == CheckStatus.STARTED) {
          if (providerUiSelectionType.value !=
                  ProviderUiSelectionType.startedRequest &&
              googleMapController != null) {
            providerDrawPolyLine(
              s_lat: double.tryParse(p0.providerDetails?.latitude ?? "0") ?? 0,
              s_lng: double.tryParse(p0.providerDetails?.longitude ?? "0") ?? 0,
              d_lat: double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              d_lng: double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0,
            );
            providerUiSelectionType.value =
                ProviderUiSelectionType.startedRequest;
          }

          homeAddress.value = requestElement.request?.sAddress ?? "";
          googleMapLatLng = LatLng(
              double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0);
        }
        if (requestElement.request?.status == CheckStatus.ACCEPTED) {
          if (providerUiSelectionType.value !=
                  ProviderUiSelectionType.acceptedRequest &&
              googleMapController != null) {
            providerDrawPolyLine(
              s_lat: double.tryParse(p0.providerDetails?.latitude ?? "0") ?? 0,
              s_lng: double.tryParse(p0.providerDetails?.longitude ?? "0") ?? 0,
              d_lat: double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              d_lng: double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0,
            );
            providerUiSelectionType.value =
                ProviderUiSelectionType.acceptedRequest;
          }

          homeAddress.value = requestElement.request?.sAddress ?? "";
          googleMapLatLng = LatLng(
              double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0);
        }
        if (requestElement.request?.status == CheckStatus.ARRIVED) {
          if (providerUiSelectionType.value !=
                  ProviderUiSelectionType.arrivedRequest &&
              googleMapController != null) {
            providerDrawPolyLine(
              s_lat: double.tryParse(p0.providerDetails?.latitude ?? "0") ?? 0,
              s_lng: double.tryParse(p0.providerDetails?.longitude ?? "0") ?? 0,
              d_lat: double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              d_lng: double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0,
            );
            // providerDrawPolyLine(
            //   s_lat: double.tryParse(p0.providerDetails?.latitude ?? "0") ?? 0,
            //   s_lng: double.tryParse(p0.providerDetails?.longitude ?? "0") ?? 0,
            //   d_lat: double.tryParse(
            //           requestElement.request?.dLatitude.toString() ?? "0") ??
            //       0,
            //   d_lng: double.tryParse(
            //           requestElement.request?.dLongitude.toString() ?? "0") ??
            //       0,
            // );
            providerUiSelectionType.value =
                ProviderUiSelectionType.arrivedRequest;
          }
          homeAddress.value = requestElement.request?.sAddress ?? "";
          googleMapLatLng = LatLng(
              double.tryParse(
                      requestElement.request?.sLatitude.toString() ?? "0") ??
                  0,
              double.tryParse(
                      requestElement.request?.sLongitude.toString() ?? "0") ??
                  0);
        }
        if (requestElement.request?.status == CheckStatus.PICKEDUP) {
          if (googleMapController != null) {
            bool _isForEachDone = false;
            if (p0.multiDestination.isNotEmpty) {
              for (int i = 0; i < p0.multiDestination.length; i++) {
                MultiDestination multiDestination = p0.multiDestination[i];

                if (!_isForEachDone && multiDestination.isPickedup == 0) {
                  _isForEachDone = true;
                  if (multiDestination.id != _currentDestinationId.value) {
                    _currentDestinationId.value = multiDestination.id;
                    _rideCurrentDestinationLatLng = LatLng(
                        multiDestination.latitude ?? 0,
                        multiDestination.longitude ?? 0);
                    if (i != 0) {
                      MultiDestination sourceDestination =
                          p0.multiDestination[i - 1];
                      providerDrawPolyLine(
                        s_lat: sourceDestination.latitude,
                        s_lng: sourceDestination.longitude,
                        d_lat: multiDestination.latitude,
                        d_lng: multiDestination.longitude,
                      );
                    } else {
                      providerDrawPolyLine(
                        s_lat: requestElement.request?.sLatitude ?? 0,
                        s_lng: requestElement.request?.sLongitude ?? 0,
                        d_lat: multiDestination.latitude,
                        d_lng: multiDestination.longitude,
                      );
                    }
                    homeAddress.value = multiDestination.dAddress ?? "";
                    googleMapLatLng = LatLng(multiDestination.latitude ?? 0,
                        multiDestination.longitude ?? 0);
                  } else {
                    if (_rideCurrentDestinationLatLng != null) {
                      if (_rideCurrentDestinationLatLng?.latitude !=
                              multiDestination.latitude ||
                          _rideCurrentDestinationLatLng?.longitude !=
                              multiDestination.longitude) {
                        _rideCurrentDestinationLatLng = LatLng(
                            multiDestination.latitude ?? 0,
                            multiDestination.longitude ?? 0);
                        Get.dialog(
                            RideUpdateDialog(
                                msg: multiDestination.dAddress ?? ""),
                            barrierDismissible: false);
                        if (i != 0) {
                          MultiDestination sourceDestination =
                              p0.multiDestination[i - 1];
                          providerDrawPolyLine(
                            s_lat: sourceDestination.latitude,
                            s_lng: sourceDestination.longitude,
                            d_lat: multiDestination.latitude,
                            d_lng: multiDestination.longitude,
                          );
                        } else {
                          providerDrawPolyLine(
                            s_lat: requestElement.request?.sLatitude ?? 0,
                            s_lng: requestElement.request?.sLongitude ?? 0,
                            d_lat: multiDestination.latitude,
                            d_lng: multiDestination.longitude,
                          );
                        }
                        homeAddress.value = multiDestination.dAddress ?? "";
                      }
                    }
                  }
                }
              }
            } else if (providerUiSelectionType.value !=
                ProviderUiSelectionType.pickedUpRequest) {
              providerDrawPolyLine(
                s_lat: requestElement.request?.sLatitude ?? 0,
                s_lng: requestElement.request?.sLongitude ?? 0,
                d_lat: requestElement.request?.dLatitude ?? 0,
                d_lng: requestElement.request?.dLongitude ?? 0,
              );
              homeAddress.value = requestElement.request?.dAddress ?? "";
            }
          }
          providerUiSelectionType.value =
              ProviderUiSelectionType.pickedUpRequest;
        }
        if (requestElement.request?.status == CheckStatus.DROPPED) {
          homeAddress.value = "";
          if (providerUiSelectionType.value !=
              ProviderUiSelectionType.droppedRequest) {
            List<LatLng> latLngList = [];
            for (int i = 0; i < p0.multiDestination.length; i++) {
              MultiDestination multiDestination = p0.multiDestination[i];
              latLngList.add(LatLng(multiDestination.latitude ?? 0,
                  multiDestination.longitude ?? 0));
            }

            providerDrawPolyLine(
              s_lat: requestElement.request?.sLatitude ?? 0,
              s_lng: requestElement.request?.sLongitude ?? 0,
              d_lat: requestElement.request?.dLatitude ?? 0,
              d_lng: requestElement.request?.dLongitude ?? 0,
              latLngList: latLngList,
            );
            providerUiSelectionType.value =
                ProviderUiSelectionType.droppedRequest;
          }
          Future.delayed(Duration(milliseconds: 300), () {
            refresh();
          });
        }
        if (requestElement.request?.status == CheckStatus.COMPLETED) {
          providerUiSelectionType.value =
              ProviderUiSelectionType.completedRequest;
          homeAddress.value = "";
        }
      } else {
        googleMapPolyLine.clear();
        googleMapPolyLine.refresh();
        if (googleMarkers.length > 1) {
          googleMarkers.clear();
        }
        if (userCurrentLocation != null) {
          Marker _userMarker = Marker(
              markerId: _markerId,
              // rotation: _bearingBetweenLocations(oldLatLng, latLng),
              position: userCurrentLocation!,
              anchor: Offset(0, 0.7),
              // ripple: true,
              icon: BitmapDescriptor.fromBytes(userImageMarker!));
          googleMarkers[_markerId] = _userMarker;
        }

        cancelTripTime();
        homeAddress.value = "";
        providerUiSelectionType.value = ProviderUiSelectionType.none;
      }
    });
  }

  Future<void> getTrip() async {
    try {
      await apiService.getRequest(
        url:
            "${ApiUrl.getTrip}?latitude=${userCurrentLocation?.latitude}&longitude=${userCurrentLocation?.longitude}",
        onSuccess: (Map<String, dynamic> data) {
          homeActiveTripModel.value =
              homeActiveTripModelFromJson(jsonEncode(data["response"]));

        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<void> updateTrip({Map<String, String>? data}) async {
    try {
      removeUnFocusManager();
      RequestElement requestElement = RequestElement();
      if (homeActiveTripModel.value.requests.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      requestElement = homeActiveTripModel.value.requests[0];

      Map<String, String> params = {};
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
        url: "${ApiUrl.getTrip}/${requestElement.request?.id ?? ""}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<void> endBreakDownTrip({Map<String, String>? data}) async {
    try {
      removeUnFocusManager();


      Map<String, String> params = {};
     params['request_id'] = breakdownNewRideModel.value.userReqDetails!.first.id.toString();

      await apiService.postRequest(
        url: "${ApiUrl.endBreakDown}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          // getTrip();
          Get.back();
          showSnack(msg: "Your Ride Successfully End!");
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }



  Future<void> updateTripPaymentConfirm({Map<String, String>? data}) async {
    try {
      removeUnFocusManager();
      RequestElement requestElement = RequestElement();
      if (homeActiveTripModel.value.requests.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      requestElement = homeActiveTripModel.value.requests[0];
      Get.snackbar("Alert", "Payment Successfully Received",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      Map<String, String> params = {};
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
        url: "${ApiUrl.getTrip}/${requestElement.request?.id ?? ""}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          print("payment complete cccc");
          getTrip();

        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<void> updateBreakDownTrip(
      {Map<String, String>? data, Function? updateState}) async {
    try {
      removeUnFocusManager();
      RequestElement requestElement = RequestElement();
      if (homeActiveTripModel.value.requests.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      requestElement = homeActiveTripModel.value.requests[0];

      Map<String, String> params = {};
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
        url: "${ApiUrl.getTrip}/${requestElement.request?.id ?? ""}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          getTrip();
          Future.delayed(
            Duration.zero,
            () async {
              await getEstimatedFare(updateState!);
              print("Ab start hoga");
              // Future.delayed(
              //   Duration(seconds: 4),
              //       () async {
              //   },
              // );
            },
          );
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<void> repeatBreakDownTrip(
      {Map<String, String>? data, Function? updateState}) async {
    try {
      removeUnFocusManager();

      // if (homeActiveTripModel.value.requests.isEmpty) {
      //   showError(msg: "Something went wrong...");
      //   return;
      // }


      Map<String, String> params = {};
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
        url: "${ApiUrl.getTrip}/${breakdownNewRideModel.value.userReqDetails!.first.id ?? ""}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          // getTrip();
          Future.delayed(
            Duration.zero,
            () async {
              await repeatGetEstimatedFare(updateState!);
              print("Ab start hoga");
              // Future.delayed(
              //   Duration(seconds: 4),
              //       () async {
              //   },
              // );
            },
          );
        },
        onError: (ErrorType? errorType, String? msg) {
          // showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<void> rejectTrip() async {
    try {
      RequestElement requestElement = RequestElement();
      if (homeActiveTripModel.value.requests.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      requestElement = homeActiveTripModel.value.requests[0];

      await apiService.deleteRequest(
        url: "${ApiUrl.getTrip}/${requestElement.request?.id ?? ""}",
        onSuccess: (Map<String, dynamic> data) {
          showSnack(msg: data["response"]["message"]);
          _timer?.cancel();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }
  Future<void> waitingTime() async {
    if (homeActiveTripModel.value.requests.isEmpty) {
      showError(msg: "Something went wrong...");
      return;
    }
    try {
      showLoader();
      RequestElement requestElement = RequestElement();
      requestElement = homeActiveTripModel.value.requests[0];
      Map<String, String> params = {};
      params["id"] = "${requestElement.requestId ?? ""}";
      params["status"] = "${_timer == null ? 1 : 0}";
      await apiService.postRequest(
        url: "${ApiUrl.waiting}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          print("ssssss====>${data["response"]["waitingStatus"]}");
          if (data["response"]["waitingStatus"] == 1) {
            startWaitingTime();
          } else {
            waitingTimeSec.value = int.tryParse(data["response"]["waitingTime"].toString()) ?? 0;
            cancelWaitingTime();
          }
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  // Future<void> waitingTime() async {
  //   if (homeActiveTripModel.value.requests.isEmpty) {
  //     showError(msg: "Something went wrong...");
  //     return;
  //   }
  //   try {
  //     showLoader();
  //     RequestElement requestElement = RequestElement();
  //     requestElement = homeActiveTripModel.value.requests[0];
  //     Map<String, String> params = {};
  //     params["id"] = "${requestElement.requestId ?? ""}";
  //     params["status"] = "${_timer == null ? 1 : 0}";
  //     await apiService.postRequest(
  //       url: "${ApiUrl.waiting}",
  //       params: params,
  //       onSuccess: (Map<String, dynamic> data) {
  //         dismissLoader();
  //         if (data["response"]["waitingStatus"] == 1) {
  //           startWaitingTime();
  //         } else {
  //           waitingTimeSec.value =
  //               int.tryParse(data["response"]["waitingTime"].toString()) ?? 0;
  //           cancelWaitingTime();
  //         }
  //       },
  //       onError: (ErrorType? errorType, String? msg) {
  //         showError(msg: msg);
  //       },
  //     );
  //   } catch (e) {
  //     print("akfnewv  ==>  $e");
  //   }
  // }

  Future<void> updateMultipleDestination(
      {required Map<String, String> params}) async {
    if (homeActiveTripModel.value.requests.isEmpty) {
      showError(msg: "Something went wrong...");
      return;
    }
    try {
      showLoader();

      await apiService.postRequest(
        url: "${ApiUrl.multiDestination}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          // showError(msg: msg);
        },
      );
    } catch (e) {
      print("akfnewv  ==>  $e");
    }
  }

  Future<String?> providerRate(
      {required String rating, required String comment}) async {
    String? msg;
    try {
      Map<String, dynamic> params = Map();
      removeUnFocusManager();
      if (homeActiveTripModel.value.requests.isEmpty) {
        showError(msg: "Something went wrong...");
        return msg;
      }
      showLoader();
      params["request_id"] =
          homeActiveTripModel.value.requests[0].requestId.toString();
      params["rating"] = rating;
      params["comment"] = comment;

      await apiService.postRequest(
        url: ApiUrl.tripRate(
            requestId:
                homeActiveTripModel.value.requests[0].requestId.toString()),
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          print("providerRate  ==>  ${jsonEncode(data)}");
          msg = data["response"]["message"];
          dismissLoader();

          // clearData();
          providerUiSelectionType.value = ProviderUiSelectionType.none;
          Get.back();
          await FirebaseDatabase.instance
              .ref("${params["request_id"]}")
              .remove();
          // checkRequest();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeftToRespond.value--;
      if (timeLeftToRespond.value <= 0) {
        timer.cancel();
        getTrip();
      }
    });
  }

  void startWaitingTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      waitingTimeSec++;
    });
  }

  void cancelWaitingTime() {
    _timer?.cancel();
    _timer = null;
  }

  void startTripTime() {
    // if (_getTripTimer == null) {
    //   _getTripTimer = Timer.periodic(Duration(seconds: 3), (timer) {
    //     getTrip();
    //   });
    // }
  }

  void cancelTripTime() {
    _getTripTimer?.cancel();
    _getTripTimer = null;
  }

  Future<void> providerDrawPolyLine({
    double? s_lat,
    double? s_lng,
    double? d_lat,
    double? d_lng,
    List<LatLng> latLngList = const [],
  }) async {
    double? maxLat, minLat, minLon, maxLon;
    bool hasPoints = false;
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      googleMapPolyLine.clear();
      googleMarkers.clear();
      List<PolylineWayPoint> polyLineList = [];
      latLngList.forEach((element) {
        PolylineWayPoint polylineWayPoint = PolylineWayPoint(
          location: "${element.latitude},${element.longitude}",
        );
        polyLineList.add(polylineWayPoint);
      });

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(s_lat ?? 0, s_lng ?? 0),
        zoom: 14.4746,
      );
      googleMapInitCameraPosition.value = cameraPosition;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppString.googleMapKey!,
        PointLatLng(s_lat ?? 0, s_lng ?? 0),
        PointLatLng(d_lat ?? 0, d_lng ?? 0),
        wayPoints: polyLineList,
        travelMode: TravelMode.driving,
      );

      List<LatLng> points = <LatLng>[];
      int count = 0;
      for (var element in result.points) {
        points.add(LatLng(element.latitude, element.longitude));
        maxLat = maxLat != null
            ? math.max(element.latitude, maxLat)
            : element.latitude;
        minLat = minLat != null
            ? math.min(element.latitude, minLat)
            : element.latitude;

        // Longitude
        maxLon = maxLon != null
            ? math.max(element.longitude, maxLon)
            : element.longitude;
        minLon = minLon != null
            ? math.min(element.longitude, minLon)
            : element.longitude;

        hasPoints = true;
        count++;
        log("message   ==>  $count   ${element.longitude} ${element.latitude}");
      }

      Uint8List? markerIcon =
          await getBytesFromAsset(AppImage.multiDestIcon, 50);
      List<PatternItem> pattern = [PatternItem.dash(1), PatternItem.gap(0)];
      latLngList.forEach((element) async {
        if (element.latitude != d_lat && element.longitude != d_lng) {
          if (markerIcon != null) {
            Marker _multipleMarker = Marker(
              markerId: _markerId,
              anchor: Offset(0.5, 0.5),
              // rotation: rotation,
              position: element,
              icon: BitmapDescriptor.fromBytes(markerIcon),
            );
            googleMarkers[_markerId] = _multipleMarker;
          }
        }
      });

      Uint8List? startMarkerIcon =
          await getBytesFromAsset(AppImage.srcIcon, 40);
      Uint8List? endMarkerIcon = await getBytesFromAsset(AppImage.desIcon, 40);
      Uint8List? multiMarkerIcon =
          await getBytesFromAsset(AppImage.multiDestIcon, 40);
      if (points.isNotEmpty) {
        if (startMarkerIcon != null) {
          Marker _startCapMarker = Marker(
            markerId: _startPointCap,
            anchor: Offset(0.5, 0.5),
            position: points[0],
            icon: BitmapDescriptor.fromBytes(startMarkerIcon),
          );
          googleMarkers[_startPointCap] = _startCapMarker;
        }

        if (multiMarkerIcon != null) {
          latLngList.forEach((element) {
            if ((element.latitude != (d_lat ?? 0)) &&
                (element.longitude != (d_lng ?? 0))) {
              Marker _startCapMarker = Marker(
                markerId: MarkerId("${element.longitude},${element.latitude}"),
                anchor: Offset(0.5, 0.5),
                position: LatLng(element.latitude, element.longitude),
                icon: BitmapDescriptor.fromBytes(multiMarkerIcon),
              );
              googleMarkers[
                      MarkerId("${element.longitude},${element.latitude}")] =
                  _startCapMarker;
            }
          });
        }

        if (endMarkerIcon != null) {
          Marker _endCapMarker = Marker(
            anchor: Offset(0.5, 0.5),
            markerId: _endPointCap,
            position: points[points.length - 1],
            icon: BitmapDescriptor.fromBytes(endMarkerIcon),
          );
          googleMarkers[_endPointCap] = _endCapMarker;
        }
      }

      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: points,
        width: 3,
        patterns: pattern,
      );
      googleMapPolyLine.add(polyline);
      showMarker(
          latLng: LatLng(userCurrentLocation?.latitude ?? 0,
              userCurrentLocation?.longitude ?? 0),
          oldLatLng: userCurrentLocation ?? LatLng(0, 0));

      if (hasPoints) {
        LatLngBounds builder = new LatLngBounds(
            southwest: LatLng(minLat ?? 0, minLon ?? 0),
            northeast: LatLng(maxLat ?? 0, maxLon ?? 0));
        googleMapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(builder, 80));
      }
      refresh();
      googleMapPolyLine.refresh();
    } catch (e) {
      log("message   ==>     $e");
    }
  }

  Future<void> showMarker(
      {required LatLng latLng, required LatLng oldLatLng}) async {
    // Uint8List? markerIcon = await getBytesFromAsset(AppImage.car2, 60);

    int startTime = DateTime.now().millisecondsSinceEpoch;
    LatLng startLatLng = LatLng(0, 0);
    double startRotation = 0;
    // if (googleMarkers.isNotEmpty) {
    //   startLatLng = googleMarkers[0].position;
    //   startRotation = googleMarkers[0].rotation;
    // }
    // int duration = 100;
    //
    // Timer.periodic(Duration(milliseconds: 16), (timer) {
    //   int elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
    //   double t = (elapsed.toDouble() / duration);
    //
    //   double lng = t * oldLatLng.longitude + (1 - t) * startLatLng.longitude;
    //   double lat = t * oldLatLng.latitude + (1 - t) * startLatLng.latitude;
    //
    //   double rotation = (t * _bearingBetweenLocations(oldLatLng, latLng) +
    //       (1 - t) * startRotation);
    //
    //   googleMarkers.clear();
    //   if (userImageMarker != null) {
    //     googleMarkers.add(
    //       Marker(
    //         markerId: _markerId,
    //         anchor: Offset(0.5, 0.5),
    //         rotation: rotation,
    //         position: LatLng(lat, lng),
    //         icon: BitmapDescriptor.fromBytes(userImageMarker!),
    //       ),
    //     );
    //   }
    //   if (t > 1.0) {
    //     timer.cancel();
    //   }
    // });

    // googleMarkers.clear();
    if (userImageMarker != null) {
      Marker _userMarker = Marker(
          markerId: _markerId,
          // rotation: _bearingBetweenLocations(oldLatLng, latLng),
          position: latLng,
          anchor: Offset(0, 0.7),
          // ripple: true,
          icon: BitmapDescriptor.fromBytes(userImageMarker!));
      googleMarkers[_markerId] = _userMarker;
      // markers[_markerId] = RippleMarker(
      //     markerId: _markerId,
      //     // rotation: _bearingBetweenLocations(oldLatLng, latLng),
      //     position: latLng,
      //     ripple: true,
      //     icon: BitmapDescriptor.fromBytes(markerIcon));
      // googleMapController
      //     ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 15)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
    _getTripTimer?.cancel();
    _getTripTimer = null;
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  double _bearingBetweenLocations(LatLng latLng1, LatLng latLng2) {
    double PI = 3.14159;
    double lat1 = latLng1.latitude * PI / 180;
    double long1 = latLng1.longitude * PI / 180;
    double lat2 = latLng2.latitude * PI / 180;
    double long2 = latLng2.longitude * PI / 180;

    double dLon = (long2 - long1);

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double brng = math.atan2(y, x);

    brng = vectorMath.degrees(brng);
    brng = (brng + 360) % 360;

    return brng;
  }

  Future<void> getTripHistoryData() async {
    try {
      showLoader();
      await apiService.getRequest(
        url: ApiUrl.history,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          tripHistoryModelList.clear();
          tripHistoryModelList
              .addAll(tripHistoryModelFromJson(jsonEncode(data["response"])));
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print("Error ==>$e");
      showError(msg: "$e");
    }
  }

  Future<void> getTripDetails({required int id}) async {
    try {
      showLoader();
      await apiService.getRequest(
        url: "${ApiUrl.details}?request_id=$id",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          tripHistoryDetailModel.value =
              tripHistoryDetailModelFromJson(jsonEncode(data["response"]));

          tripHistoryDetailModel.refresh();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<List<AutocompletePrediction>> getLocationFromAddress({
    required String address,
    bool isFromAddress = true,
  }) async {
    try {
      AutocompleteResponse? addressList =
          await googlePlace.autocomplete.get(address);
      // List<Placemark> placeMarks = [];
      searchAddressList.clear();
      // List<Location> locations = await locationFromAddress(address);
      //
      // for (int i = 0; i < locations.length; i++) {
      //   placeMarks.addAll(await getLocationAddress(
      //       latLng: LatLng(locations[i].latitude, locations[i].longitude),
      //       isFromAddress: false));
      //   log("message  ==>   1 ${placeMarks.length}");
      // }
      //
      // searchAddressList.addAll(placeMarks);
      // log("message  ==>   ${placeMarks.length}");

      if (addressList != null) {
        if (addressList.predictions != null) {
          searchAddressList.addAll(addressList.predictions!);
          searchAddressList.forEach((element) async {
            log("message  ==>   ${element.placeId}    ${element.id}");
            if (searchAddressList.isNotEmpty) {
              // DetailsResponse? result = await googlePlace.details.get(element.placeId!,
              //     fields: "name,rating,formatted_phone_number,geometry");
              // log("message  ==>   result   ${result?.result?.geometry?.location?.lat}  ${result?.result?.geometry?.location?.lat}");
            }
          });
          return addressList.predictions!;
        }
      } else {
        searchAddressList.clear();
        return [];
      }
    } catch (e) {
      searchAddressList.clear();
      return [];
    }
    searchAddressList.clear();
    return [];
  }

  Future<List<Placemark>> getLocationAddress(
      {required LatLng latLng, bool? isFromAddress = true}) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placeMarks.isNotEmpty) {
      Placemark placeMark = placeMarks[0];
      log("message  ==>  ${placeMark.toJson()}");
      if (isFromAddress == true) {
        tempLocationFromTo.text =
            "${placeMark.street}, ${placeMark.thoroughfare}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
      } else if (isFromAddress == false) {
        latLngWhereTo1 = latLng;
        tempLocationWhereTo1.text =
            "${placeMark.street}, ${placeMark.thoroughfare}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
        // locationWhereTo1.text =tempLocationWhereTo1.text;
      }
    }
    refresh();

    return placeMarks;
  }

  Future<void> getPlaceIdToLatLag({required String placeId}) async {
    DetailsResponse? result = await googlePlace.details
        .get(placeId, fields: "name,rating,formatted_phone_number,geometry");
    LatLng latLng = LatLng(result!.result!.geometry!.location!.lat!,
        result.result!.geometry!.location!.lng!);
    if (locationWhereToFocusNode.hasFocus) {
      latLngWhereTo1 = latLng;
    }
    refresh();
  }

  Future<void> fareWithOutAuth() async {
    try {
      removeUnFocusManager();

      if (tempMobileNumberController.text.isEmpty) {
        showError(msg: "Please enter mobile number");
        return;
      }
      if (tempLocationWhereTo1.text.isEmpty) {
        showError(msg: "Please enter destination address");
        return;
      }
      showLoader();
      await getLocationAddress(
          latLng: userCurrentLocation ?? LatLng(0, 0), isFromAddress: true);
      Map<String, String> params = {};
      params["country_code"] = countryCode.value;
      params["mobile"] = "${tempMobileNumberController.text}";
      params["service_type"] =
          "${_userController.userData.value.service?.serviceTypeId}";
      params["d_longitude"] = "${userCurrentLocation?.longitude}";
      params["d_latitude"] = "${userCurrentLocation?.latitude}";
      params["d_address"] = tempLocationFromTo.text;
      params["s_latitude"] = "${latLngWhereTo1?.latitude}";
      params["s_longitude"] = "${latLngWhereTo1?.longitude}";
      params["s_address"] = "${tempLocationWhereTo1.text}";

      String query = Uri(queryParameters: params).query;
      await apiService.getRequest(
        url: "${ApiUrl.fareWithOutAuth}?$query",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          fareWithOutAuthModel.value =
              fareWithOutAuthModelFromJson(jsonEncode(data["response"]));

          Get.bottomSheet(InstantRideConfirmDialog());
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> requestInstantRide(Function setStateData) async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["fare"] = "${fareWithOutAuthModel.value.estimatedFare ?? ""}";
      params["distance"] = "${fareWithOutAuthModel.value.distance ?? ""}";
      params["minute"] = "${fareWithOutAuthModel.value.minute ?? ""}";
      params["geo_fencing_id"] =
          "${fareWithOutAuthModel.value.geoFencingId ?? ""}";
      params["country_code"] = countryCode.value;
      params["mobile"] = "${tempMobileNumberController.text}";
      params["service_type"] =
          "${_userController.userData.value.service?.serviceTypeId}";
      params["d_longitude"] = "${userCurrentLocation?.longitude}";
      params["d_latitude"] = "${userCurrentLocation?.latitude}";
      params["d_address"] = tempLocationFromTo.text;
      params["s_latitude"] = "${latLngWhereTo1?.latitude}";
      params["s_longitude"] = "${latLngWhereTo1?.longitude}";
      params["s_address"] = "${tempLocationWhereTo1.text}";

      String query = Uri(queryParameters: params).query;
      print("instatnt====>${jsonEncode(params)}");
      await apiService.postRequest(
        url: "${ApiUrl.instantRide}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          Get.back();
          Get.back();
          Get.back();
          instantRideConfirm = true;
          setStateData.call();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> providerAvailableStatusChange() async {
    Map<String, String> params = {};
    if (_userController.userData.value.service?.status == "offline") {

      String? area;
      String? sunLocality;
      String? subAdministrativeArea;
      String? postalCode;
      await placemarkFromCoordinates(userCurrentLocation!.latitude, userCurrentLocation!.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        area = place.street;
        sunLocality  = place.subLocality;
        subAdministrativeArea = place.subAdministrativeArea;
        postalCode = place.postalCode;
        userLiveLocation =
        "$area, $sunLocality,$subAdministrativeArea,$postalCode";
        print("area==> $userLiveLocation");
      });
      params["service_status"] = "active";
      params["userLiveLocation"] = "$area, $sunLocality,$subAdministrativeArea,$postalCode";
      params["device_model"] = deviceModelNumber!;
      params["device_manufacturer"] = deviceManufacture!;
    } else {
      params["service_status"] = "offline";
    }
    await apiService.postRequest(
      url: ApiUrl.available,
      params: params,
      onSuccess: (Map<String, dynamic> data) {
        _userController.userData.value.service?.status =
            data["response"]["service"]["status"];
        _userController.userData.refresh();
      },
      onError: (ErrorType? errorType, String? msg) {
        showError(msg: msg);
      },
    );
    isSwipeCompleted.value = true;
  }

  Future<String?> cancelRequest({Reason? reason, String? cancelId}) async {
    String? msg;
    try {
      Map<String, dynamic> params = Map();
      if (homeActiveTripModel.value.requests.isEmpty && cancelId == null) {
        showError(msg: "Something went wrong...");
        return msg;
      }
      params["request_id"] =
          homeActiveTripModel.value.requests[0].requestId.toString();
      //cancelId ??
      //homeActiveTripModel.value.requests[0].requestId.toString();
      params["cancel_reason"] = reason?.reason ?? "";

      print('param: ' + params.toString());

      showLoader();
      await apiService.postRequest(
        url: ApiUrl.requestCancel,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          print("cancelRequest  ==>  ${jsonEncode(data)}");
          msg = data["response"]["status"];
          dismissLoader();
          // clearData();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> cancelBreakDownRequest(
      {driverRequestId, driverLat, driverLong}) async {
    String? msg;
    print("driverRequestId00==>${driverRequestId}");
    print("driverRequestId00==>${driverLat}");
    print("driverRequestId00==>${driverLong}");
    try {
      Map<String, dynamic> params = Map();
      // if (homeActiveTripModel.value.requests.isEmpty && cancelId == null) {
      //   showError(msg: "Something went wrong...");
      //   return msg;
      // }
      params["request_id"] =
          homeActiveTripModel.value.requests[0].requestId.toString();
      //homeActiveTripModel.value.requests[0].requestId.toString();
      params["cancel_reason"] = "Break Down";
      params["driver_lat"] = driverLat.toString();
      params["driver_long"] = driverLong.toString();

      print('param: ' + params.toString());

      showLoader();
      await apiService.postRequest(
        url: ApiUrl.requestCancel,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          print("cancelRequest  ==>  ${jsonEncode(data)}");
          msg = data["response"]["status"];
          dismissLoader();
          // clearData();
          getTrip();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<void> getReasonList() async {
    try {
      showLoader();
      await apiService.getRequest(
        url: "${ApiUrl.reasons}",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<Reason> tempReasonList = List<Reason>.from(
              data["response"].map((x) => Reason.fromJson(x)));
          reasonList.clear();
          reasonList.addAll(tempReasonList);
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  void instantRideClearData() {
    countryCode.value = "${AppString.defaultCountryCode}";
    latLngWhereTo1 = null;
    tempMobileNumberController.clear();
    tempLocationFromTo.clear();
    tempLocationWhereTo1.clear();
  }

  Future<void> getDisputeList() async {
    try {
       Dio _dio = Dio();
      // showLoader();
      Map<String, dynamic> params = {};
      params["dispute_type"] = "user";
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
        "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      _dio.options.headers.addAll(headers);
      var response = await _dio.post(ApiUrl.disputeList, data: params);
      print("responsedd===>${response.data}");
      if(response.data != null){
        List<DisputeModel> tempDisputeList =
        disputeModelFromJson(jsonEncode(response.data));
        disputeList.clear();
        disputeList.addAll(tempDisputeList);
      }

      // await apiService.postRequest(
      //   url: ApiUrl.disputeList,
      //   params: params,
      //   onSuccess: (Map<String, dynamic> data) async {
      //     dismissLoader();
      //
      //     List<DisputeModel> tempDisputeList =
      //     disputeModelFromJson(jsonEncode(data["response"]));
      //     disputeList.clear();
      //     disputeList.addAll(tempDisputeList);
      //   },
      //   onError: (ErrorType errorType, String? msg) {
      //     showError(msg: msg);
      //   },
      // );
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $phoneNumber");
    }
  }

  Future<String?> sendDispute({required DisputeModel disputeModel}) async {
    String? msg;
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["dispute_type"] = "provider";
      TripHistoryDetailModel tripDataModel = tripHistoryDetailModel.value;

      params["dispute_name"] = disputeModel.disputeName ?? "";
      params["comments"] = "";
      params["user_id"] = "${tripDataModel.userId ?? "0"}";
      params["provider_id"] = "${tripDataModel.providerId ?? "0"}";
      params["request_id"] = "${tripDataModel.id ?? "0"}";
      params["comments"] = "";

      await apiService.postRequest(
          url: ApiUrl.dispute,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            msg = data["response"]["message"];
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      // showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> getEstimatedFare(Function updateState) async {
    String? msg;
    try {
      print("enterthisapi");
      showLoader();
      Map<String, dynamic> params = {};
      params["payment_mode"] = "CASH";
      params["d_latitude"] = breakDownDestinationLat.value.toString();
      params["d_longitude"] = breakDownDestinationLong.value.toString();
      params["d_address"] = breakDownDestinationAddress.value.toString();
      params["s_latitude"] = breakDownSourceLat.value.toString();
      params["s_longitude"] = breakDownSourceLong.value.toString();
      params["s_address"] = breakDownSourceAddress.value.toString();
      params["service_type"] = "1";
      print("estimatedParam===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.estimatedFare,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            print("dataResponse===>${data["response"]}");
            estimatedFareModel.value =
                EstimatedFareModel.fromJson(data["response"]);

            print(
                "estimatedFareModel.value==>${estimatedFareModel.value.estimatedFare}");
            await sendNewUserRequest(updateState);
          },
          onError: (ErrorType errorType, String? msg) {
            // showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      // showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    return msg;
  }
  Future<String?> repeatGetEstimatedFare(Function updateState) async {
    String? msg;
    try {
      print("enterthisapi");
      showLoader();
      Map<String, dynamic> params = {};
      params["payment_mode"] = "CASH";
      params["d_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLatitude.toString();
      params["d_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLongitude.toString();
      params["d_address"] = breakdownNewRideModel.value.userReqDetails!.first.dAddress.toString();
      params["s_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLatitude.toString();
      params["s_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLongitude.toString();
      params["s_address"] = breakdownNewRideModel.value.userReqDetails!.first.sAddress.toString();
      params["service_type"] = "1";
      print("estimatedParam===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.estimatedFare,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            print("dataResponseESTIMATE===>${data["response"]}");
            estimatedFareModel.value =
                EstimatedFareModel.fromJson(data["response"]);

            print(
                "estimatedFareModel.value==>${estimatedFareModel.value.estimatedFare}");
            await sendNewUserRequest(updateState);
          },
          onError: (ErrorType errorType, String? msg) {
            // showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      // showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> sendNewUserRequest(Function updateState) async {
    String? msg;
    try {
      print("enterthisapi");
      showLoader();
      Map<String, dynamic> params = {};
      params["fare"] = estimatedFareModel.value.estimatedFare.toString();
      params["payment_mode"] = "CASH";
      params["distance"] = estimatedFareModel.value.distance.toString();
      params["minute"] = estimatedFareModel.value.minute.toString();
      params["promocode_id"] = "0";
      params["geo_fencing_id"] =
          estimatedFareModel.value.geoFencingId.toString();
      params["service_type"] = estimatedFareModel.value.serviceType.toString();
      params["use_wallet"] = "0";
      params["request_id"] = breakdownNewRideModel.value.userReqDetails!.first.id.toString();
      params["provider_id"] = homeActiveTripModel.value.provider_id;
      params["after_breakdown_ride"] = "1";
      params["d_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLatitude.toString();
      params["d_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLongitude.toString();
      params["d_address"] = breakdownNewRideModel.value.userReqDetails!.first.dAddress.toString();
      params["s_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLatitude.toString();
      params["s_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLongitude.toString();
      params["s_address"] = breakdownNewRideModel.value.userReqDetails!.first.sAddress.toString();
      // params["d_latitude"] = breakDownDestinationLat.value.toString();
      // params["d_longitude"] = breakDownDestinationLong.value.toString();
      // params["d_address"] = breakDownDestinationAddress.value.toString();
      // params["s_latitude"] = breakDownSourceLat.value.toString();
      // params["s_longitude"] = breakDownSourceLong.value.toString();
      // params["s_address"] = breakDownSourceAddress.value.toString();
      params["service_type"] = "1";
      print("newrequesssstcheck===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.sendUSerNewRequest,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            sendNewUserRequestModel.value =
                SendNewUserRequestModel.fromJson(data["response"]);
            print("sendNewUserRequestModel.value===>${data["response"]}");

            String? msg = await providerRate(rating: "5", comment: "");
            showSnack(
                title: "Alert", msg: sendNewUserRequestModel.value.message);
            // isBreakDown = false;
            // updateState.call();
          },
          onError: (ErrorType errorType, String? msg) {
            // showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      // showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    return msg;
  }
  // Future<String?> repeatSendNewUserRequest(Function updateState) async {
  //   String? msg;
  //   try {
  //     print("enterthisapi");
  //     showLoader();
  //     Map<String, dynamic> params = {};
  //     params["fare"] = estimatedFareModel.value.estimatedFare.toString();
  //     params["payment_mode"] = "CASH";
  //     params["distance"] = estimatedFareModel.value.distance.toString();
  //     params["minute"] = estimatedFareModel.value.minute.toString();
  //     params["promocode_id"] = "0";
  //     params["geo_fencing_id"] =
  //         estimatedFareModel.value.geoFencingId.toString();
  //     params["service_type"] = estimatedFareModel.value.serviceType.toString();
  //     params["use_wallet"] = "0";
  //     params["request_id"] = breakdownNewRideModel.value.userReqDetails!.first.id.toString();
  //     params["after_breakdown_ride"] = "1";
  //     params["d_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLatitude.toString();
  //     params["d_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.dLongitude.toString();
  //     params["d_address"] = breakdownNewRideModel.value.userReqDetails!.first.dAddress.toString();
  //     params["s_latitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLatitude.toString();
  //     params["s_longitude"] = breakdownNewRideModel.value.userReqDetails!.first.sLongitude.toString();
  //     params["s_address"] = breakdownNewRideModel.value.userReqDetails!.first.sAddress.toString();
  //     params["service_type"] = "1";
  //     print("newRepetReq===>${jsonEncode(params)}");
  //     await apiService.postRequest(
  //         url: ApiUrl.sendUSerNewRequest,
  //         params: params,
  //         onSuccess: (Map<String, dynamic> data) async {
  //           dismissLoader();
  //           sendNewUserRequestModel.value =
  //               SendNewUserRequestModel.fromJson(data["response"]);
  //           print("sendNewUserRequestModel.value===>${data["response"]}");
  //
  //           String? msg = await providerRate(rating: "5", comment: "");
  //           showSnack(
  //               title: "Alert", msg: sendNewUserRequestModel.value.message);
  //           isBreakDown = false;
  //           updateState.call();
  //         },
  //         onError: (ErrorType errorType, String? msg) {
  //           // showError(msg: msg);
  //         });
  //   } catch (e) {
  //     log("message   ==>  ${e}");
  //     // showError(msg: e.toString());
  //     // showError(msg: e.toString());
  //   }
  //   return msg;
  // }

  Future<String?> breakDownSendNewRide() async {
    // String? msg;
    try {
      // showLoader();
      Map<String, dynamic> params = {};
      params["provider_id"] = homeActiveTripModel.value.provider_id.toString();
      print("newrequest===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.breakdownUSerNewRide,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();

            breakdownNewRideModel.value = BreakDownNewRideModel.fromJson(data["response"]);
            print("breakdown.value===>${data["response"]}");

            // String? msg = await providerRate(rating: "5", comment: "");
            // showSnack(
            //     title: "Alert", msg: sendNewUserRequestModel.value.message);

          },
          onError: (ErrorType errorType, String? msg) {
            // showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    // return msg;
  }

  okayISeenVerifiedDialogue(){
    showLoader();
    GetStorage().write('isVerifiedPopUpShowed', true);
    Timer(Duration(milliseconds: 1500), () {
      dismissLoader();
    });
  }
}
