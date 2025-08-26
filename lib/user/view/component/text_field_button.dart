import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';

class TextFieldButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const TextFieldButton({
    super.key,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      child: Text(buttonText),
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          // minimumSize: Size(60.w, 20.h),
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 축소
          foregroundColor: primaryFontColor,
          backgroundColor: Color(0xffE9D5CC),
          side: BorderSide(color: Color(0xffD5C7BC), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          )),
    );
  }
}
