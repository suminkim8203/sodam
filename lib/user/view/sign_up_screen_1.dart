import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';
import 'package:sodamham/user/view/sign_up_screen_2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            SubTitle(text: '새롭게 함께하기'),
            SizedBox(height: 50.h),
            _EmailVerification(),
            SizedBox(height: 100.h),
            _NextButton(),
          ],
        ),
      ),
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
          onPressed: () {
            showCustomToast(context, '이메일이 전송되었습니다.\n인증번호를 확인해주세요.');
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        SignTextField(
          subTitle: '인증번호 *',
          hintText: '인증번호를 입력해주세요.',
          isButton: true,
          buttonText: '인증번호 확인',
          onPressed: () {
            // 토스트 띄우기 전에 인증번호 검증 로직 넣을것.
            showCustomToast(context, '인증되었습니다.');
          },
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
        PrimaryButton(
          buttonText: '다음',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SignUpScreen2(),
              ),
            );
          },
        ),
      ],
    );
  }
}

void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xffF9F9F9).withOpacity(0.9), // 투명도 추가
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xffEEE9E5), // 테두리 색
              width: 0.5.sp, // 테두리 두께
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xff574238),
            ),
          ),
        ),
      ),
    ),
  );

  // 오버레이에 추가
  overlay.insert(overlayEntry);

  // 2초 후 자동 제거
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
