import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 차례 알림 데이터 모델
class TurnNotification {
  final String groupName;
  final String groupImage;
  final String userName;

  const TurnNotification({
    required this.groupName,
    required this.groupImage,
    required this.userName,
  });
}

class TurnNotificationToast extends StatelessWidget {
  const TurnNotificationToast({
    super.key,
    required this.notification,
  });

  final TurnNotification notification;

  @override
  Widget build(BuildContext context) {
    // 썸네일 사이즈 및 여백 설정
    const double thumbSize = 40.0;

    return Container(
      width: 305.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Opacity 15% (Softer)
            offset: const Offset(0, 4),
            blurRadius: 8, // Blur 8 (Softer)
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 썸네일 (테두리 없음)
          Positioned(
            left: 16.w,
            top: (64.h - thumbSize.w) / 2,
            child: Container(
              width: thumbSize.w,
              height: thumbSize.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: const Color(0xffF6F2EE),
              ),
              clipBehavior: Clip.hardEdge,
              child: notification.groupImage.toLowerCase().endsWith('.svg')
                  ? SvgPicture.asset(
                      notification.groupImage,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      notification.groupImage,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          // 일기장 이름
          Positioned(
            left: 16.w + thumbSize.w + 10.w,
            right: 16.w, // 우측 여백 확보 (Safety)
            top: 13.h,
            child: Text(
              notification.groupName,
              style: TextStyle(
                color: const Color(0xffB1AEAE),
                fontFamily: 'SeoulHangang',
                fontSize: 12.sp,
                height: 1.0,
              ),
              maxLines: 1, // 한 줄 제한 (Safety)
              overflow: TextOverflow.ellipsis, // 넘침 처리 (Safety)
            ),
          ),

          // 알림 내용
          Positioned(
            left: 16.w + thumbSize.w + 10.w,
            right: 16.w, // 우측 여백 확보 (Safety)
            bottom: 15.h,
            child: Text(
              '${notification.userName}님의 일기가 도착했습니다.',
              style: TextStyle(
                color: const Color(0xff574238),
                fontFamily: 'SeoulHangang',
                fontSize: 16.sp,
                height: 1.0,
              ),
              maxLines: 1, // 한 줄 제한 (Safety)
              overflow: TextOverflow.ellipsis, // 넘침 처리 (Safety)
            ),
          ),
        ],
      ),
    );
  }
}
