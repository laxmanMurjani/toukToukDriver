import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final bool positiveButtonShow;
  final bool negativeButtonShow;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title,
    this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.onPostivePressed,
    this.onNegativePressed,this.negativeButtonShow = false,this.positiveButtonShow = false
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),) : null,
      content: Column(mainAxisSize: MainAxisSize.min,
        children: [
          message != null ? Text(message!) : SizedBox(),
          SizedBox(height: 25,),
          Row(
              mainAxisAlignment: negativeButtonShow && positiveButtonShow ?  MainAxisAlignment.spaceBetween : MainAxisAlignment.center
              ,children:[
            negativeButtonShow
                ?  InkWell(
              onTap: () {
                onNegativePressed!.call();
              },
              child:  Container(
                  height: 50,width: 125,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xffE8595B)
                  ),
                  child: Text(

                    negativeBtnText ?? "No",style: TextStyle(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.w400),)

              ),)
                : SizedBox(),
            positiveButtonShow
                ? InkWell(
              onTap: () {

                onPostivePressed!.call();

              },
              child:  Container(
                  height: 50,width: 125,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xff29DE8B)
                  ),
                  child: Text(
                    positiveBtnText ?? "Yes",style: TextStyle(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.w400),)

              ),) : SizedBox(),
          ])
        ],
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),

    );
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mozlit_driver/util/app_constant.dart';
//
// class UpdateAppDialog extends StatelessWidget {
//   const UpdateAppDialog({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         title: Text("Update App",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
//         content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("This app new feature available in play store, please update app",
//                 style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 25,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child:  Container(
//                         height: 50,width: 125,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
//                             color: Color(0xffE8595B)
//                         ),
//                         child: Text(
//
//                           "Cancel",style: TextStyle(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.w400),)
//
//                     ),),InkWell(
//                     onTap: () {
//
//                     },
//                     child:  Container(
//                         height: 50,width: 125,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
//                             color: Color(0xff29DE8B)
//                         ),
//                         child: Text(
//                           "Update",style: TextStyle(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.w400),)
//
//                     ),)
//                 ],)
//             ]));
//   }
// }
