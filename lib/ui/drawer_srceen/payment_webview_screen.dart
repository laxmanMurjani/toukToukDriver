import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/base_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/drawer_srceen/wallet_screen.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  String url;

  PaymentWebViewScreen({required this.url});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  final BaseController _baseController = BaseController();
  WebViewController? _webViewController;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _baseController.showLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        text: "payment".tr,
      ),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return WebView(
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            print("request.url====> ${request.url}");
            if (request.url.contains("login")) {
              cont.getUserPaymentProfileData();
              // Get.snackbar('Success', "Success",
              //     backgroundColor: Colors.green.withOpacity(0.8),
              //     colorText: Colors.white);
              // Get.showSnackbar(GetSnackBar(
              //   backgroundColor: Colors.green,
              //   duration: Duration(seconds: 3),snackPosition: SnackPosition.TOP,
              //   message: "Payment Successfully!",
              //   title: "Message",
              // ));
              // Get.back();
              // do not navigate
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (s) {
            _baseController.dismissLoader();
          },
          onPageStarted: (s) {
            print('webUrl ==>  $s');
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _webViewController?.
  }
}
