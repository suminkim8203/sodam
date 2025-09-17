import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';

class StartGroupScreen extends StatelessWidget {
  const StartGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            _Title(),
            SizedBox(height: 180.h),
            _StartButton(),
          ],
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
          '소담함',
          style: TextStyle(
            fontFamily: 'HambakSnow',
            fontSize: 38.sp,
          ),
        ),
        SizedBox(height: 0.h),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            '; 편안함을 담아 나누다',
            style: TextStyle(
              color: Color(0XFFDABAAB),
              fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              // letterSpacing: -0.9.sp,
              fontSize: 12.sp,
              height: 0.2,
            ),
          ),
        )
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
            buttonText: '새 그룹 만들기', backgroundColor: Color(0xffEEE9E5)),
        SizedBox(height: 10.h),
        PrimaryButton(
            buttonText: '기존 그룹에 참여하기', backgroundColor: Color(0xffEEE9E5)),
      ],
    );
  }
}
