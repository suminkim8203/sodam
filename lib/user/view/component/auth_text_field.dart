import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';

class AuthTextField extends StatelessWidget {
  final bool? enabled;
  final bool obscureText;
  final String? errorText;
  final String? hintText;
  final bool autofocus;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; // null 허용
  final SvgPicture icon;

  const AuthTextField({
    super.key,
    this.enabled = true,
    this.obscureText = false,
    this.errorText,
    this.hintText,
    this.autofocus = false,
    this.controller,
    this.onChanged, // 꼭 필요한 값인가? 우선 required 제거
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      obscureText: obscureText,
      enabled: enabled,
      controller: controller,
      onChanged: onChanged ?? (_) {}, // null 이면 빈 함수 실행
      style: TextStyle(
        fontFamily: 'SeoulHangang',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        // letterSpacing: -0.9.sp,
      ),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.zero,
        isCollapsed: true,
        contentPadding: EdgeInsets.only(top: 4.0.sp),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: Color(0XFFB1AEAE),
          fontFamily: 'SeoulHangang',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          // letterSpacing: -0.9.sp,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD5C7BC)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD5C7BC)),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: icon,
          // SvgPicture.asset(
          //   'asset/icon/person.svg',
          //   width: 18.w,
          //   height: 18.h,
          // ),
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: 23.w, maxHeight: 18.h),
      ),
    );
  }
}
