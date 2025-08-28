import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
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
              SizedBox(height: 100.h),
              _NextButton(),
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
          isButton: true,
          buttonText: '전송',
        ),
        SizedBox(
          height: 20.h,
        ),
        SignTextField(
          subTitle: '인증번호 *',
          hintText: '인증번호를 입력해주세요.',
          isButton: true,
          buttonText: '인증번호 확인',
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '이메일을 받지 못하셨나요?',
            style: TextStyle(
              color: Color(0xffDD838F),
              fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ),
        SizedBox(height: 0.h),
        PrimaryButton(buttonText: '다음'),
      ],
    );
  }
}
