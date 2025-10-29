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

abstract class _SlidingHeaderState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  late final AnimationController _headerAnimation;
  Animation<double>? _headerTween;
  double _headerOffset = 0;
  bool _isSnapping = false;

  double get headerHeight;
  double get snapThreshold => 0.8;
  Duration get snapDuration => const Duration(milliseconds: 220);
  Curve get snapCurve => Curves.easeOut;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _headerAnimation = AnimationController(vsync: this, duration: snapDuration);
    _headerAnimation.addStatusListener(_handleAnimationStatus);
  }

  void _setHeaderOffset(double value) {
    final double clamped = value.clamp(0.0, headerHeight);
    if ((clamped - _headerOffset).abs() > 0.5) {
      setState(() {
        _headerOffset = clamped;
      });
    } else {
      _headerOffset = clamped;
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final bool atTop =
        notification.metrics.pixels <= notification.metrics.minScrollExtent &&
            notification.metrics.atEdge;

    if (notification is ScrollStartNotification) {
      if (_isSnapping) {
        _headerAnimation.stop();
        _isSnapping = false;
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_isSnapping) {
        return false;
      }
      final double delta = notification.scrollDelta ?? 0.0;
      if (delta == 0.0) {
        return false;
      }
      double nextOffset = (_headerOffset + delta).clamp(0.0, headerHeight);
      if (notification.metrics.pixels <=
          notification.metrics.minScrollExtent + 0.5) {
        nextOffset = 0.0;
      }
      _setHeaderOffset(nextOffset);
    } else if (notification is OverscrollNotification) {
      if (_isSnapping) {
        return false;
      }
      final double delta = notification.overscroll;
      if (delta == 0.0) {
        return false;
      }
      double nextOffset = (_headerOffset + delta).clamp(0.0, headerHeight);
      if (notification.metrics.pixels <=
          notification.metrics.minScrollExtent + 0.5) {
        nextOffset = 0.0;
      }
      _setHeaderOffset(nextOffset);
    } else if (notification is ScrollEndNotification) {
      _snapIfNeeded();
    }
    return false;
  }

  void _snapIfNeeded() {
    final double progress = headerProgress;
    final double targetOffset = progress >= snapThreshold ? 0.0 : headerHeight;
    _animateHeaderTo(targetOffset);
  }

  void _animateHeaderTo(double target) {
    final double clampedTarget = target.clamp(0.0, headerHeight);
    if ((_headerOffset - clampedTarget).abs() < 0.5) {
      _setHeaderOffset(clampedTarget);
      return;
    }

    _headerAnimation.stop();
    _headerAnimation.duration = snapDuration;
    _headerTween?.removeListener(_animationListener);
    _headerTween = Tween<double>(
      begin: _headerOffset,
      end: clampedTarget,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimation,
        curve: snapCurve,
      ),
    )..addListener(_animationListener);

    _isSnapping = true;
    _headerAnimation.forward(from: 0.0);
  }

  void _animationListener() {
    final animation = _headerTween;
    if (animation != null) {
      _setHeaderOffset(animation.value);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _headerTween?.removeListener(_animationListener);
      _headerTween = null;
      _isSnapping = false;
    }
  }

  @override
  void dispose() {
    _headerTween?.removeListener(_animationListener);
    _headerAnimation.removeStatusListener(_handleAnimationStatus);
    _headerAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  ScrollController get controller => _controller;
  double get headerOffset => _headerOffset;
  double get headerProgress =>
      (1 - (_headerOffset / headerHeight)).clamp(0.0, 1.0);

  Widget buildScrollBody(BuildContext context, ScrollController controller);
  Widget buildHeaderContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final double progress = headerProgress;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: buildScrollBody(context, controller),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(0, -headerOffset),
              child: _SlidingHeaderContainer(
                height: headerHeight,
                progress: progress,
                child: buildHeaderContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidingHeaderContainer extends StatelessWidget {
  const _SlidingHeaderContainer({
    super.key,
    required this.height,
    required this.progress,
    required this.child,
  });

  final double height;
  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      ignoring: progress <= 0.05,
      child: Container(
        height: height,
        color: const Color(0xffFCFCFC),
        child: child,
      ),
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

class _SlideScreenState extends _SlidingHeaderState<_SlideScreen> {
  @override
  double get headerHeight => 18.h + 40.h + 5.h + 10.h + 85.h;

  @override
  Widget buildScrollBody(BuildContext context, ScrollController controller) {
    return ListView.separated(
      controller: controller,
      padding: EdgeInsets.only(
          top: headerHeight + 25.h, bottom: 30.h), // 첫번째 postitem 상단 여백
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return PostItem();
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 20.h),
      itemCount: 10,
    );
  }

  @override
  Widget buildHeaderContent(BuildContext context) {
    return Column(
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
        const _SlideHeader(),
        SizedBox(height: 10.h),
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

class _CardScreenState extends _SlidingHeaderState<_CardScreen> {
  @override
  double get headerHeight => 18.h + 40.h + 5.h + 85.h + 35.h;

  @override
  Widget buildScrollBody(BuildContext context, ScrollController controller) {
    return GridView.builder(
      controller: controller,
      padding: EdgeInsets.fromLTRB(22.w, headerHeight, 22.w, 22.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.85,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xffD5C7BC),
              width: 1.sp,
            ),
          ),
          child: Center(
            child: Text(
              '카드 $index',
              style: TextStyle(
                color: primaryFontColor,
                fontFamily: 'SeoulHangang',
                fontSize: 12.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildHeaderContent(BuildContext context) {
    return Column(
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
        SizedBox(height: 35.h),
      ],
    );
  }
}

// 카드형 - 헤더
class _CardHeader extends StatelessWidget {
  const _CardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Center(
        child: Text(
          '카드형 헤더',
          style: TextStyle(
            color: primaryFontColor,
            fontFamily: 'SeoulHangang',
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
