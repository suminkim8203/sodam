import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/user/view/component/post_item.dart';
import 'package:sodamham/user/view/component/turn_notification_toast.dart';
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
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 2.w,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
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
                      onTap: () {},
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
                      onTap: () {},
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
        backgroundColor: Color(0xffFCFCFC),
        elevation: 0,
      ),
      body: SafeArea(
        child: _MyGroup(),
      ),
      backgroundColor: Color(0xffFCFCFC),
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

  double _dismissProgress = 0.0; // 드래그 진행률 추적

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
      // message: '이민엽님이 일기를 보냈어요! 내 차례예요.',
    ),
  ];

  void _handleToggle(bool value) {
    setState(() {
      isToggled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: isToggled
                  ? _CardScreen(
                      isToggled: isToggled,
                      onToggle: _handleToggle,
                    )
                  : _SlideScreen(
                      isToggled: isToggled,
                      onToggle: _handleToggle,
                    ),
            ),
          ],
        ),
        // 토스트 알림 오버레이
        ..._buildNotificationToasts(),
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

      // 위치 상수
      const topBottom = 32.0; // 1순위 Bottom
      const topLeft = 25.0; // 1순위 Left
      const backBottom = 25.0; // 2순위 Bottom
      const backLeft = 32.0; // 2순위 Left

      if (i == 0) {
        // 1순위 (Top): 드래그 중인 녀석
        // 얘는 Dismissible의 child로서 자체적으로 이동하므로 여기서는 고정 위치 반환
        bottom = topBottom.h;
        left = topLeft.w;
      } else if (i == 1) {
        // 2순위: 1순위가 지워질 때(progress 0->1) 1순위 자리로 이동
        // 1순위 자리(Target): (32.h, 25.w)
        // 2순위 자리(Start): (25.h, 32.w)

        // 보간 (Interpolation)
        bottom = (backBottom + (topBottom - backBottom) * _dismissProgress).h;
        left = (backLeft + (topLeft - backLeft) * _dismissProgress).w;
      } else {
        // 3순위: 1순위가 지워질 때 투명도 0 -> 1 (위치는 2순위 자리 그대로)
        bottom = backBottom.h;
        left = backLeft.w;
        opacity = _dismissProgress; // 진행률에 따라 서서히 등장
      }

      // 데이터가 1개만 남았을 때 처리
      if (_turnNotificationSamples.length == 1 && i == 0) {
        bottom = 25.h;
        left = 25.w;
      }
      // 만약 전체 개수가 2개일 때, 2순위 아이템(i=1)의 목표 위치 수정
      // (1순위가 지워지면 얘는 '1개 남은 상태'의 1순위가 됨 -> (25, 25))
      if (i == 1 && _turnNotificationSamples.length == 2) {
        double targetBottom = 25.0;
        double targetLeft = 25.0;

        bottom =
            (backBottom + (targetBottom - backBottom) * _dismissProgress).h;
        left = (backLeft + (targetLeft - backLeft) * _dismissProgress).w;
      }

      widgets.add(
        Positioned(
          bottom: bottom,
          left: left,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100), // Opacity는 짧게
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

class _MyGroupToolbar extends StatelessWidget {
  const _MyGroupToolbar({
    super.key,
    required this.isToggled,
    required this.onToggle,
  });

  final bool isToggled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HighlighterText(
          text: '나의 기록',
          fontSize: 18, // slightly larger for title
        ),
        Row(
          children: [
            Text(
              isToggled ? '카드형' : '슬라이드형',
              style: TextStyle(
                color: primaryFontColor,
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
              switchBorder: Border.all(
                color: primaryFontColor,
                width: 2.5.sp,
              ),
              duration: const Duration(milliseconds: 210),
              value: isToggled,
              onToggle: onToggle,
            ),
          ],
        ),
      ],
    );
  }
}

// 슬라이드형 전체 (Stack + ListView)
class _SlideScreen extends StatefulWidget {
  const _SlideScreen({
    super.key,
    required this.isToggled,
    required this.onToggle,
  });

  final bool isToggled;
  final ValueChanged<bool> onToggle;

  @override
  State<_SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<_SlideScreen> {
  late final ScrollController _scrollController;
  bool _showScrollToTop = false;

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
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xffFCFCFC),
              scrolledUnderElevation: 0,
              pinned: true, // Toolbar 고정을 위해 true
              elevation: 0,
              toolbarHeight: 58.h + 5.h, // Toolbar(58) + Gap(5) 가 보이도록 설정
              collapsedHeight: 58.h + 5.h,
              expandedHeight:
                  58.h + 5.h + 85.h + 16.h, // Toolbar+Gap+Header+Gap
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin, // Parallax 방지 (한 몸처럼 고정되어 짤림)
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h), // Safe Area Top Padding
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: SizedBox(
                        height: 40.h,
                        child: _MyGroupToolbar(
                          isToggled: widget.isToggled,
                          onToggle: widget.onToggle,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h), // Toolbar + Gap
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: const _SlideHeader(),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            // Header와 List 사이에 RefreshControl 배치
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // 리로드 로직 시뮬레이션
                await Future.delayed(const Duration(seconds: 1));
              },
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 25.h, bottom: 30.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final String imagePath =
                        _groupSamples[index % _groupSamples.length].imageAsset;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: PostItem(
                        imagePath: imagePath,
                      ),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
        // 맨 위로 가기 버튼 (기존 코드 유지)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: _showScrollToTop ? 25.h : -60.h,
          right: 25.w,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showScrollToTop ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: _scrollToTop,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xffFCFCFC),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffD5C7BC),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: const Color(0xff8B7E74),
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 슬라이드형 - 가로 스크롤 헤더
class _SlideHeader extends StatelessWidget {
  const _SlideHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        scrollDirection: Axis.horizontal,
        itemCount: _groupSamples.length, // 실제 데이터 개수 (Safety)
        itemBuilder: (BuildContext context, int index) {
          final group = _groupSamples[index];
          return SizedBox(
            width: 58.w,
            child: Column(
              children: [
                SizedBox(
                  height: 58.h,
                  width: 58.w,
                  child: _GroupImage(imageAsset: group.imageAsset),
                ),
                SizedBox(height: 5.h),
                Text(
                  group.name,
                  style: TextStyle(
                    color: primaryFontColor,
                    fontFamily: 'SeoulHangang',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.sp,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: 20.w,
        ),
      ),
    );
  }
}

// 카드형 전체 (Stack + GridView)
class _CardScreen extends StatefulWidget {
  const _CardScreen({
    super.key,
    required this.isToggled,
    required this.onToggle,
  });

  final bool isToggled;
  final ValueChanged<bool> onToggle;

  @override
  State<_CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<_CardScreen> {
  late final ScrollController _scrollController;
  bool _showScrollToTop = false;

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
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 카드형은 '완전한 한 몸'을 위해 모든 요소를 하나의 SliverToBoxAdapter에 담음
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xffFCFCFC),
                child: Column(
                  children: [
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: SizedBox(
                        height: 40.h,
                        child: _MyGroupToolbar(
                          isToggled: widget.isToggled,
                          onToggle: widget.onToggle,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h), // Toolbar + Gap
                    const _CardHeader(),
                    SizedBox(height: 22.h),
                    Container(
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      color: const Color(0xffEEE9E5),
                    ),
                    const _RecentPostsList(), // 리스트도 여기에 포함
                  ],
                ),
              ),
            ),
          ],
        ),
        // 맨 위로 가기 버튼 (기존 코드 유지)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: _showScrollToTop ? 25.h : -60.h,
          right: 25.w,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showScrollToTop ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: _scrollToTop,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xffFCFCFC),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffD5C7BC),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: const Color(0xff8B7E74),
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 카드형 - 헤더
class _CardHeader extends StatefulWidget {
  const _CardHeader({super.key});

  @override
  State<_CardHeader> createState() => _CardHeaderState();
}

class _CardHeaderState extends State<_CardHeader> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

  int get _bundleCount => max(1, (_groupSamples.length / 6).ceil());

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _animateToPage(int index) {
    if (index < 0 || index >= _bundleCount) {
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int bundleCount = _bundleCount;
    // 카드 영역(260.h) + 간격(16.h) + 페이지네이션(~20.h)
    // 부모(_CardScreenState)에서 headerHeight로 충분한 공간 확보됨
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 260.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: bundleCount,
            onPageChanged: _onPageChanged,
            itemBuilder: (BuildContext context, int index) {
              final int startIndex = index * 6;
              final int endIndex = min(startIndex + 6, _groupSamples.length);
              final List<_GroupInfo> groups =
                  _groupSamples.sublist(startIndex, endIndex);
              return _GroupBundle(groups: groups);
            },
          ),
        ),
        SizedBox(height: 16.h),
        _GroupPagination(
          totalPages: bundleCount,
          currentPage: _currentIndex,
          onDotSelected: _animateToPage,
          onPrevious: () => _animateToPage(_currentIndex - 1),
          onNext: () => _animateToPage(_currentIndex + 1),
        ),
      ],
    );
  }
}

class _GroupBundle extends StatelessWidget {
  const _GroupBundle({required this.groups});

  final List<_GroupInfo> groups;

  static const double _itemWidth = 72;
  static const double _itemHeight = 124; // 72+6+14+2+30(여유)

  static const double _rowSpacing = 12;

  @override
  Widget build(BuildContext context) {
    final List<_GroupInfo?> padded = List<_GroupInfo?>.generate(
      6,
      (index) => index < groups.length ? groups[index] : null,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 42.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _GroupRow(
            items: padded.sublist(0, 3),
            itemWidth: _itemWidth.w,
            itemHeight: _itemHeight.h,
          ),
          SizedBox(height: _rowSpacing.h),
          _GroupRow(
            items: padded.sublist(3, 6),
            itemWidth: _itemWidth.w,
            itemHeight: _itemHeight.h,
          ),
        ],
      ),
    );
  }
}

class _GroupPagination extends StatelessWidget {
  const _GroupPagination({
    required this.totalPages,
    required this.currentPage,
    required this.onDotSelected,
    required this.onPrevious,
    required this.onNext,
  });

  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onDotSelected;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static const int _maxVisibleDots = 3;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final int visibleCount = min(_maxVisibleDots, totalPages);
    final bool showArrows = totalPages > _maxVisibleDots;
    int startIndex = 0;
    if (showArrows) {
      startIndex = (currentPage ~/ _maxVisibleDots) * _maxVisibleDots;
      final int lastPossibleStart = totalPages - visibleCount;
      if (startIndex > lastPossibleStart) {
        startIndex = lastPossibleStart;
      }
    }

    final List<int> visiblePages = List<int>.generate(
      visibleCount,
      (index) => startIndex + index,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showArrows)
          _PaginationArrow(
            icon: Icons.chevron_left,
            enabled: currentPage > 0,
            onTap: currentPage > 0 ? onPrevious : null,
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: visiblePages
              .map(
                (page) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _PaginationDot(
                    isActive: page == currentPage,
                    onTap: () => onDotSelected(page),
                  ),
                ),
              )
              .toList(),
        ),
        if (showArrows)
          _PaginationArrow(
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages - 1,
            onTap: currentPage < totalPages - 1 ? onNext : null,
          ),
      ],
    );
  }
}

class _PaginationDot extends StatelessWidget {
  const _PaginationDot({
    required this.isActive,
    required this.onTap,
  });

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double height = 6.w;
    final double width = isActive ? 12.w : 6.w;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4C4545) : const Color(0xFFB1AEAE),
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }
}

class _PaginationArrow extends StatelessWidget {
  const _PaginationArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Icon(
          icon,
          size: 16.sp,
          color: enabled ? const Color(0xFF4C4545) : const Color(0xFFC9C1BD),
        ),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    required this.items,
    required this.itemWidth,
    required this.itemHeight,
  });

  final List<_GroupInfo?> items;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (int i = 0; i < items.length; i++) {
      children.add(
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: items[i] == null
              ? const SizedBox.shrink()
              : _GroupCard(info: items[i]!),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.info});

  final _GroupInfo info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 72.w,
            height: 72.w,
            child: _GroupImage(imageAsset: info.imageAsset),
          ),
          SizedBox(height: 6.h),
          Text(
            info.name,
            style: TextStyle(
              color: primaryFontColor,
              fontFamily: 'SeoulHangang',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            info.description,
            style: TextStyle(
              color: const Color(0xff7C6C62),
              fontFamily: 'SeoulHangang',
              fontSize: 11.sp,
              height: 1.0,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GroupImage extends StatelessWidget {
  const _GroupImage({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    // Parent container controls the size (80x80)
    final bool isSvg = imageAsset.toLowerCase().endsWith('.svg');
    final Widget image = isSvg
        ? SvgPicture.asset(
            imageAsset,
            fit: BoxFit.cover,
          )
        : Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF6F2EE),
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: const Color(0xffD5C7BC),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: image,
    );
  }
}

class _GroupInfo {
  final String name;
  final String description;
  final String imageAsset;

  const _GroupInfo({
    required this.name,
    required this.description,
    required this.imageAsset,
  });
}

const List<_GroupInfo> _groupSamples = [
  _GroupInfo(
    name: '따뜻한 티타임',
    description: '향기로운 차와 함께 하루를 느긋하게 기록하는 모임',
    imageAsset: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
  ),
  _GroupInfo(
    name: '새벽산책',
    description: '도심 속 공원을 걸으며 떠오르는 마음을 나눠요',
    imageAsset: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
  ),
  _GroupInfo(
    name: '필름로그',
    description: '필름 사진과 짧은 글로 하루를 남기는 기록',
    imageAsset: 'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
  ),
  _GroupInfo(
    name: '북클럽 소담',
    description: '한 주에 한 권, 마음에 남은 문장 공유하기',
    imageAsset: 'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
  ),
  _GroupInfo(
    name: '소금커피 연구소',
    description: '색다른 레시피 실험과 시식평을 남겨요',
    imageAsset: 'asset/image/marek-piwnicki-ktllNfb9cBs-unsplash.jpg',
  ),
  _GroupInfo(
    name: '오각',
    description: '매일매일 오각을 깨우는 즐거움',
    imageAsset: 'asset/image/mario-scheibl-P3vvI9GZogg-unsplash.jpg',
  ),
  _GroupInfo(
    name: '독서',
    description: '한 달에 한 권, 마음의 양식 쌓기',
    imageAsset:
        'asset/image/museum-of-new-zealand-te-papa-tongarewa-hFXKUCTWEMI-unsplash.jpg',
  ),
  _GroupInfo(
    name: '운동',
    description: '건강한 신체를 위한 매일 운동',
    imageAsset: 'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
  ),
  _GroupInfo(
    name: '여행',
    description: '함께 떠나는 즐거운 여행',
    imageAsset: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
  ),
  _GroupInfo(
    name: '코딩',
    description: '알고리즘 스터디 모집합니다',
    imageAsset: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
  ),
];

// 최신글 데이터 모델
class _RecentPostInfo {
  final String groupName;
  final String groupImage;
  final String content;
  final String date;
  final bool isRead;
  final DateTime dateTime;

  const _RecentPostInfo({
    required this.groupName,
    required this.groupImage,
    required this.content,
    required this.date,
    this.isRead = false,
    required this.dateTime,
  });
}

// 최신글 더미 데이터
final List<_RecentPostInfo> _recentPostSamples = [
  // 따뜻한 티타임 (읽지 않음)
  _RecentPostInfo(
    groupName: '따뜻한 티타임',
    groupImage: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    content: '오늘 마신 얼그레이는 정말 향긋했어요. 비 오는 날에 딱 어울리는 차였습니다.',
    date: '10.24',
    isRead: false,
    dateTime: DateTime(2023, 10, 24, 14, 30),
  ),
  _RecentPostInfo(
    groupName: '따뜻한 티타임',
    groupImage: 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    content: '새로 산 찻잔을 자랑하고 싶어요! 파란색 무늬가 들어가서 아주 예쁩니다.',
    date: '10.23',
    isRead: false,
    dateTime: DateTime(2023, 10, 23, 18, 00),
  ),
  // 새벽산책 (읽음 - 최신글 목록에 안 나와야 함)
  _RecentPostInfo(
    groupName: '새벽산책',
    groupImage: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    content: '새벽 공기가 이제 꽤 차갑네요. 다들 감기 조심하세요.',
    date: '10.24',
    isRead: true, // 읽음 처리
    dateTime: DateTime(2023, 10, 24, 06, 00),
  ),
  _RecentPostInfo(
    groupName: '새벽산책',
    groupImage: 'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    content: '오늘 아침 노을이 정말 아름다웠어요. 사진 한 장 공유합니다.',
    date: '10.22',
    isRead: true, // 읽음 처리
    dateTime: DateTime(2023, 10, 22, 06, 30),
  ),
  // 필름로그 (읽지 않음)
  _RecentPostInfo(
    groupName: '필름로그',
    groupImage: 'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
    content: '코닥 골드 200으로 찍은 지난 주말의 풍경입니다.',
    date: '10.22',
    isRead: false,
    dateTime: DateTime(2023, 10, 22, 12, 00),
  ),
  // 북클럽 소담 (읽지 않음)
  _RecentPostInfo(
    groupName: '북클럽 소담',
    groupImage: 'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
    content: '이번 주 지정 도서 \'침묵의 봄\'을 읽고 있습니다. 환경에 대해 다시 생각하게 되네요.',
    date: '10.21',
    isRead: false,
    dateTime: DateTime(2023, 10, 21, 20, 00),
  ),
  _RecentPostInfo(
    groupName: '북클럽 소담',
    groupImage: 'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
    content: '다음 주 모임 장소가 변경되었습니다. 공지 확인 부탁드려요!',
    date: '10.20',
    isRead: false,
    dateTime: DateTime(2023, 10, 20, 10, 00),
  ),
  // 소금커피 연구소 (읽지 않음)
  _RecentPostInfo(
    groupName: '소금커피 연구소',
    groupImage: 'asset/image/marek-piwnicki-ktllNfb9cBs-unsplash.jpg',
    content: '히말라야 핑크솔트를 넣은 라떼, 의외로 고소하고 맛있네요.',
    date: '10.19',
    isRead: false,
    dateTime: DateTime(2023, 10, 19, 13, 00),
  ),
  // 가을 등산 (읽지 않음)
  _RecentPostInfo(
    groupName: '가을 등산',
    groupImage: 'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
    content: '이번 주말 단풍 구경 어디로 갈까요? 설악산이 절정이라고 하네요.',
    date: '10.18',
    isRead: false,
    dateTime: DateTime(2023, 10, 18, 10, 00),
  ),
  // 요리 조리 (읽지 않음)
  _RecentPostInfo(
    groupName: '요리 조리',
    groupImage: 'asset/icon/letter.svg',
    content: '집에서 만드는 파스타 레시피 공유합니다. 아주 쉬워요!',
    date: '10.17',
    isRead: false,
    dateTime: DateTime(2023, 10, 17, 18, 30),
  ),
  // 영화 모임 (읽지 않음)
  _RecentPostInfo(
    groupName: '영화 모임',
    groupImage: 'asset/icon/ic_round-photo.svg',
    content: '이번 달 상영작 추천 받습니다. 장르 상관 없어요.',
    date: '10.16',
    isRead: false,
    dateTime: DateTime(2023, 10, 16, 21, 00),
  ),
];

// 최신글 리스트 섹션
class _RecentPostsList extends StatefulWidget {
  const _RecentPostsList({super.key});

  @override
  State<_RecentPostsList> createState() => _RecentPostsListState();
}

class _RecentPostsListState extends State<_RecentPostsList> {
  bool _isExpanded = false; // 더보기 상태 관리

  @override
  Widget build(BuildContext context) {
    // 1. 읽지 않은 글만 필터링
    final List<_RecentPostInfo> unreadPosts =
        _recentPostSamples.where((post) => !post.isRead).toList();

    // 2. 그룹별로 묶기
    final Map<String, List<_RecentPostInfo>> groupedPosts = {};
    for (var post in unreadPosts) {
      if (!groupedPosts.containsKey(post.groupName)) {
        groupedPosts[post.groupName] = [];
      }
      if (groupedPosts[post.groupName]!.length < 2) {
        groupedPosts[post.groupName]!.add(post);
      }
    }

    // 3. 정렬 (가장 최신 글이 있는 그룹이 먼저 오도록)
    // 그룹별 가장 최신 글의 dateTime 비교
    final List<MapEntry<String, List<_RecentPostInfo>>> sortedGroupEntries =
        groupedPosts.entries.toList()
          ..sort((a, b) {
            final DateTime latestA = a.value.map((e) => e.dateTime).reduce(
                (value, element) => value.isAfter(element) ? value : element);
            final DateTime latestB = b.value.map((e) => e.dateTime).reduce(
                (value, element) => value.isAfter(element) ? value : element);
            return latestB.compareTo(latestA); // 내림차순 정렬
          });

    // 4. 노출할 그룹 결정 (펼쳐지지 않았으면 상위 3개만)
    final int visibleGroupCount = _isExpanded ? sortedGroupEntries.length : 3;
    final List<MapEntry<String, List<_RecentPostInfo>>> visibleGroups =
        sortedGroupEntries.take(visibleGroupCount).toList();
    final bool hasMore = sortedGroupEntries.length > 3;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC),
      ),
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _HighlighterText(
              text: '최신글',
              fontSize: 18,
            ),
          ),
          SizedBox(height: 18.h),
          // 그룹 리스트 렌더링
          ...visibleGroups.asMap().entries.map((entry) {
            final int index = entry.key;
            final MapEntry<String, List<_RecentPostInfo>> data = entry.value;
            // 현재 보여지는 리스트의 마지막 항목이면 구분선을 숨김
            final bool isLastItem = index == visibleGroups.length - 1;

            return _RecentPostGroupItem(
              groupName: data.key,
              posts: data.value,
              isLast: isLastItem,
            );
          }),

          // 더보기 / 접기 버튼
          if (hasMore)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded; // 토글
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h), // 20 -> 10으로 축소
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? '접기' : '더보기',
                      style: TextStyle(
                        color: const Color(0xff999999),
                        fontFamily: 'SeoulHangang',
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xff999999),
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 30.h), // 100 -> 30으로 축소
        ],
      ),
    );
  }
}

class _RecentPostGroupItem extends StatelessWidget {
  const _RecentPostGroupItem({
    required this.groupName,
    required this.posts,
    this.isLast = false,
  });

  final String groupName;
  final List<_RecentPostInfo> posts;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    // 첫 번째 글에서 그룹 이미지 참조
    final String groupImage = posts.first.groupImage;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 29.w), // 요청된 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 헤더
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: _GroupImage(imageAsset: groupImage),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    groupName,
                    style: TextStyle(
                      color: primaryFontColor,
                      fontFamily: 'SeoulHangang',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // 게시글 목록
              ...posts.map((post) => _RecentPostContentItem(post: post)),
            ],
          ),
        ),
        if (!isLast) ...[
          SizedBox(height: 16.h),
          // 그룹 간 구분선
          Container(
            width: 340.w,
            height: 1,
            color: const Color(0xffF0F0F0), // 그룹 간 구분: 연하게
          ),
          SizedBox(height: 16.h),
        ] else
          SizedBox(height: 32.h), // 마지막 아이템 여백
      ],
    );
  }
}

class _RecentPostContentItem extends StatelessWidget {
  const _RecentPostContentItem({required this.post});

  final _RecentPostInfo post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h), // 글 간 간격
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              post.content,
              style: TextStyle(
                color: const Color(0xff555555),
                fontFamily: 'SeoulHangang',
                fontSize: 12.sp,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            post.date,
            style: TextStyle(
              color: const Color(0xff999999),
              fontFamily: 'SeoulHangang',
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlighterText extends StatelessWidget {
  final String text;
  final double fontSize;

  const _HighlighterText({
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: (fontSize * 0.5).h,
            color:
                const Color(0xFFE9D5CC), // Warm highlighter color (Soft Yellow)
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: primaryFontColor,
            fontFamily: 'SeoulHangang',
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w700, // Bold for emphasis
            height: 1.0,
          ),
          strutStyle: StrutStyle(fontSize: fontSize.sp, height: 1.0),
        ),
      ],
    );
  }
}
