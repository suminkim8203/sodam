import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;

  const PrimaryButton({
    super.key,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        print('시작하기 버튼 클릭');
      },
      child: Text('시작하기'),
      style: OutlinedButton.styleFrom(
          minimumSize: Size(250.w, 42.h),
          foregroundColor: primaryFontColor,
          backgroundColor: Color(0xffE9D5CC),
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
