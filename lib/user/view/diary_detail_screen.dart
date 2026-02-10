import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/view/notebook_painter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:sodamham/user/view/diary_create_screen.dart';

class DiaryDetailScreen extends StatefulWidget {
  final String imagePath;
  final String content;
  final String date;
  final String author;
  final String? weather;
  final String? mood;
  final bool isBookmarked;

  const DiaryDetailScreen({
    super.key,
    required this.imagePath,
    required this.content,
    required this.date,
    required this.author,
    this.weather,
    this.mood,
    this.isBookmarked = false,
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
  late String _weather;
  late String _mood;

  int _currentImageIndex = 0;
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    // Initialize with passed data
    _images = [widget.imagePath];
    _content = widget.content;
    _dateStr = widget.date;
    _author = widget.author;
    _weather = widget.weather ?? 'sunny';
    _mood = widget.mood ?? 'happy';
    _isBookmarked = widget.isBookmarked;
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _handleEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryCreateScreen(
          initialData: {
            'content': _content,
            'images': _images,
            'date': _dateStr,
            'author': _author,
            'weather': _weather,
            'mood': _mood,
          },
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      // Immediately pop back to GroupScreen with updated data
      if (!mounted) return;
      Navigator.pop(context, result);
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xffF9F9F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: const BorderSide(color: Color(0xffE9D5CC), width: 1.0),
        ),
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: 260.w,
          height: 142.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Center(
                    child: Text(
                      '정말 삭제하시겠습니까?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SeoulHangang',
                        fontSize: 14.sp,
                        color: primaryFontColor,
                        height: 1.4,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, left: 35.w, right: 35.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 80.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffEEE9E5),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: const Color(0xffE9D5CC), width: 1.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontFamily: 'SeoulHangang',
                            fontSize: 12.sp,
                            color: primaryFontColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close Dialog
                        Navigator.pop(context, 'delete'); // Pop Screen
                      },
                      child: Container(
                        width: 80.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffE9D5CC),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: const Color(0xffE9D5CC), width: 1.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            fontFamily: 'SeoulHangang',
                            fontSize: 12.sp,
                            color: primaryFontColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context, {
            'content': _content,
            'images': _images,
            'date': _dateStr,
            'author': _author,
            'weather': _weather,
            'mood': _mood,
            'isBookmarked': _isBookmarked,
          });
        },
        child: Scaffold(
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
                Navigator.pop(context, {
                  'content': _content,
                  'images': _images,
                  'date': _dateStr,
                  'author': _author,
                  'weather': _weather,
                  'mood': _mood,
                  'isBookmarked': _isBookmarked,
                });
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
            actions: const [], // Removed actions from AppBar
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _DetailHeader(
                    author: _author,
                    isBookmarked: _isBookmarked,
                    onBookmarkToggle: _toggleBookmark,
                    onEdit: _handleEdit,
                    onDelete: _handleDelete,
                  ),

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildContentWidgets(),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather) {
      case 'sunny':
        return Icons.wb_sunny_outlined;
      case 'cloud':
        return Icons.cloud_outlined;
      case 'rain':
        return Icons.umbrella_outlined; // Matches Create Screen
      case 'snow':
        return Icons.ac_unit; // Matches Create Screen
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
        return Icons.sentiment_dissatisfied; // Filled (Matches Create Screen)
      case 'angry':
        return Icons.sentiment_very_dissatisfied; // Matches Create Screen
      default:
        return Icons.sentiment_satisfied_alt_outlined;
    }
  }

  List<Widget> _buildContentWidgets() {
    final List<Widget> widgets = [];
    // Updated regex to consume optional leading/trailing newlines around the tag
    final RegExp ytBlockRegex =
        RegExp(r'\n?\[YouTube: (https?:\/\/[^\]]+)\]\n?');

    // Split content by YouTube blocks
    final matches = ytBlockRegex.allMatches(_content);

    int lastMatchEnd = 0;

    for (var match in matches) {
      // 1. Add text before the match
      if (match.start > lastMatchEnd) {
        final textSegment = _content.substring(lastMatchEnd, match.start);
        if (textSegment.trim().isNotEmpty) {
          widgets.add(Text(
            textSegment,
            style: TextStyle(
              fontFamily: 'SeoulHangang',
              fontSize: 14.sp,
              color: primaryFontColor,
              height: 2.0,
            ),
          ));
        }
      }

      // 2. Add YouTube Widget
      final url = match.group(1);
      if (url != null) {
        widgets.add(_YoutubeEmbedWidget(url: url));
      }

      lastMatchEnd = match.end;
    }

    // 3. Add remaining text
    if (lastMatchEnd < _content.length) {
      final remainingText = _content.substring(lastMatchEnd);
      if (remainingText.trim().isNotEmpty) {
        widgets.add(Text(
          remainingText,
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontSize: 14.sp,
            color: primaryFontColor,
            height: 2.0,
          ),
        ));
      }
    }

    // If empty (e.g. only whitespace), add empty text to prevent layout collapse
    if (widgets.isEmpty) {
      widgets.add(Text(
        _content,
        style: TextStyle(
          fontFamily: 'SeoulHangang',
          fontSize: 14.sp,
          color: primaryFontColor,
          height: 2.0,
        ),
      ));
    }

    return widgets;
  }
}

class _YoutubeEmbedWidget extends StatefulWidget {
  final String url;

  const _YoutubeEmbedWidget({required this.url});

  @override
  State<_YoutubeEmbedWidget> createState() => _YoutubeEmbedWidgetState();
}

class _YoutubeEmbedWidgetState extends State<_YoutubeEmbedWidget> {
  String? _title;
  String? _author;
  String? _thumbnailUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMetadata();
  }

  Future<void> _fetchMetadata() async {
    try {
      // Extract Video ID for Thumbnail
      final RegExp idRegex = RegExp(
        r'(?:v=|\/)([0-9A-Za-z_-]{11}).*',
        caseSensitive: false,
      );
      final match = idRegex.firstMatch(widget.url);
      if (match != null) {
        final videoId = match.group(1);
        _thumbnailUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
      }

      // Fetch Title/Author via oEmbed
      final response = await http.get(Uri.parse(
          'https://www.youtube.com/oembed?url=${widget.url}&format=json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _title = data['title'];
            _author = data['author_name'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(widget.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 14.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xffE6E6E6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: _thumbnailUrl != null
                  ? Image.network(
                      _thumbnailUrl!,
                      width: 120.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120.w,
                        height: 90.h,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 120.w,
                      height: 90.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.ondemand_video, color: Colors.grey),
                    ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title ?? 'YouTube Video',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SeoulHangang',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryFontColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _author ?? widget.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SeoulHangang',
                        fontSize: 12.sp,
                        color: const Color(0xff999999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final String author;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DetailHeader({
    required this.author,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isAuthor = author == '김수민' || author == '나';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
          author,
          style: TextStyle(
            color: primaryFontColor,
            fontFamily: 'SeoulHangang',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        // Bookmark
        // Pushes to right when no menu (Spacer pushes it)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBookmarkToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: SvgPicture.asset(
                isBookmarked
                    ? 'asset/icon/book_mark_filled.svg'
                    : 'asset/icon/book_mark.svg',
                width: 18.w,
                height: 18.w,
                colorFilter: ColorFilter.mode(
                  primaryFontColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        // Kebab Menu - Only for Author
        if (isAuthor) ...[
          SizedBox(width: 4.w), // Small gap between Bookmark and Menu

          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: const Color(0xffF9F9F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: Color(0xffE9D5CC)),
                ),
                textStyle: TextStyle(
                  fontFamily: 'SeoulHangang',
                  fontSize: 14.sp,
                  color: primaryFontColor,
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              offset: const Offset(0, 40), // Adjust dropdown position
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    height: 32.h,
                    value: 'edit',
                    child: Center(child: Text('수정하기')),
                  ),
                  const PopupMenuDivider(height: 1), // Optional divider?
                  PopupMenuItem<String>(
                    height: 32.h,
                    value: 'delete',
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6.h,
                          bottom: 2.h), // Push text down visually more
                      child: Center(child: Text('삭제하기')),
                    ),
                  ),
                ];
              },
              child: Padding(
                padding: EdgeInsets.all(8.w), // Increase touch area
                child: SvgPicture.asset(
                  'asset/icon/kebab.svg',
                  width: 18.w,
                  height: 18.w,
                  colorFilter:
                      ColorFilter.mode(primaryFontColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}
