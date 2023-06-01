import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';

class PassbookScreen extends StatefulWidget {
  @override
  _PassbookScreenState createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "passbook".tr,
      ),
      body: Center(
        child: Text(
          "no_wallet_history".tr,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
