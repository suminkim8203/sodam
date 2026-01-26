import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // 디자인 기준 사이즈 (필요 시 수정)
      builder: (context, child) => const Scaffold(
        backgroundColor: Color(0xffFCFCFC),
        body: _GroupContent(),
      ),
    );
  }
}

class _GroupContent extends StatelessWidget {
  const _GroupContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _GroupSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const _GroupInfoSection(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 50.h),
          sliver: const _MonthlyGalleryList(),
        ),
      ],
    );
  }
}

class _GroupSliverAppBar extends StatelessWidget {
  const _GroupSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220.h,
      backgroundColor: const Color(0xffFCFCFC),
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: primaryFontColor),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: primaryFontColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings, color: primaryFontColor),
          onPressed: () {},
        ),
        SizedBox(width: 10.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg', // 임시 이미지
              fit: BoxFit.cover,
            ),
            // 그라데이션 오버레이 (텍스트 가독성 확보용 - 필요 시 활성화)
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.black.withOpacity(0.1),
            //         Colors.transparent,
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _GroupInfoSection extends StatelessWidget {
  const _GroupInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 그룹명 (하이라이터 효과)
            Stack(
              children: [
                Positioned(
                  bottom: 2.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 8.h,
                    color: const Color(0xffEBE2D9), // 하이라이터 색상
                  ),
                ),
                Text(
                  '집단적독백',
                  style: TextStyle(
                    fontFamily: 'HambakSnow',
                    fontSize: 24.sp,
                    color: primaryFontColor,
                  ),
                ),
              ],
            ),
            // 멤버 수 및 초대 버튼
            Row(
              children: [
                Text(
                  '멤버 6',
                  style: TextStyle(
                    fontFamily: 'SeoulHangang',
                    fontSize: 12.sp,
                    color: const Color(0xff8B7E74),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F2EE),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline,
                          size: 12.sp, color: const Color(0xff8B7E74)),
                      SizedBox(width: 2.w),
                      Text(
                        '초대',
                        style: TextStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 10.sp,
                          color: const Color(0xff8B7E74),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          '; 아무거나 하는 모임입니다.',
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontSize: 12.sp,
            color: const Color(0xff8B7E74), // 설명 텍스트 색상
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}

class _MonthlyGalleryList extends StatelessWidget {
  const _MonthlyGalleryList();

  @override
  Widget build(BuildContext context) {
    final months = ['2024년 12월', '2024년 11월', '2024년 10월'];
    const sampleImages = [
      'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
      'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
      'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final month = months[index % months.length];
          // 각 월별 섹션
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 월 헤더 + 편집 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      month,
                      style: TextStyle(
                        fontFamily: 'HambakSnow',
                        fontSize: 16.sp,
                        color: primaryFontColor,
                      ),
                    ),
                    if (index == 0) // 첫 번째 월에만 편집 아이콘 예시
                      Icon(Icons.edit,
                          size: 16.sp, color: const Color(0xff8B7E74)),
                  ],
                ),
                SizedBox(height: 12.h),
                // 그리드 (3열) - Sliver 내부이므로 ShrinkWrap 사용보다는 계산된 높이 혹은 GridView.builder 사용
                // 여기서는 간단히 GridView를 사용하되 shrinkWrap: true (데이터 적을 때)
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 4.w,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 5, // 더미 데이터 개수
                  itemBuilder: (context, gridIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: AssetImage(
                              sampleImages[gridIndex % sampleImages.length]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 더미 텍스트 오버레이 (첫 번째 아이템 예시)
                      child: gridIndex == 0
                          ? Center(
                              child: Text(
                                '12.02\n작성자: 김수민\n\n오늘은 눈이 왔다\n행복했다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontFamily: 'SeoulHangang',
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          );
        },
        childCount: 3, // 3개월치 더미
      ),
    );
  }
}
