import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class CustomButton extends StatefulWidget {
  String text;
  Color textColor;
  EdgeInsetsGeometry? padding;
  Color bgColor;
  Function? onTap;
  double? fontSize;
  FontWeight? fontWeight;
  CustomButton(
      {required this.text,
      this.textColor = Colors.white,
      this.bgColor = AppColors.primaryColor,
      this.onTap,
      this.padding,
      this.fontSize,
      this.fontWeight});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        width: double.infinity,
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGray.withOpacity(0.5),
              blurRadius: 10.r,
              spreadRadius: 2.w,
              offset: Offset(0, 1.h),
            )
          ],
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: widget.fontSize ?? 16.sp,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
              color: widget.textColor),
        ),
      ),
    );
  }
}
