import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/user/view/component/text_field_button.dart';

class SignTextField extends StatelessWidget {
  final bool? enabled;
  final bool obscureText;
  final String subTitle;
  final String? errorText;
  final String? hintText;
  final bool autofocus;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; // null 허용

  final bool isButton;
  final String buttonText;
  final VoidCallback? onPressed;

  const SignTextField({
    super.key,
    this.enabled,
    this.obscureText = false,
    required this.subTitle,
    this.errorText,
    this.hintText,
    this.autofocus = false,
    this.controller,
    this.onChanged,
    this.isButton = false,
    this.buttonText = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subTitle,
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
        TextField(
          autofocus: autofocus,
          obscureText: obscureText,
          enabled: enabled,
          controller: controller,
          onChanged: onChanged ?? (_) {}, // null 이면 빈 함수 실행
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.only(top: 4.0.sp, left: 5.0.w),
              hintText: hintText,
              errorText: errorText,

              // 버튼
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 0, bottom: 3.sp),
                child: isButton
                    ? TextFieldButton(
                        buttonText: buttonText,
                        onPressed: onPressed ?? () {},
                      )
                    : null,
              ),
              suffixIconConstraints: BoxConstraints(
                minHeight: 24.h,
              ),

              // 힌트 텍스트
              hintStyle: TextStyle(
                color: Color(0XFFB1AEAE),
                fontFamily: 'SeoulHangang',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                // letterSpacing: -0.9.sp,
              ),

              // 에러 텍스트
              errorStyle: TextStyle(
                color: Color(0XFFDD838F),
                fontFamily: 'SeoulHangang',
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0XFFDD838F),
                  width: 1.5.sp,
                ),
              )),
        ),
      ],
    );
  }
}
