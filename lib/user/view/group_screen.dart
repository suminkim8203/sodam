import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/turn_notification_toast.dart';
import 'package:sodamham/user/view/diary_create_screen.dart';
import 'package:sodamham/user/view/home_screen.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      body: const _GroupContent(),
    );
  }
}

class _GroupContent extends StatefulWidget {
  const _GroupContent();

  @override
  State<_GroupContent> createState() => _GroupContentState();
}

class _GroupContentState extends State<_GroupContent> {
  // 차례 알림 샘플 데이터 (State로 관리)
  final List<TurnNotification> _turnNotificationSamples = [
    TurnNotification(
      groupName: '따뜻한 티타임',
      groupImage: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
      userName: '김수민',
    ),
    TurnNotification(
      groupName: '새벽산책',
      groupImage: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
      userName: '이준호',
    ),
    TurnNotification(
      groupName: '독서모임',
      groupImage: 'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
      userName: '이민엽',
    ),
  ];

  // 갤러리 데이터 상태 관리
  final List<_PostData> _posts = [
    _PostData(
      imagePath: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
      date: '12.02',
      author: '김수민',
      content: '오늘은 눈이 왔다 행복했다. 내일도 눈이 왔으면 좋겠다.',
    ),
    _PostData(
      imagePath: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
      date: '12.01',
      author: '이준호',
      content: '새벽 공기가 참 좋다.',
    ),
    _PostData(
      imagePath: 'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
      date: '11.30',
      author: '이민엽',
      content: '책 읽기 좋은 날씨다.',
    ),
    _PostData(
      imagePath: 'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
      date: '11.29',
      author: '박지민',
      content: '필름 카메라 감성.',
    ),
    _PostData(
      imagePath: 'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
      date: '11.28',
      author: '최현우',
      content: '커피 한 잔의 여유.',
    ),
  ];

  double _dismissProgress = 0.0; // 드래그 진행률 추적

  // 스크롤 관련 상태
  late ScrollController _scrollController;
  bool _showScrollToTop = false;
  bool _hideNotifications = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    // 500px 이상 스크롤 시 버튼 표시
    final show = offset > 500;
    if (_showScrollToTop != show) {
      setState(() {
        _showScrollToTop = show;
        _hideNotifications = show; // 버튼이 보이면 알림 숨김 (겹침 방지)
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> _navigateToCreateDiary() async {
    // 일기 작성 화면으로 이동
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DiaryCreateScreen()),
    );

    // 작성된 글이 있으면 리스트에 추가
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _posts.insert(
          0,
          _PostData(
            imagePath: result['image'] ??
                'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
            date: '오늘', // 실제 날짜 로직은 생략
            author: '나',
            content: result['content'] ?? '',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(), // 당겨지지 않도록 Clamping 처리
          slivers: [
            const _GroupSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, right: 16.w),
                child: const _GroupInfoSection(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 50.h),
              sliver: _MonthlyGalleryList(
                posts: _posts,
                onWrite: _navigateToCreateDiary, // 콜백 전달
              ),
            ),
          ],
        ),
        // 토스트 알림 오버레이
        ..._buildNotificationToasts(),

        // 맨 위로 가기 버튼
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _showScrollToTop ? 30.h : -60.h,
          right: 20.w,
          child: GestureDetector(
            onTap: _scrollToTop,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xffEAEAEA),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: const Color(0xff8B7E74),
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNotificationToasts() {
    if (_turnNotificationSamples.isEmpty) return [];

    // 최대 3개까지 렌더링
    final visibleNotifications = _turnNotificationSamples.take(3).toList();
    final widgets = <Widget>[];

    // 역순으로 쌓기
    for (int i = visibleNotifications.length - 1; i >= 0; i--) {
      final notification = visibleNotifications[i];

      double bottom, left;
      double opacity = 1.0;

      // 위치 상수 (HomeScreen과 동일 위치)
      const topBottom = 32.0; // 1순위 Bottom
      const topLeft = 25.0; // 1순위 Left
      const backBottom = 25.0; // 2순위 Bottom
      const backLeft = 32.0; // 2순위 Left

      if (i == 0) {
        // 1순위 (맨 위)
        bottom = _hideNotifications ? -100.h : 32.h;
        left = 25.w;
      } else if (i == 1) {
        // 2순위
        double targetBottom =
            (backBottom + (topBottom - backBottom) * _dismissProgress).h;
        bottom = _hideNotifications ? -100.h : targetBottom;
        left = (backLeft + (topLeft - backLeft) * _dismissProgress).w;
      } else {
        // 3순위
        bottom = _hideNotifications ? -100.h : backBottom.h;
        left = backLeft.w;
        opacity = _dismissProgress;
      }

      // 데이터가 1개만 남았을 때 처리
      if (_turnNotificationSamples.length == 1 && i == 0) {
        bottom = _hideNotifications ? -100.h : 25.h;
        left = 25.w;
      }

      // 2개일 때 2순위 처리
      if (i == 1 && _turnNotificationSamples.length == 2) {
        double targetBottom = 25.0;
        bottom = _hideNotifications
            ? -100.h
            : (backBottom + (targetBottom - backBottom) * _dismissProgress).h;
      }

      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          bottom: bottom,
          left: left,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: opacity,
            child: Dismissible(
              key: ValueKey(notification.groupName + notification.userName),
              direction: i == 0
                  ? DismissDirection.up
                  : DismissDirection.none, // 위로 스와이프
              onUpdate: (details) {
                if (i == 0) {
                  setState(() {
                    _dismissProgress = details.progress;
                  });
                }
              },
              onDismissed: (direction) {
                setState(() {
                  _turnNotificationSamples.removeAt(0);
                  _dismissProgress = 0.0; // 초기화
                });
              },
              child: TurnNotificationToast(notification: notification),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _PostData {
  final String imagePath;
  final String date;
  final String author;
  final String content;

  _PostData({
    required this.imagePath,
    required this.date,
    required this.author,
    required this.content,
  });
}

class _GroupSliverAppBar extends StatelessWidget {
  const _GroupSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 130.h,
      backgroundColor: const Color(0xffFCFCFC), // 배경색 복구
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: primaryFontColor),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
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
        background: Image.asset(
          'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
          fit: BoxFit.cover,
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
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 그룹명 (하이라이터 효과)
            Stack(
              children: [
                Positioned(
                  bottom: 5.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 18.h,
                    color: const Color(0xffEEE9E5), // 하이라이터 색상
                  ),
                ),
                Text(
                  '집단적 독백',
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
                    fontSize: 14.sp,
                    color: primaryFontColor,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: const BoxDecoration(
                          color: Color(0xffE9D5CC),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 14.sp,
                          color: const Color(0xffF9F9F9),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '초대',
                        style: TextStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 14.sp,
                          color: primaryFontColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Transform.translate(
          offset: Offset(10.w, -3.h), // 강제로 위로 올림 (폰트 패딩 상쇄) 및 좌측 여백
          child: Text(
            '; 아무거나 하는 모임입니다.',
            style: TextStyle(
              fontFamily: 'SeoulHangang',
              fontSize: 11.5.sp,
              color: const Color(0xffB1AEAE), // 설명 텍스트 색상
              height: 1.0, // 라인 높이 축소
            ),
          ),
        ),
        SizedBox(height: 46.h),
      ],
    );
  }
}

class _MonthlyGalleryList extends StatelessWidget {
  final List<_PostData> posts;
  final VoidCallback onWrite; // 콜백 추가

  const _MonthlyGalleryList({
    required this.posts,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context) {
    // 예시를 위해 모든 포스트를 '2024년 12월' 섹션 하나에 넣거나,
    // 데이터가 늘어나면 월별로 그룹핑하는 로직이 필요합니다.
    // 여기서는 간단히 하나의 월 섹션에 모든 데이터를 보여줍니다.
    final months = ['2024년 12월'];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final month = months[index];
          // 각 월별 섹션
          return Container(
            color: const Color(0xffFCFCFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 월 헤더 (Padding 유지)
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.w, right: 12.w, top: 12.h, bottom: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        month,
                        style: TextStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryFontColor,
                        ),
                      ),
                      if (index == 0) // 첫 번째 월에만 편집 아이콘 예시
                        GestureDetector(
                          onTap: onWrite, // 탭 시 글쓰기 화면으로 이동
                          child: Icon(Icons.edit,
                              size: 20.sp, color: primaryFontColor),
                        ),
                    ],
                  ),
                ),

                // 그리드 (Padding 제거: Full Width)
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, gridIndex) {
                    final post = posts[gridIndex];
                    return _GalleryGridItem(
                      imagePath: post.imagePath,
                      date: post.date,
                      author: post.author,
                      content: post.content,
                    );
                  },
                ),
                SizedBox(height: 22.h),
              ],
            ),
          );
        },
        childCount: months.length,
      ),
    );
  }
}

class _GalleryGridItem extends StatefulWidget {
  final String imagePath;
  final String date;
  final String author;
  final String content;

  const _GalleryGridItem({
    required this.imagePath,
    required this.date,
    required this.author,
    required this.content,
  });

  @override
  State<_GalleryGridItem> createState() => _GalleryGridItemState();
}

class _GalleryGridItemState extends State<_GalleryGridItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(
            color: const Color(0xffF9F9F9),
            width: 1.0,
          ),
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isPressed ? 1.0 : 0.0,
          child: Container(
            color: const Color(0xff4C4545).withOpacity(0.7),
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.date}\n${widget.author}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffF9F9F9),
                    fontSize: 10.sp,
                    fontFamily: 'SeoulHangang',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffF9F9F9),
                    fontSize: 11.sp,
                    fontFamily: 'SeoulHangang',
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
