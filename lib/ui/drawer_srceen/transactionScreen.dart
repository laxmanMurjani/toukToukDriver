import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/api/api.dart';

import '../../api/api_service.dart';
import '../../controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';

import '../../util/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    requestTempList();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _userController.requestTransferAmountList();
    // });
  }

  TextEditingController transferAmountController = TextEditingController();
  final UserController _userController = Get.find();

  List tempList = [];

  Future<void> requestTempList() async {
    try {
      //showLoader();
      await apiService.getRequest(
          url: ApiUrl.transferList,
          onSuccess: (Map<String, dynamic> data) async {
            print('check succeed');
            setState(() {
              tempList=[];
              tempList.add(data);
            });
            print(tempList);
            //print('list $transactionWalletList');
            //dismissLoader();
          },
          onError: (ErrorType errorType, String? msg) {
            print('check failed');
            print(tempList);
            //dismissLoader();
            Get.snackbar('','Something went wrong',
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
          });
    } catch (e) {
      print("message   ==>  $e");
      //dismissLoader();
      Get.snackbar('','Something went wrong',
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
      print('check failed in catch');
      print(tempList);
      // showError(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
            child: Stack(alignment: Alignment.bottomCenter, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 30.w, right: 20.w),
                height: 97.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 6.r,
                        offset: Offset(0, 3.h)),
                  ],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(38.r),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          AppImage.backArrow,
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                      Text(
                        'Transaction'.tr,
                        //widget.text ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('')
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Enter the amount',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 35,
                      color: Colors.grey[200],
                      child: TextField(
                        controller: cont.transferAmountController,
                        decoration: InputDecoration(
                            hintText: 'Enter the amount',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(9),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                         showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Text('Confirm your request amount'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text('Confirm'),
                                  onPressed: () {
                                    Get.back();
                                    cont.requestTransferAmount().then((value) => requestTempList());
                                    //cont.requestTransferAmountList();

                                    // cont.requestTransferAmountList();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 35,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              tempList.isEmpty?
                  Center(child: Text("data_not_found".tr),) :
              tempList[0]['response']['pendinglist'].isEmpty? Center(child: Text('No requested history'),) :
              Column(children: [
                Padding(padding: EdgeInsets.only(left: 10,right: 10),child:
                Container(height: 35,color: Colors.black,child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Padding(padding: EdgeInsets.only(left: 10),child: Text('Transaction Id',style:
                  TextStyle(color: Colors.white),),),
                  Padding(padding: EdgeInsets.only(right: 20),
                      child: Text('Amount',style: TextStyle(color: Colors.white),)),
                  Padding(padding: EdgeInsets.only(right: 30),child: Text('Status',style: TextStyle(
                      color: Colors.white
                  ),),)
                ],),),),
                Container(height: MediaQuery.of(context).size.height-250,
                  child: ListView.builder(padding: EdgeInsets.zero,
                      itemCount: tempList[0]['response']['pendinglist'].length,
                      itemBuilder: (BuildContext context, int index){
                        return
                          Padding(padding: EdgeInsets.only(left: 10,right: 10),child:
                          Container(height: 35,color: Colors.grey[200],child:
                          Column(mainAxisAlignment: MainAxisAlignment.end,children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Padding(padding: EdgeInsets.only(left: 10),child: Text(
                                  tempList[0]['response']['pendinglist'][index]['alias_id']
                              ),),
                              Padding(padding: EdgeInsets.only(left: 20),child: Text(
                                  tempList[0]['response']['pendinglist'][index]['amount'].toString()
                              )),
                              Row(children: [
                                Padding(padding: EdgeInsets.only(right: 5),child: Text(
                                  tempList[0]['response']['pendinglist'][index]['status']==0?
                                  'pending' : '',style: TextStyle(color: Colors.orange),
                                ),),
                                GestureDetector(onTap: (){
                                  cont.requestTransferAmountCancel(
                                      tempList[0]['response']['pendinglist'][index]['id']
                                  ).then((value) => requestTempList());
                                  //requestTempList();
                                },
                                    child: Icon(Icons.cancel_presentation,color: Colors.red,size: 22,)),
                                SizedBox(width: 15,)
                              ],)
                            ],),
                            SizedBox(height: 5,),
                            Padding(padding: EdgeInsets.only(left: 5,right: 5),child:
                            Container(height: 1,color: Colors.black,),)
                          ],),),);
                      }),
                )
              ],)
            ],
          ),
        ]));
      }),
    );
  }
}
