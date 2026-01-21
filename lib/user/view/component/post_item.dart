import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';

class PostItemList extends StatefulWidget {
  const PostItemList({super.key});

  @override
  State<PostItemList> createState() => _PostItemListState();
}

class _PostItemListState extends State<PostItemList> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(); // map돌려서 item전부 보여주기
  }
}

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 330.h,
          decoration: BoxDecoration(
            color: const Color(0xffF6F2EE), // Fallback color
            border: Border.all(color: const Color(0xffFCFCFC), width: 1.sp),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            // image: DecorationImage(image: NetworkImage('인터넷 사진 경로')),
            color: Color(0xffB1AEAE),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '김누구',
          style: TextStyle(
            color: primaryFontColor,
            fontFamily: 'SeoulHangang',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          '토피넛 시그니처 라떼',
          style: TextStyle(
            color: Color(0xffB1AEAE),
            fontFamily: 'SeoulHangang',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(), // 공백을 전부 채워주는 녀석이래
        Material(
          child: InkWell(
            child: SvgPicture.asset(
              'asset/icon/book_mark.svg',
              color: primaryFontColor,
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Material(
          child: InkWell(
            child: SvgPicture.asset(
              'asset/icon/kebab.svg',
              color: primaryFontColor,
            ),
          ),
        ),
      ]),
    );
  }
}
