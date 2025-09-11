import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class FindUserAuthPwScreen extends StatelessWidget {
  const FindUserAuthPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController? idFindController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              _Title(),
              SizedBox(height: 50.h),
              SignTextField(
                controller: idFindController,
                subTitle: '아이디 *',
                hintText: '비밀번호 찾을 아이디를 입력해주세요.',
                // errorText: isIdError ? '*존재하지 않는 아이디입니다.' : null,
              ),
              SizedBox(height: 100.h),
              PrimaryButton(buttonText: '확인')
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
          '비밀번호 찾기',
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
