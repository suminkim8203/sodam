import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sodamham/common/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sodamham/user/view/component/post_item.dart';
import 'package:sodamham/user/view/component/turn_notification_toast.dart';
import 'package:sodamham/user/view/group_screen.dart';
import 'package:sodamham/user/view/group_create_screen.dart';

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
                                builder: (_) => GroupCreateScreen()));
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
      groupName: '집단적 독백',
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
      // 토글 시 스크롤 상태 초기화 (토스트 다시 보이기)
      _hideNotifications = false;
    });
  }

  bool _hideNotifications = false;

  void _handleScrollToTopChange(bool isVisible) {
    if (_hideNotifications != isVisible) {
      setState(() {
        _hideNotifications = isVisible;
      });
    }
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
                      onScrollToTopChange: _handleScrollToTopChange,
                    )
                  : _SlideScreen(
                      isToggled: isToggled,
                      onToggle: _handleToggle,
                      onScrollToTopChange: _handleScrollToTopChange,
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
        // 1순위 (맨 위)
        bottom = _hideNotifications ? -100.h : 32.h; // 숨김 처리 로직 추가
        left = 25.w;
      } else if (i == 1) {
        // 2순위
        // 숨김 처리 시 2순위도 같이 내려감
        double targetBottom =
            (backBottom + (topBottom - backBottom) * _dismissProgress).h;
        bottom = _hideNotifications ? -100.h : targetBottom;
        left = (backLeft + (topLeft - backLeft) * _dismissProgress).w;
      } else {
        // 3순위 (숨김 시 같이 이동)
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
        // ... 기존 보간 로직 ...
        bottom = _hideNotifications
            ? -100.h
            : (backBottom + (targetBottom - backBottom) * _dismissProgress).h;
      }

      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500), // 부드러운 이동 (스르륵)
          curve: Curves.fastOutSlowIn, // 오버슈트 없이 부드럽게 감속
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
    this.onScrollToTopChange,
    this.isLoading = false,
  });

  final bool isToggled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<bool>? onScrollToTopChange;
  final bool isLoading;

  @override
  State<_SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<_SlideScreen> {
  late final ScrollController _scrollController;
  bool _showScrollToTop = false;
  bool _isMoreLoading = false; // 추가 로딩 상태
  List<_RecentPostInfo> _items = []; // 무한 스크롤용 데이터 리스트
  late final List<_RecentPostInfo> _allPosts;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // 전체 더미 포스트 로드 후 10개만 먼저 표시
    _allPosts = _getAllRecentPosts();
    _items = _allPosts.take(10).toList();
  }

  Future<void> _loadMoreData() async {
    if (_isMoreLoading || _items.length >= _allPosts.length) return;
    setState(() {
      _isMoreLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        // 더미 데이터 5개 단위 추가
        _items.addAll(_allPosts.skip(_items.length).take(5));
        _isMoreLoading = false;
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
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
      widget.onScrollToTopChange?.call(true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
      widget.onScrollToTopChange?.call(false);
    }

    // 무한 스크롤 감지 (바닥에 닿았을 때)
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !widget.isLoading &&
        !_isMoreLoading) {
      _loadMoreData();
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
            // 최상단에 RefreshControl 배치 (커스텀 Sodam Dots 적용)
            _SodamRefreshControl(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
            ),
            // SliverAppBar 제거 및 SliverToBoxAdapter로 교체 (카드형과 동일 구조)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h), // 상단 여백 (CardScreen과 통일)
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
                  // Padding 제거 (개방형 가로 스크롤)
                  _SlideHeader(isLoading: widget.isLoading),
                  SizedBox(height: 16.h), // Header + Gap
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 25.h, bottom: 30.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // 로딩 중이면 스켈레톤
                    if (widget.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: _SkeletonPostItem(),
                      );
                    }

                    final post = _items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: PostItem(
                        imagePath: post.groupImage,
                        author: post.author,
                        groupName: post.groupName,
                      ),
                    );
                  },
                  childCount:
                      widget.isLoading ? 3 : _items.length, // 로딩시 3개, 아니면 실제 개수
                ),
              ),
            ),
            // 무한 스크롤 로딩 인디케이터 (Sodam Dots)
            if (_isMoreLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: const Center(child: _SodamLoader()),
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
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xffFCFCFC).withOpacity(0.8), // 반투명 흰색 배경
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryFontColor, // 갈색 테두리
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: primaryFontColor, // 갈색 아이콘
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
  final bool isLoading;

  const _SlideHeader({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: ListView.separated(
        padding: EdgeInsets.zero, // 기본 패딩 제거
        scrollDirection: Axis.horizontal,
        itemCount:
            isLoading ? 10 : _groupSamples.length, // 로딩 시 10개, 아니면 실제 데이터
        itemBuilder: (BuildContext context, int index) {
          if (isLoading) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index == 0) SizedBox(width: 26.w),
                const _SkeletonUniqueGroupItem(),
                if (index == 9) SizedBox(width: 26.w), // 10개일 때 마지막 여백
              ],
            );
          }

          final group = _groupSamples[index];
          // 첫 번째 아이템 왼쪽에만 여백(22.w) 추가하여 시작점 맞춤
          // 렌더링 시 Row로 감싸서 처리
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index == 0) SizedBox(width: 26.w),
              GestureDetector(
                onTap: () {
                  final posts = _getDummyPostsByGroupName(group.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupScreen(
                        groupName: group.name,
                        groupDescription: group.description,
                        membersCount: 6,
                        coverImage: group.imageAsset,
                        initialPosts: posts,
                      ),
                    ),
                  );
                },
                child: SizedBox(
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
                          fontSize: 10.sp,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // 마지막 아이템 오른쪽에 여백(26.w) 추가하여 끝점 맞춤
              if (index == _groupSamples.length - 1) SizedBox(width: 26.w),
            ],
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
    this.onScrollToTopChange,
    this.isLoading = false,
  });

  final bool isToggled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<bool>? onScrollToTopChange;
  final bool isLoading;

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
      widget.onScrollToTopChange?.call(true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
      widget.onScrollToTopChange?.call(false);
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
                    _CardHeader(isLoading: widget.isLoading),
                    SizedBox(height: 22.h),
                    Container(
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      color: const Color(0xffEEE9E5),
                    ),
                    _RecentPostsList(
                      scrollController: _scrollController,
                      isLoading: widget.isLoading,
                    ), // 리스트도 여기에 포함
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
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xffFCFCFC).withOpacity(0.7), // 반투명 흰색 배경
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryFontColor, // 갈색 테두리
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: primaryFontColor, // 갈색 아이콘
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
  final bool isLoading;

  const _CardHeader({super.key, this.isLoading = false});

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
    // 로딩 시: 스켈레톤 번들 1개만 보여줌
    if (widget.isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 260.h,
            child: const _SkeletonGroupBundle(),
          ),
          SizedBox(height: 16.h),
          // Pagination Indicator also skeleton or hidden?
          // For simplicity, hide or show 1 dot
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PaginationDot(isActive: true, onTap: () {}),
            ],
          ),
        ],
      );
    }

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

List<PostData> _getDummyPostsByGroupName(String name) {
  final Map<String, List<String>> groupMembers = {
    '집단적 독백': ['김수민', '이준호', '박지민'],
    '새벽산책': ['김수민', '최현우', '정아름'],
    '필름로그': ['김수민', '강동원', '윤보미'],
    '북클럽 소담': ['김수민', '이민엽', '송강'],
    '소금커피 연구소': ['김수민', '공유', '김고은'],
    '오각': ['김수민', '박보검', '김유정'],
    '독서': ['김수민', '이종석', '한효주'],
    '운동': ['김수민', '마동석', '손석구'],
    '여행': ['김수민', '차은우', '문가영'],
    '코딩': ['김수민', '남주혁', '배수지'],
  };

  final members = groupMembers[name];
  if (members == null) return [];

  final assets = [
    'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
    'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
    'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
  ];

  final contents = [
    '행복한 하루였다.',
    '요즘 날씨가 많이 풀렸다.',
    '정신없는 연초.',
    '주말이 기다려진다.',
    '올해도 얼마 안 남았네.',
    '커피 한 잔의 여유.',
    '산책하기 좋은 날씨.',
    '사진첩을 정리하다가.',
    '새로운 시작을 응원하며.',
  ];

  final dates = [
    ['2026.02.15', '2026.01.20', '2025.12.10'],
    ['2026.02.10', '2026.01.15', '2025.12.05'],
    ['2026.02.05', '2026.01.10', '2025.12.01'],
  ];

  final hash = name.hashCode;
  List<PostData> posts = [];

  for (int m = 0; m < members.length; m++) {
    for (int p = 0; p < 3; p++) {
      int idx = (hash + m * 3 + p).abs();
      posts.add(PostData(
        imagePath: assets[idx % assets.length],
        date: dates[(m + p + hash) % 3]
            [p], // Mix up dates so m=0 isn't always the newest
        author: members[m],
        content: contents[idx % contents.length],
        isBookmarked: (idx % 7 == 0),
      ));
    }
  }

  // 최신순으로 정렬해서 반환
  return posts..sort((a, b) => b.date.compareTo(a.date));
}

List<_RecentPostInfo> _getAllRecentPosts() {
  List<_RecentPostInfo> allPosts = [];
  for (var group in _groupSamples) {
    final posts = _getDummyPostsByGroupName(group.name);
    for (var post in posts) {
      // Parse date 'YYYY.MM.DD' to DateTime
      final parts = post.date.split('.');
      DateTime dt = DateTime.now();
      if (parts.length == 3) {
        dt = DateTime(
          int.tryParse(parts[0]) ?? 2026,
          int.tryParse(parts[1]) ?? 1,
          int.tryParse(parts[2]) ?? 1,
        );
      }

      allPosts.add(_RecentPostInfo(
        groupName: group.name,
        groupImage: group.imageAsset,
        content: post.content,
        date:
            '${parts.length == 3 ? parts[1] : '01'}.${parts.length == 3 ? parts[2] : '01'}',
        dateTime: dt,
        isRead:
            false, // For dummy purpose, all are unread to show up in the Recent feed
        author: post.author,
      ));
    }
  }

  // Sort by newest
  allPosts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return allPosts;
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
    return GestureDetector(
      onTap: () {
        final posts = _getDummyPostsByGroupName(info.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupScreen(
              groupName: info.name,
              groupDescription: info.description,
              membersCount: 6,
              coverImage: info.imageAsset,
              initialPosts: posts,
            ),
          ),
        );
      },
      child: SizedBox(
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

// 소담함 커스텀 로딩 인디케이터 (Dancing Dots)
class _SodamLoader extends StatefulWidget {
  const _SodamLoader();

  @override
  State<_SodamLoader> createState() => _SodamLoaderState();
}

class _SodamLoaderState extends State<_SodamLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 12.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return _AnimatedDot(
            controller: _controller,
            index: index,
          );
        }),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _AnimatedDot({
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // 각 점마다 위상차(Delay)를 주어 물결치는 효과 생성
    // 0~1ms 구간에서 index에 따라 타이밍 조절
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Sine wave를 이용한 부드러운 오퍼시티/크기 변화
        // phase shift: index * 0.2
        final double t = (controller.value - (index * 0.2)) % 1.0;
        final double opacity = 0.4 + 0.6 * (0.5 * (1 + sin(2 * pi * t)));
        final double scale = 0.8 + 0.2 * (0.5 * (1 + sin(2 * pi * t)));

        return Transform.scale(
          scale: scale, // 살짝 커졌다 작아짐
          child: Opacity(
            opacity: opacity, // 밝아졌다 어두워짐
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: primaryFontColor, // 소담함 갈색
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

// 커스텀 리프레시 컨트롤 (Pull-to-Refresh)
class _SodamRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _SodamRefreshControl({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent,
      ) {
        // 진행률 계산 (0.0 ~ 1.0)
        final double progress =
            (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);

        // 새로고침 중이거나 준비 완료 상태면 춤추는 애니메이션(_SodamLoader) 표시
        if (refreshState == RefreshIndicatorMode.refresh ||
            refreshState == RefreshIndicatorMode.armed) {
          return const Center(child: _SodamLoader());
        }

        // 당기는 중(Drag)일 때: 점들이 순차적으로 진해지는 UI
        return Center(
          child: SizedBox(
            width: 48.w,
            height: 12.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                // 점 3개가 0~100% 구간에 걸쳐 순차적으로 불투명해짐
                double dotOpacity = 0.0;
                if (progress > (index / 3)) {
                  dotOpacity = ((progress - (index / 3)) * 3).clamp(0.0, 1.0);
                }

                return Opacity(
                  opacity: 0.2 + (dotOpacity * 0.8), // 기본 0.2 -> 1.0
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: primaryFontColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

const List<_GroupInfo> _groupSamples = [
  _GroupInfo(
    name: '집단적 독백',
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
  final String author;

  const _RecentPostInfo({
    required this.groupName,
    required this.groupImage,
    required this.content,
    required this.date,
    this.isRead = false,
    required this.dateTime,
    this.author = '알 수 없음',
  });
}

// 최신글 리스트 섹션
class _RecentPostsList extends StatefulWidget {
  const _RecentPostsList({
    super.key,
    this.scrollController, // 상위 스크롤 컨트롤러 주입
    this.isLoading = false,
  });

  final ScrollController? scrollController;
  final bool isLoading;

  @override
  State<_RecentPostsList> createState() => _RecentPostsListState();
}

class _RecentPostsListState extends State<_RecentPostsList> {
  // 데이터 관리
  List<MapEntry<String, List<_RecentPostInfo>>> _allSortedGroups = [];
  List<MapEntry<String, List<_RecentPostInfo>>> _visibleGroups = [];

  // 페이징 상태
  int _currentPage = 1;
  static const int _itemsPerPage = 3; // 한 번에 보여줄 그룹 수
  static const int _maxPages = 3; // 최대 로드 페이지 (제한적 무한 스크롤)

  bool _isLoading = false;
  bool _isFinished = false; // 모든 데이터를 다 보여줬거나, 최대 페이지 도달 시

  @override
  void initState() {
    super.initState();
    _initData();
    // 스크롤 리스너 등록
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _initData() {
    // 1. 전체 최신글 덤핑 가져오기
    final List<_RecentPostInfo> allRecentPosts = _getAllRecentPosts();

    // 2. 그룹별로 묶기 (각 그룹당 최대 2개까지만 표시)
    final Map<String, List<_RecentPostInfo>> groupedPosts = {};
    for (var post in allRecentPosts) {
      if (!groupedPosts.containsKey(post.groupName)) {
        groupedPosts[post.groupName] = [];
      }
      if (groupedPosts[post.groupName]!.length < 2) {
        groupedPosts[post.groupName]!.add(post);
      }
    }

    // 3. 정렬 (가장 최신 글을 보유한 그룹이 상단으로)
    _allSortedGroups = groupedPosts.entries.toList()
      ..sort((a, b) {
        final DateTime latestA = a.value.map((e) => e.dateTime).reduce(
            (value, element) => value.isAfter(element) ? value : element);
        final DateTime latestB = b.value.map((e) => e.dateTime).reduce(
            (value, element) => value.isAfter(element) ? value : element);
        return latestB.compareTo(latestA);
      });

    // 초기 데이터 로드 (첫 페이지)
    _loadGroups();
  }

  void _loadGroups() {
    if (_isFinished) return;

    final int targetCount = _currentPage * _itemsPerPage;

    // 데이터 갱신
    if (targetCount >= _allSortedGroups.length) {
      // 실제 데이터가 끝남
      _visibleGroups = _allSortedGroups;
      _isFinished = true;
    } else {
      // 페이징 처리
      _visibleGroups = _allSortedGroups.take(targetCount).toList();

      // 최대 페이지 도달 체크
      if (_currentPage >= _maxPages) {
        _isFinished = true;
      }
    }
  }

  void _onScroll() async {
    if (_isLoading || _isFinished || widget.scrollController == null) return;

    // 스크롤이 바닥에 가까워지면 (_bottomThreshold)
    const double bottomThreshold = 200.0;
    if (widget.scrollController!.position.extentAfter < bottomThreshold) {
      setState(() {
        _isLoading = true;
      });

      // 로딩 시뮬레이션 (네트워크 통신 느낌)
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      setState(() {
        _currentPage++;
        _isLoading = false;
        _loadGroups();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

          SizedBox(height: 18.h),

          // 로딩 중이면 스켈레톤 리스트 표시
          if (widget.isLoading)
            Column(
              children: List.generate(
                3,
                (index) => const _SkeletonRecentPostGroupItem(),
              ),
            )
          else
            // 리스트 렌더링
            ..._visibleGroups.asMap().entries.map((entry) {
              final int index = entry.key;
              final MapEntry<String, List<_RecentPostInfo>> data = entry.value;
              // 마지막 아이템이면서 로딩이 끝났을 때만 구분선 숨김 처리 등 (필요 시)
              final bool isLastItem = index == _visibleGroups.length - 1;

              return _RecentPostGroupItem(
                groupName: data.key,
                posts: data.value,
                isLast: isLastItem && _isFinished,
              );
            }),

          // 로딩 중 인디케이터
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: _SodamLoader(),
              ),
            ),

          // 끝 메시지 (The End Footer)
          if (_isFinished && !_isLoading)
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '여기까지가 최근 소식이에요 🌙',
                      style: TextStyle(
                        fontFamily: 'SeoulHangang',
                        color: const Color(0xffD5C7BC),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),

          SizedBox(height: 30.h),
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
            height: (fontSize * 0.8).h,
            color: const Color(0xFFEEE9E5), // Soft light color
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

class _SkeletonPostItem extends StatelessWidget {
  const _SkeletonPostItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding matches PostItem
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          // Header Row (Matches PostItem _Header)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  // Profile Circle
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Name Text
                  Container(
                    width: 40.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5.w),
                  // Group Name Text
                  Container(
                    width: 80.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  // Bookmark Icon Placeholder
                  Container(
                    width: 24.w,
                    height: 24.h,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20.w),
                  // Kebab Icon Placeholder
                  Container(
                    width: 24.w,
                    height: 24.h,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Image Container (Matches PostItem Image)
          Container(
            width: double.infinity,
            height: 330.h,
            decoration: BoxDecoration(
              // Background Shimmer
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(1.0), // Slight radius or sharp
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonUniqueGroupItem extends StatelessWidget {
  const _SkeletonUniqueGroupItem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58.w,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 58.w,
              height: 58.w, // Rounded Square
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.w), // Matches _GroupImage
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 40.w,
              height: 10.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonGroupBundle extends StatelessWidget {
  const _SkeletonGroupBundle({super.key});

  static const double _itemWidth = 72;
  static const double _itemHeight = 124;
  static const double _rowSpacing = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 42.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) => const _SkeletonGroupCard()),
          ),
          SizedBox(height: _rowSpacing.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) => const _SkeletonGroupCard()),
          ),
        ],
      ),
    );
  }
}

class _SkeletonGroupCard extends StatelessWidget {
  const _SkeletonGroupCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.w), // User requested 2
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 50.w,
              height: 14.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonRecentPostGroupItem extends StatelessWidget {
  const _SkeletonRecentPostGroupItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 29.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Header
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20.w * 0.4), // Approx match
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80.w,
                      height: 13.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Post Items (2 items for skeleton)
              const _SkeletonRecentPostContentItem(),
              const _SkeletonRecentPostContentItem(),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Divider
        Container(
          width: 340.w,
          height: 1,
          color: const Color(0xffF0F0F0),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class _SkeletonRecentPostContentItem extends StatelessWidget {
  const _SkeletonRecentPostContentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 12.h,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 30.w,
              height: 11.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
