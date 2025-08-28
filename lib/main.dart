import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/login_screen.dart';
import 'package:sodamham/user/view/sign_up_screen_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
              fontFamily: 'SeoulHangang',
              textTheme: ThemeData.light().textTheme.apply(
                    bodyColor: primaryFontColor,
                  )),
          // home: LoginScreen(),
          home: SignUpScreen(),
        );
      },
    );
  }
}
