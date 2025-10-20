import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/post_item.dart';
import 'package:sodamham/user/view/create_new_group_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar의 좌우 패딩을 20.w로 설정
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 제목
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '소담함',
                    style: TextStyle(
                      fontFamily: 'HambakSnow',
                      color: primaryFontColor,
                      fontSize: 24.sp,
                    ),
                  ),
                  Text(
                    ';편안함을 담아 나누다',
                    style: TextStyle(
                      color: Color(0XFFDABAAB),
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.w500,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
              // 아이콘 버튼들
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 2.w,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // 추가 버튼 동작
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateNewGroupScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.add, color: primaryFontColor),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // 검색 버튼 동작
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.search, color: primaryFontColor),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // 설정 버튼 동작
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.settings, color: primaryFontColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // AppBar 배경색
        backgroundColor: Color(0xffFCFCFC),

        // AppBar 아래 그림자 제거 (원하면)
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 18.h),
              _MyGroup(),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xffFCFCFC),
      // backgroundColor: Colors.red,
    );
  }
}

class _MyGroup extends StatefulWidget {
  const _MyGroup({super.key});

  @override
  State<_MyGroup> createState() => _MyGroupState();
}

class _MyGroupState extends State<_MyGroup> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('나의 모임',
                  style: TextStyle(
                    color: primaryFontColor,
                    fontFamily: 'SeoulHangang',
                    fontSize: 15.sp,
                  )),
              Row(
                children: [
                  Text(
                    isToggled ? '카드형' : '슬라이드형',
                    style: TextStyle(
                      color: Color(0xffB1AEAE),
                      fontFamily: 'SeoulHangang',
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  FlutterSwitch(
                      width: 24.w,
                      height: 16.h,
                      toggleSize: 8.0.sp,
                      padding: 1.1.sp,
                      activeColor: primaryFontColor,
                      inactiveColor: Colors.transparent,
                      inactiveToggleColor: primaryFontColor,
                      switchBorder:
                          BoxBorder.all(color: primaryFontColor, width: 2.5.sp),
                      duration: const Duration(milliseconds: 210),
                      value: isToggled,
                      onToggle: (value) {
                        setState(() {
                          isToggled = value;
                        });
                      })
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        isToggled ? CardScreen() : SlideScreen()
      ],
    );
  }
}

// 슬라이드형
class SlideScreen extends StatefulWidget {
  const SlideScreen({super.key});

  @override
  State<SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 85.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  width: 58.w,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 58.h,
                        width: 58.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          border:
                              Border.all(color: Color(0xffD5C7BC), width: 1.sp),
                        ),
                        child: null,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '토피넛 시그니처 라떼',
                        style: TextStyle(
                          color: primaryFontColor,
                          fontFamily: 'SeoulHangang',
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                          height: 0.8.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ));
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              width: 20.w,
            ),
          ),
        ),
        SizedBox(height: 35.h),
        PostItem(),
      ],
    );
  }
}

// 카드형
class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
