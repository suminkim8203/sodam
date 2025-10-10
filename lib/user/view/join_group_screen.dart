import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        children: [
          SubTitle(text: '모임에 참가하기'),
          SizedBox(height: 50.h),
          SignTextField(
            subTitle: 'URL 주소 *',
            hintText: '모임 URL 주소를 입력해주세요.',
          ),
          SizedBox(height: 100.h),
          _Button()
        ],
      ),
    ));
  }
}

class _Button extends StatelessWidget {
  const _Button({super.key});

  void _showCreateGroupModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xffF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(
              color: Color(0xffE9D5CC),
              width: 1,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            width: 260.w,
            height: 140.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목
                Text(
                  '모임에 참여하시겠습니까?',
                  style: TextStyle(
                    fontFamily: 'SeoulHangang',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.h),
                // 버튼들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 취소 버튼
                    Container(
                      width: 64.w, // 52 + 5
                      height: 28.h, // 21 + 5
                      decoration: BoxDecoration(
                        color: Color(0xffEEE9E5),
                        borderRadius: BorderRadius.circular(5.r), // 모서리 5로 변경
                        border: Border.all(
                          color: Color(0xffE9D5CC),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp, // 11 + 2
                            fontFamily: 'SeoulHangang',
                          ),
                        ),
                      ),
                    ),
                    // 확인 버튼
                    Container(
                      width: 64.w, // 52 + 5
                      height: 28.h, // 21 + 5
                      decoration: BoxDecoration(
                        color: Color(0xffE9D5CC),
                        borderRadius: BorderRadius.circular(5.r), // 모서리 5로 변경
                        border: Border.all(
                          color: Color(0xffE9D5CC),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // 여기에 모임 참가 로직 추가
                          _joinGroup(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.black, // 취소 버튼과 같은 색으로 변경
                            fontSize: 13.sp, // 11 + 2
                            fontFamily: 'SeoulHangang',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _joinGroup(BuildContext context) {
    // 실제 모임 만들기 로직을 여기에 구현
    print('모임에 참가하였습니다!');
    // 예: 이전 화면으로 이동하거나 다른 화면으로 네비게이션
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          buttonText: '참가하기',
          onPressed: () => _showCreateGroupModal(context),
        )
      ],
    );
  }
}
