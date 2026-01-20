import 'dart:math';

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

  void _handleToggle(bool value) {
    setState(() {
      isToggled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
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
        Text('나의 기록',
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
  @override
  Widget build(BuildContext context) {
    final double headerHeight = 18.h + 40.h + 5.h + 10.h + 85.h;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xffFCFCFC),
          scrolledUnderElevation: 0, // 스크롤 시 색상 변경 방지
          expandedHeight: headerHeight,
          floating: true,
          snap: true,
          pinned: false,
          elevation: 0,
          toolbarHeight: 58.h, // 18.h + 40.h
          titleSpacing: 22.w,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(top: 18.h),
            child: SizedBox(
              height: 40.h,
              child: _MyGroupToolbar(
                isToggled: widget.isToggled,
                onToggle: widget.onToggle,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(
              children: [
                Positioned(
                  top: 58.h + 5.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: const _SlideHeader(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 25.h, bottom: 30.h),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: PostItem(),
                );
              },
              childCount: 10,
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
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 58.w,
            child: Column(
              children: [
                Container(
                  height: 58.h,
                  width: 58.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(
                      color: Color(0xffD5C7BC),
                      width: 1.sp,
                    ),
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
                    height: 0.9,
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
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xffFCFCFC), // 헤더 배경색 변경
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(height: 5.h),
                const _CardHeader(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _RecentPostsList(),
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
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
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
    imageAsset: 'asset/icon/book_mark.svg',
  ),
  _GroupInfo(
    name: '새벽산책',
    description: '도심 속 공원을 걸으며 떠오르는 마음을 나눠요',
    imageAsset: 'asset/icon/person.svg',
  ),
  _GroupInfo(
    name: '필름로그',
    description: '필름 사진과 짧은 글로 하루를 남기는 기록',
    imageAsset: 'asset/icon/ic_round-photo.svg',
  ),
  _GroupInfo(
    name: '북클럽 소담',
    description: '한 주에 한 권, 마음에 남은 문장 공유하기',
    imageAsset: 'asset/icon/letter.svg',
  ),
  _GroupInfo(
    name: '소금커피 연구소',
    description: '색다른 레시피 실험과 시식평을 남겨요',
    imageAsset: 'asset/icon/kakao.svg',
  ),
  _GroupInfo(
    name: '오각',
    description: '매일매일 오각을 깨우는 즐거움',
    imageAsset: 'asset/icon/book_mark.svg',
  ),
  _GroupInfo(
    name: '독서',
    description: '한 달에 한 권, 마음의 양식 쌓기',
    imageAsset: 'asset/icon/person.svg',
  ),
  _GroupInfo(
    name: '운동',
    description: '건강한 신체를 위한 매일 운동',
    imageAsset: 'asset/icon/ic_round-photo.svg',
  ),
  _GroupInfo(
    name: '여행',
    description: '함께 떠나는 즐거운 여행',
    imageAsset: 'asset/icon/letter.svg',
  ),
  _GroupInfo(
    name: '코딩',
    description: '알고리즘 스터디 모집합니다',
    imageAsset: 'asset/icon/kakao.svg',
  ),
];

// 우표 스타일 구분선 제거됨

// 최신글 데이터 모델
class _RecentPostInfo {
  final String groupName;
  final String groupImage;
  final String content;
  final String date;

  const _RecentPostInfo({
    required this.groupName,
    required this.groupImage,
    required this.content,
    required this.date,
  });
}

// 최신글 더미 데이터
const List<_RecentPostInfo> _recentPostSamples = [
  // 따뜻한 티타임 (2개)
  _RecentPostInfo(
    groupName: '따뜻한 티타임',
    groupImage: 'asset/icon/book_mark.svg',
    content: '오늘 마신 얼그레이는 정말 향긋했어요. 비 오는 날에 딱 어울리는 차였습니다.',
    date: '10.24',
  ),
  _RecentPostInfo(
    groupName: '따뜻한 티타임',
    groupImage: 'asset/icon/book_mark.svg',
    content: '새로 산 찻잔을 자랑하고 싶어요! 파란색 무늬가 들어가서 아주 예쁩니다.',
    date: '10.23',
  ),
  // 새벽산책 (2개)
  _RecentPostInfo(
    groupName: '새벽산책',
    groupImage: 'asset/icon/person.svg',
    content: '새벽 공기가 이제 꽤 차갑네요. 다들 감기 조심하세요.',
    date: '10.24',
  ),
  _RecentPostInfo(
    groupName: '새벽산책',
    groupImage: 'asset/icon/person.svg',
    content: '오늘 아침 노을이 정말 아름다웠어요. 사진 한 장 공유합니다.',
    date: '10.22',
  ),
  // 필름로그 (1개)
  _RecentPostInfo(
    groupName: '필름로그',
    groupImage: 'asset/icon/ic_round-photo.svg',
    content: '코닥 골드 200으로 찍은 지난 주말의 풍경입니다.',
    date: '10.22',
  ),
  // 북클럽 소담 (2개)
  _RecentPostInfo(
    groupName: '북클럽 소담',
    groupImage: 'asset/icon/letter.svg',
    content: '이번 주 지정 도서 \'침묵의 봄\'을 읽고 있습니다. 환경에 대해 다시 생각하게 되네요.',
    date: '10.21',
  ),
  _RecentPostInfo(
    groupName: '북클럽 소담',
    groupImage: 'asset/icon/letter.svg',
    content: '다음 주 모임 장소가 변경되었습니다. 공지 확인 부탁드려요!',
    date: '10.20',
  ),
  // 소금커피 연구소 (1개)
  _RecentPostInfo(
    groupName: '소금커피 연구소',
    groupImage: 'asset/icon/kakao.svg',
    content: '히말라야 핑크솔트를 넣은 라떼, 의외로 고소하고 맛있네요.',
    date: '10.19',
  ),
];

// 최신글 리스트 섹션
class _RecentPostsList extends StatelessWidget {
  const _RecentPostsList({super.key});

  @override
  Widget build(BuildContext context) {
    // 그룹핑 로직
    final Map<String, List<_RecentPostInfo>> groupedPosts = {};
    for (var post in _recentPostSamples) {
      if (!groupedPosts.containsKey(post.groupName)) {
        groupedPosts[post.groupName] = [];
      }
      if (groupedPosts[post.groupName]!.length < 2) {
        groupedPosts[post.groupName]!.add(post);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFBFAF5), // 최신글 배경색 변경
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '최신글',
              style: TextStyle(
                color: primaryFontColor,
                fontFamily: 'SeoulHangang',
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          ...groupedPosts.entries.toList().asMap().entries.map((entry) {
            final int index = entry.key;
            final MapEntry<String, List<_RecentPostInfo>> data = entry.value;
            final bool isLast = index == groupedPosts.length - 1;

            return _RecentPostGroupItem(
              groupName: data.key,
              posts: data.value,
              isLast: isLast,
            );
          }),
          SizedBox(height: 100.h), // Bottom padding for scrolling
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
            height: 0.5,
            color: const Color(0xffD5C7BC),
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
