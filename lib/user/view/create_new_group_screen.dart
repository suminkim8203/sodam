import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class CreateNewGroupScreen extends StatelessWidget {
  const CreateNewGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [
          _Title(),
          SizedBox(height: 50.h),
          _CreateGroup(),
          SizedBox(height: 30.h),
          _ImgSelect(),
          SizedBox(height: 50.h),
          _Button(),
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
          '새 모임 만들기',
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

class _CreateGroup extends StatelessWidget {
  const _CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignTextField(
          subTitle: '제목 *',
          hintText: '모임의 이름을 알려주세요.',
        ),
        SizedBox(height: 20.h),
        SignTextField(
          subTitle: '소개',
          hintText: '모임에 대해 간단하게 소개해주세요.',
        )
      ],
    );
  }
}

class _ImgSelect extends StatelessWidget {
  const _ImgSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '표지 이미지',
              style: TextStyle(
                fontFamily: 'SeoulHangang',
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: 160.w,
              height: 114.h,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffD5C7BC)),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'asset/icon/ic_round-photo.svg',
                  width: 25.w,
                  height: 25.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(buttonText: '모임 만들기'),
        SizedBox(height: 10.h),
        PrimaryButton(buttonText: '돌아가기', backgroundColor: Color(0xffEEE9E5))
      ],
    );
  }
}
