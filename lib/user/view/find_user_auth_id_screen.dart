import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';

class FindUserAuthIdScreen extends StatelessWidget {
  const FindUserAuthIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            SubTitle(text: '아이디 찾기'),
            SizedBox(height: 50.h),
            SignTextField(
              subTitle: '이메일 *',
              hintText: '가입시 사용한 이메일을 입력해주세요.',
            ),
            SizedBox(height: 100.h),
            PrimaryButton(buttonText: '확인')
          ],
        ),
      ),
    );
  }
}
