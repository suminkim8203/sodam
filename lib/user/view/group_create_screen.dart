import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/component/user_default_layout.dart';
import 'package:sodamham/user/view/component/primary_button.dart';
import 'package:sodamham/user/view/component/sign_text_field.dart';
import 'package:sodamham/user/view/component/sub_title.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GroupCreateScreen extends StatelessWidget {
  const GroupCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDefaultLayout(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        children: [
          SubTitle(text: '새 모임 만들기'),
          SizedBox(height: 50.h),
          _CreateGroup(),
          SizedBox(height: 30.h),
          // _ImgSelect(),
          SizedBox(height: 100.h),
          _Button(),
        ],
      ),
    ));
  }
}

class _CreateGroup extends StatelessWidget {
  const _CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignTextField(
          subTitle: '제목 *',
          hintText: '모임의 이름을 알려주세요.',
        ),
        SizedBox(height: 20.h),
        SignTextField(
          subTitle: '소개',
          hintText: '모임에 대해 간단하게 소개해주세요.',
        )
      ],
    );
  }
}

class _ImgSelect extends StatefulWidget {
  const _ImgSelect({super.key});

  @override
  State<_ImgSelect> createState() => _ImgSelectState();
}

class _ImgSelectState extends State<_ImgSelect> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '표지 이미지',
              style: TextStyle(
                fontFamily: 'SeoulHangang',
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 160.w,
                height: 114.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffD5C7BC)),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                clipBehavior: Clip.hardEdge,
                child: _selectedImage == null
                    ? Center(
                        child: SvgPicture.asset(
                          'asset/icon/ic_round-photo.svg',
                          width: 25.w,
                          height: 25.w,
                        ),
                      )
                    : Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
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
                  '새 모임을 만드시겠습니까?',
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
                          // 여기에 모임 만들기 로직 추가
                          _createGroup(context);
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

  void _createGroup(BuildContext context) {
    // 실제 모임 만들기 로직을 여기에 구현
    print('모임이 생성되었습니다!');
    // 예: 이전 화면으로 이동하거나 다른 화면으로 네비게이션
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          buttonText: '모임 만들기',
          onPressed: () => _showCreateGroupModal(context),
        ),
        SizedBox(height: 10.h),
        PrimaryButton(
          buttonText: '돌아가기',
          backgroundColor: Color(0xffEEE9E5),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
