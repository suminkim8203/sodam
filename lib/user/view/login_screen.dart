import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFBFAF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              _Title(),
              SizedBox(height: 53.h),
              _Login(),
              // _SocialLogin(),
            ],
          ),
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
              color: Color(0xffDABAAB),
              // fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              letterSpacing: -0.9.sp,
              height: 0.2,
            ),
          ),
        )
      ],
    );
  }
}

class _Login extends StatelessWidget {
  const _Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24.h,
          child: TextField(
            style: TextStyle(
              color: Color(0xffB1AEAE),
              // fontFamily: 'SeoulHangang',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5C7BC)),
              ),
              prefixIcon: SvgPicture.asset(
                'asset/icon/person.svg',
              ),
              // isDense: true,
              hintText: '아이디',
              hintStyle: TextStyle(
                  color: Color(0xffB1AEAE),
                  // fontFamily: 'SeoulHangang',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp),
            ),
          ),
        )
      ],
    );
  }
}
