import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PwTextField extends StatefulWidget {
  const PwTextField({super.key});

  @override
  State<PwTextField> createState() => _PWFieldState();
}

class _PWFieldState extends State<PwTextField> {
  bool _isObscured = true;
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _errorText = null;
      } else if (password.length < 8) {
        _errorText = '비밀번호는 8자 이상이어야 합니다';
      } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
        _errorText = '영문과 숫자를 모두 포함해야 합니다';
      } else {
        _errorText = null;
      }
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
          controller: _controller,
          autofocus: false,
          obscureText: _isObscured, // 상태따라 변경
          onChanged: _validatePassword, // 입력시마다 검증하도록
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.only(top: 4.0.sp, left: 5.0.w),

            // 에러 텍스트
            errorText: _errorText,
            errorStyle: TextStyle(
              color: Color(0XFFDD838F),
              fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),

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

            // 보더 스타일
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD5C7BC)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD5C7BC)),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0XFFDD838F),
                width: 2.0,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0XFFDD838F),
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
