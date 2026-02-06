import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/turn_notification_toast.dart';
import 'package:sodamham/user/view/diary_create_screen.dart';
import 'package:sodamham/user/view/home_screen.dart';
import 'package:sodamham/user/view/diary_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

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
  // bool _blockScrollButton = false; // 삭제
  //  Timer? _interactionTimer; // 쿨다운 타이머
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadData(); // 데이터 로딩 시뮬레이션
  }

  Future<void> _loadData() async {
    // 2초 딜레이 후 로딩 완료 처리
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
            imagePath: result['images'] != null &&
                    (result['images'] as List).isNotEmpty
                ? (result['images'] as List)[0]
                : 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
            date: result['date'] ?? '오늘',
            author: '나',
            content: result['content'] ?? '',
            weather: result['weather'],
            mood: result['mood'],
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
                isLoading: _isLoading, // 로딩 상태 전달
                onWrite: _navigateToCreateDiary, // 콜백 전달
              ),
            ),
          ],
        ),
        // 토스트 알림 오버레이
        ..._buildNotificationToasts(),

        // 맨 위로 가기 버튼
        AnimatedPositioned(
          key: const ValueKey('scrollToTopBtn'), // 리빌드 시 상태 유지 (필수)
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

  final String? weather;
  final String? mood;

  _PostData({
    required this.imagePath,
    required this.date,
    required this.author,
    required this.content,
    this.weather,
    this.mood,
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
  final bool isLoading;
  final VoidCallback onWrite; // 콜백 추가

  const _MonthlyGalleryList({
    required this.posts,
    required this.isLoading,
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
                  itemCount: isLoading ? 9 : posts.length, // 로딩 중이면 9개 스켈레톤
                  itemBuilder: (context, gridIndex) {
                    if (isLoading) {
                      return const _SkeletonGridItem();
                    }
                    final post = posts[gridIndex];
                    return _GalleryGridItem(
                      imagePath: post.imagePath,
                      date: post.date,
                      author: post.author,
                      content: post.content,
                      weather: post.weather,
                      mood: post.mood,
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
  final String? weather;
  final String? mood;

  const _GalleryGridItem({
    required this.imagePath,
    required this.date,
    required this.author,
    required this.content,
    this.weather,
    this.mood,
  });

  @override
  State<_GalleryGridItem> createState() => _GalleryGridItemState();
}

class _GalleryGridItemState extends State<_GalleryGridItem> {
  Timer? _holdTimer;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _cancelTimer();
    _removeOverlay();
    super.dispose();
  }

  void _cancelTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onTapDown(TapDownDetails details) {
    _cancelTimer();
    _holdTimer = Timer(const Duration(milliseconds: 300), () {
      _showOverlay();
    });
  }

  void _onTapUp(TapUpDetails details) {
    if (_holdTimer != null && _holdTimer!.isActive) {
      // Short tap: Cancel timer and navigate
      _cancelTimer();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryDetailScreen(
            imagePath: widget.imagePath,
            content: widget.content,
            date: widget.date,
            author: widget.author,
            weather: widget.weather,
            mood: widget.mood,
          ),
        ),
      );
    } else {
      // Long press: Just close overlay
      _cancelTimer();
      _removeOverlay();
    }
  }

  void _onTapCancel() {
    _cancelTimer();
    _removeOverlay();
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _PreviewOverlay(
        startRect: offset & size,
        imagePath: widget.imagePath,
        date: widget.date,
        author: widget.author,
        content: widget.content,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
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
      ),
    );
  }
}

class _PreviewOverlay extends StatefulWidget {
  final Rect startRect;
  final String imagePath;
  final String date;
  final String author;
  final String content;

  const _PreviewOverlay({
    required this.startRect,
    required this.imagePath,
    required this.date,
    required this.author,
    required this.content,
  });

  @override
  State<_PreviewOverlay> createState() => _PreviewOverlayState();
}

class _PreviewOverlayState extends State<_PreviewOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350)); // Slower

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn, // Smoother
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 팝업 크기 (화면 너비의 85% 정도)
    final screenSize = MediaQuery.of(context).size;
    final popupWidth = screenSize.width * 0.85;
    final popupHeight = popupWidth * 1.15; // 정사각형에 가깝게 조정

    // 중앙 위치 계산
    final centerLeft = (screenSize.width - popupWidth) / 2;
    final centerTop = (screenSize.height - popupHeight) / 2;

    return Stack(
      children: [
        // 뒤에 딤 처리
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _opacityAnimation,
            builder: (context, child) {
              return Container(
                color: Colors.black.withOpacity(0.4 * _opacityAnimation.value),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 시작 위치(grid item)에서 중앙 팝업 위치로 보간
            // 하지만 사용자 요청은 "원래 위치에서 커지듯 팝업"
            // 여기서는 단순 ScaleTransition + 중앙 배치로 구현하되,
            // Transform.translate를 써서 시작점을 맞출 수도 있음.
            // "원래 위치에서 커지듯" -> Hero 느낌.
            // 간단하게: 중앙에서 커지게 하되, 시작 Rect를 고려하지 않고 중앙 팝업으로 우선 구현.
            // (사용자가 '원래 위치에서 커지듯'이라 했으므로 시작 위치 고려가 좋음)

            final currentWidth = _lerp(
                widget.startRect.width, popupWidth, _scaleAnimation.value);
            final currentHeight = _lerp(
                widget.startRect.height, popupHeight, _scaleAnimation.value);

            final currentLeft =
                _lerp(widget.startRect.left, centerLeft, _scaleAnimation.value);
            final currentTop =
                _lerp(widget.startRect.top, centerTop, _scaleAnimation.value);

            return Positioned(
              left: currentLeft,
              top: currentTop,
              width: currentWidth,
              height: currentHeight,
              child: Material(
                color: Colors.transparent,
                elevation: 20,
                borderRadius: BorderRadius.circular(4.r), // 폴라로이드 감성
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xffFCFCFC), // 종이 질감 색상
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Column(
                    children: [
                      // 사진 영역 (위쪽 75%)
                      Expanded(
                        flex: 3, // 3:1 비율
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 사진 위에 날짜 도장 찍기
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    widget.date,
                                    style: TextStyle(
                                      fontFamily: 'SeoulHangang',
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 텍스트 영역 (아래쪽 25%)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 좌측 정렬
                            children: [
                              Expanded(
                                child: Text(
                                  widget.content,
                                  textAlign: TextAlign.left, // 좌측 정렬
                                  style: TextStyle(
                                    fontFamily: 'SeoulHangang',
                                    fontSize: 14.sp,
                                    color: primaryFontColor,
                                    height: 1.4,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'by. ${widget.author}',
                                    style: TextStyle(
                                      fontFamily: 'SeoulHangang',
                                      fontSize: 12.sp,
                                      color: const Color(0xff999999),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class _SkeletonGridItem extends StatelessWidget {
  const _SkeletonGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF9F9F9), width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
