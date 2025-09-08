import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
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
              SignTextField(
                subTitle: '아이디 *',
                hintText: '사용하실 아이디를 입력해주세요',
                isButton: true,
                buttonText: '중복확인',
              ),
              SizedBox(height: 36.h),
              _PWField(),
              SizedBox(height: 100.h),
              _SignUpButton(),
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

class _PWField extends StatefulWidget {
  final TextEditingController? pwController;

  const _PWField({
    super.key,
    this.pwController,
  });

  @override
  State<_PWField> createState() => _PWFieldState();
}

class _PWFieldState extends State<_PWField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호 *',
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
        TextField(
          autofocus: false,
          obscureText: _isObscured, // 상태따라 변경
          controller: widget.pwController,
          onChanged: (_) {},
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.only(top: 4.0.sp, left: 5.0.w),

              // 아이콘
              suffixIcon: GestureDetector(
                onTap: _toggleVisibility,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, bottom: 0),
                  child: SvgPicture.asset(_isObscured
                          ? 'asset/icon/iconoir_eye.svg'
                          : 'asset/icon/iconoir_eye_off.svg' // 보임 상태 아이콘 (새로 찾아야함)
                      ),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                minHeight: 24.h,
              ),

              // 힌트
              hintText: '비밀번호 (8자 이상의 영문, 숫자 조합)',
              hintStyle: TextStyle(
                color: Color(0XFFB1AEAE),
                fontFamily: 'SeoulHangang',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              )),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(buttonText: '가입하기');
    // 추후 onPressed로 가입 로직 작성
  }
}
