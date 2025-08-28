import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class SignUpScreen2 extends StatelessWidget {
  const SignUpScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              _Title(),
              SizedBox(height: 50.h),
              SignTextField(
                subTitle: '아이디 *',
                hintText: '사용하실 아이디를 입력해주세요',
                isButton: true,
                buttonText: '중복확인',
              ),
              SizedBox(height: 20.h),
              _PWField(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 180.h),
        Text(
          '새롭게 함께하기',
          style: TextStyle(
            color: primaryFontColor,
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
          ),
        ),
      ],
    );
  }
}

class _PWField extends StatelessWidget {
  const _PWField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
