import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/ui/home_screen.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? text;
  Widget? leading;
  Function? onBackPress;

  CustomAppBar({this.text, this.leading, this.onBackPress});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30.w, right: 20.w),
      height: 110.h,
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
                if (widget.onBackPress != null) {
                  widget.onBackPress!();
                  return;
                }
                Get.back();
              },
              child: Image.asset(
                AppImage.backArrow,
                width: 20.w,
                height: 20.w,
              ),
            ),
            Text(
              widget.text ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            widget.leading ??
                SizedBox(
                  width: 25,
                )
          ],
        ),
      ),
    );
  }
}
