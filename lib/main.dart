import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/diary_detail_screen.dart';
// import 'package:sodamham/user/view/diary_create_screen.dart';
import 'package:sodamham/user/view/group_create_screen.dart';
import 'package:sodamham/user/view/find_user_auth_id_screen.dart';
import 'package:sodamham/user/view/find_user_auth_pw_screen.dart';
import 'package:sodamham/user/view/find_user_auth_pw_screen2.dart';
import 'package:sodamham/user/view/group_screen.dart';
import 'package:sodamham/user/view/home_screen.dart';
import 'package:sodamham/user/view/join_group_screen.dart';
import 'package:sodamham/user/view/login_screen.dart';
import 'package:sodamham/user/view/sign_up_screen_1.dart';
import 'package:sodamham/user/view/sign_up_screen_2.dart';
import 'package:sodamham/user/view/start_group_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting('ko_KR', null);
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
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', 'KR'),
              Locale('en', 'US'),
            ],
            theme: ThemeData(
                fontFamily: 'SeoulHangang',
                textTheme: ThemeData.light().textTheme.apply(
                      bodyColor: primaryFontColor,
                    )),
            // home: LoginScreen(),
            // home: SignUpScreen(),
            // home: SignUpScreen2(),
            // home: FindUserAuthIdScreen(),
            // home: FindUserAuthPwScreen(),
            // home: FindUserAuthPwScreen2(),
            // home: StartGroupScreen(),
            // home: GroupCreateScreen(),
            home: HomeScreen()
            // home: const GroupScreen(),
            // home: DiaryCreateScreen(),
            // home: DiaryDetailScreen(),
            );
      },
    );
  }
}
