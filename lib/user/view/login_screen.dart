import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              _Title(),
              SizedBox(height: 53.h),
              _Username(usernameController: usernameController),
              SizedBox(height: 10.h),
              _UserPW(
                passwordController: passwordController,
              ),
              _FindAuthButton(),
              // _SocialLogin(),
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
              letterSpacing: -0.9.sp,
              fontSize: 12.sp,
              height: 0.2,
            ),
          ),
        )
      ],
    );
  }
}

class _Username extends StatelessWidget {
  final TextEditingController? usernameController;

  const _Username({super.key, this.usernameController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      child: AuthTextField(
        onChanged: (_) {},
        icon: SvgPicture.asset(
          'asset/icon/person.svg',
          width: 18.w,
          height: 18.h,
        ),
        controller: usernameController,
        hintText: '아이디',
      ),
    );
  }
}

class _UserPW extends StatelessWidget {
  final TextEditingController? passwordController;

  const _UserPW({super.key, this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      child: AuthTextField(
        onChanged: (_) {},
        icon: SvgPicture.asset(
          'asset/icon/password.svg',
          width: 18.w,
          height: 18.h,
        ),
        controller: passwordController,
        hintText: '비밀번호',
      ),
    );
  }
}

class _FindAuthButton extends StatelessWidget {
  const _FindAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        '아이디 찾기',
        style: TextStyle(
          color: primaryFontColor,
          fontFamily: 'SeoulHangang',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.9.sp,
          fontSize: 12.sp,
          decoration: TextDecoration.underline,
          decorationThickness: 1.5.sp,
        ),
      ),
    );
  }
}
