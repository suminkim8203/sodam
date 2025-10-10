import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';

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
        // 타이틀을 왼쪽 정렬
        centerTitle: false,

        // 타이틀 부분
        title: Row(
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

        // 오른쪽 아이콘들
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: primaryFontColor),
                onPressed: () {
                  // 추가 버튼 동작
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: primaryFontColor),
                onPressed: () {
                  // 검색 버튼 동작
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: primaryFontColor),
                onPressed: () {
                  // 설정 버튼 동작
                },
              ),
            ],
          ),
        ],

        // AppBar 배경색
        backgroundColor: Color(0xffFCFCFC),

        // AppBar 아래 그림자 제거 (원하면)
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              children: [
                SizedBox(height: 18.h),
                _MyGroup(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xffFCFCFC),
      // backgroundColor: Colors.red,
    );
  }
}

class _MyGroup extends StatelessWidget {
  const _MyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                  '슬라이드형',
                  style: TextStyle(
                    color: Color(0xffB1AEAE),
                    fontFamily: 'SeoulHangang',
                    fontSize: 12.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.toggle_off,
                    size: 22.sp,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 85.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
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
        )
      ],
    );
  }
}
