import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/pw_text_field.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            SubTitle(text: '새롭게 함께하기'),
            SizedBox(height: 50.h),
            SignTextField(
              subTitle: '아이디 *',
              hintText: '사용하실 아이디를 입력해주세요',
              isButton: true,
              buttonText: '중복확인',
            ),
            SizedBox(height: 36.h),
            PwTextField(),
            SizedBox(height: 100.h),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      buttonText: '가입하기',
      onPressed: () {},
    );
  }
}
