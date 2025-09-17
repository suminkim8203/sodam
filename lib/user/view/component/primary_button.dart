import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.backgroundColor = const Color(0xffE9D5CC),
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      child: Text(buttonText),
      style: OutlinedButton.styleFrom(
          fixedSize: Size(260.w, 42.h),
          foregroundColor: primaryFontColor,
          backgroundColor: backgroundColor,
          side: BorderSide(color: Color(0xffD5C7BC), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          )),
    );
  }
}
