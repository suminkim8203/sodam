import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              _EmailVerification(),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0XFFFBFAF5),
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

class _EmailVerification extends StatelessWidget {
  const _EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignTextField(
          subTitle: '이메일 *',
          hintText: '이메일 주소를 입력해주세요.',
        )
      ],
    );
  }
}
