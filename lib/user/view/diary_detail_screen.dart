import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/view/notebook_painter.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatefulWidget {
  final String imagePath;
  final String content;
  final String date;
  final String author;

  const DiaryDetailScreen({
    super.key,
    required this.imagePath,
    required this.content,
    required this.date,
    required this.author,
  });

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  // Data variables
  late List<String> _images;
  late String _content;
  late String _dateStr; // Use String for date as passed from GroupScreen
  late String _author;

  // Dummy static data for weather/mood since GroupScreen doesn't pass it yet
  final String _weather = 'sunny';
  final String _mood = 'happy';

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with passed data
    _images = [widget.imagePath]; // List containing the single image
    // We could add more dummy images if needed, but 'content matching logic' implies 1:1
    _content = widget.content;
    _dateStr = widget.date;
    _author = widget.author;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffFCFCFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryFontColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '소담함',
          style: TextStyle(
            fontFamily: 'HambakSnow',
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: primaryFontColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Above Image)
              SizedBox(height: 30.h),
              _DetailHeader(author: _author), // Pass author name

              SizedBox(height: 10.h),

              // 2. Image Carousel with Indicators
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 330.h,
                    color: const Color(0xffF0EAE6),
                    child: PageView.builder(
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  // Page Indicators (Bottom of Image)
                  if (_images.length > 1)
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 18.h),

              // 3. Info Row (Date, Weather, Mood)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      _dateStr, // Display passed date string directly
                      style: TextStyle(
                        fontFamily: 'SeoulHangang',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryFontColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _getWeatherIcon(_weather),
                      size: 20.sp,
                      color: const Color(0xff999999),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      _getMoodIcon(_mood),
                      size: 20.sp,
                      color: const Color(0xff999999),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 4. Content Body
              CustomPaint(
                painter: NotebookPaperPainter(
                  lineHeight: 28.sp,
                  lineColor: const Color(0xffE0E0E0),
                ),
                child: Container(
                  constraints: BoxConstraints(minHeight: 300.h),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    _content,
                    style: TextStyle(
                      fontFamily: 'SeoulHangang',
                      fontSize: 14.sp,
                      color: primaryFontColor,
                      height: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather) {
      case 'sunny':
        return Icons.wb_sunny_outlined;
      case 'cloud':
        return Icons.cloud_outlined;
      case 'rain':
        return Icons.water_drop_outlined;
      case 'snow':
        return Icons.ac_unit_outlined;
      default:
        return Icons.wb_sunny_outlined;
    }
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'happy':
        return Icons.sentiment_satisfied_alt_outlined;
      case 'neutral':
        return Icons.sentiment_neutral_outlined;
      case 'sad':
        return Icons.sentiment_dissatisfied_outlined;
      case 'angry':
        return Icons.sentiment_very_dissatisfied_outlined;
      default:
        return Icons.sentiment_satisfied_alt_outlined;
    }
  }
}

class _DetailHeader extends StatelessWidget {
  final String author;

  const _DetailHeader({required this.author});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: const Color(0xffB1AEAE), // Placeholder color
            // image: DecorationImage(image: NetworkImage('...')),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          author, // Use passed author
          style: TextStyle(
            color: primaryFontColor, // Dark color (PostItem style)
            fontFamily: 'SeoulHangang',
            fontSize: 12.sp, // Match PostItem size
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        // Bookmark
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              'asset/icon/book_mark.svg',
              colorFilter: ColorFilter.mode(primaryFontColor, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        // Kebab Menu
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              'asset/icon/kebab.svg',
              colorFilter: ColorFilter.mode(primaryFontColor, BlendMode.srcIn),
            ),
          ),
        ),
      ]),
    );
  }
}
