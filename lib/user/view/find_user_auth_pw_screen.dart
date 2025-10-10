import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';

class FindUserAuthPwScreen extends StatelessWidget {
  const FindUserAuthPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController? idFindController = TextEditingController();
    return UserDefaultLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            SubTitle(text: '비밀번호 찾기'),
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
    );
  }
}
