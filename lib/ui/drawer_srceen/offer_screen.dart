import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "offers".tr),
      body: Column(
        children: [
          SizedBox(height: 20),
          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text(
                      "cpd01".tr,
                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "10%_off_max_discount_is_50".tr,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            Text(
                              "valid_till_:_13,June_2021".tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "use_code".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
