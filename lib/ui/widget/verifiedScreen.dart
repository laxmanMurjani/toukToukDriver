import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mozlit_driver/api/api.dart';
import 'package:mozlit_driver/controller/home_controller.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class VerifiedDialogue extends StatefulWidget {
  const VerifiedDialogue({Key? key}) : super(key: key);

  @override
  State<VerifiedDialogue> createState() => _VerifiedDialogueState();
}

class _VerifiedDialogueState extends State<VerifiedDialogue> {
  HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      GetStorage().write('isVerifiedPopUpShowed', true);
      return Future.value(false);
    },
      child: GetX<UserController>(builder: (userCont) {
        if(userCont.error.value.errorType == ErrorType.internet){
          return NoInternetWidget();
        }
        return Scaffold(backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              Image.asset(AppImage.circleCheck,height: 90,width: 90,),
              SizedBox(height: 15,),
              Text('congratulations'.tr,style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w700),),
              Text('${userCont.userData.value.firstName ?? ""} ${userCont.userData.value.lastName ?? ""}',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Text('you_have_successfully'.tr,style: TextStyle(color:
              Colors.white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('completed'.tr,style: TextStyle(color:
                Colors.white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                Text('${_homeController.homeActiveTripModel.value.driverVerifyCounter}',style: TextStyle(color:
                Colors.white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                Text('trips_with'.tr,style: TextStyle(color:
                Colors.white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ],),
              Text('touk_touk'.tr,style: TextStyle(color:
              Colors.white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(height: 70,width: MediaQuery.of(context).size.width*0.91,decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(18),color: Colors.grey[100]),child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(height: 60,width: 60,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),child:
                Align(alignment: Alignment.center,child: ClipRRect(borderRadius: BorderRadius.circular(20),child:
                userCont.userData.value.avatar == null?
                Image.asset(AppImage.profilePic) :
                  Image.network('${ApiUrl.baseImageUrl}${userCont.userData.value.avatar}',height: 38,width: 38,),
                ),),),
                //SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Text('${userCont.userData.value.firstName ?? ""} ${userCont.userData.value.lastName ?? ""}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(width: 3,),
                      _homeController.homeActiveTripModel.value.userVerifyCheck == null? SizedBox() :
                      _homeController.homeActiveTripModel.value.userVerifyCheck == 'verified'?
                      Image.asset(AppImage.verifiedIcon,width: 18,height: 18,) : SizedBox()
                    ],
                    ),
                    // SizedBox(height: 1,),
                    Text('${userCont.userData.value.service?.serviceType?.name}',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w500),),
                    // SizedBox(height: 1,),
                    Text('${userCont.userData.value.service?.serviceNumber}',style: TextStyle(color: Colors.green,fontSize: 13,fontWeight: FontWeight.w500),)
                  ],),
                //SizedBox(width: 7,),
                Row(children: [
                  Text(userCont.userData.value.rating.toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                  Icon(Icons.star,color: Colors.amber[400],size: 20,),
                  SizedBox(width: 2,),
                  _homeController.homeActiveTripModel.value.driverServiceType['image']==null? SizedBox() :
                  Image.network('${_homeController.homeActiveTripModel.value.driverServiceType['image']}', height: 28,width: 28,),
                  SizedBox(width: MediaQuery.of(context).size.width*0.04,)
                ],)
                // Image.asset(AppImage.account,height: 28,width: 28,)
              ],),),
              SizedBox(height: MediaQuery.of(context).size.height*0.035,),
              Text('you_are_now_a_verified'.tr,style: TextStyle(color:
              Colors.white,fontSize: 14.5,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              Text('All_users_will'.tr,style: TextStyle(color:
              Colors.white,fontSize: 14.5,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('verification_green_tick'.tr,style: TextStyle(color:
                Colors.green,fontSize: 14.5,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                Text('in_front_of_your_name'.tr,style: TextStyle(color:
                Colors.white,fontSize: 14.5,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ],),
              SizedBox(height: MediaQuery.of(context).size.height*0.12,),
              Text('keep_Riding'.tr,style: TextStyle(color:
              Colors.white,fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              SizedBox(height: 15),
              GestureDetector(onTap: (){
                _homeController.okayISeenVerifiedDialogue();
              },
                child: Container(height: 55,width: MediaQuery.of(context).size.width*0.6,decoration:
                BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),child: Align(alignment:
                Alignment.center,child: Text('continue'.tr,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),),),
              ),
            ],),
          ),
        );
      }),
    );
  }
}
