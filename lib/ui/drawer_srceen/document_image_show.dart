import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class DocumentImageShow extends StatefulWidget {

  @override
  State<DocumentImageShow> createState() => _DocumentImageShowState();
}

class _DocumentImageShowState extends State<DocumentImageShow> {
  final url = Get.arguments[0];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Hero(
              tag: 'imageHero',
              child: Image.network(
                url,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15,top: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 35,width: 35,
                  alignment: Alignment.center,
                  margin:const EdgeInsets.only(right: 15,top: 15),
                 decoration: BoxDecoration(
                   color: AppColors.white,
                   shape: BoxShape.circle
                 ),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}