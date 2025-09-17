import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        children: [
          _Title(),
          SizedBox(height: 50.h),
          SignTextField(
            subTitle: 'URL 주소 *',
            hintText: '모임 URL 주소를 입력해주세요.',
          ),
          SizedBox(height: 100.h),
          PrimaryButton(buttonText: '참가하기')
        ],
      ),
    ));
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
          '모임에 참가하기',
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
