import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/reset_pw_screen.dart';

class FindUserAuthPwScreen2 extends StatelessWidget {
  const FindUserAuthPwScreen2({super.key});

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
                subTitle: '이메일 *',
                hintText: '사용한 이메일을 입력해주세요.',
                isButton: true,
                buttonText: '전송',
                onPressed: () {
                  showCustomToast(context, '이메일이 전송되었습니다.\n인증번호를 확인해주세요.');
                },
              ),
              SizedBox(height: 20.h),
              SignTextField(
                controller: idFindController,
                subTitle: '인증번호 *',
                hintText: '인증번호를 입력해주세요',
              ),
              SizedBox(height: 100.h),

              // 확인 버튼
              PrimaryButton(
                buttonText: '확인',
                onPressed: () {
                  // 토스트 띄우기
                  showCustomToast(context, '인증되었습니다.');

                  // 2초 뒤에 다음 화면으로 이동
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPwScreen(), // 비밀번호 재설정 화면
                      ),
                    );
                  });
                },
              ),
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
