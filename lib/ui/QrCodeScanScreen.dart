import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanScreen extends StatefulWidget {
  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  final HomeController _homeController = Get.find();
  bool _isFetchResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        text: "qr_scan".tr,
      ),
      body: QRView(
        onQRViewCreated: _onQRViewCreated,
        key: _qrKey,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    _qrViewController?.scannedDataStream.listen((scanData) {
      log("scannedDataStream ==>  ${scanData.code}   ${scanData.format.name}");
      if(scanData.code != null){
        var data = jsonDecode(scanData.code!);
        log("scannedDataStream ==>  123 $data");
        String? countryCode = data["country_code"];
        String? phoneNumber = data["phone_number"];
        if(countryCode != null && phoneNumber != null && !_isFetchResult){
          log("scannedDataStream ==>  123 true");
          _isFetchResult = true;
          _homeController.countryCode.value = countryCode;
          _homeController.tempMobileNumberController.text = phoneNumber;
          Get.back();
        }

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _qrViewController?.dispose();
  }
}
