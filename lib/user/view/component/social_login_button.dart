import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final SvgPicture icon;

  const SocialLoginButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon, SizedBox(width: 5.w), Text(buttonText)],
      ),
      style: OutlinedButton.styleFrom(
          minimumSize: Size(250.w, 42.h),
          foregroundColor: primaryFontColor,
          backgroundColor: Color(0xffFCFCFC),
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
