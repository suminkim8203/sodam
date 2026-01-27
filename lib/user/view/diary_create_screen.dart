import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sodamham/common/color.dart';

class DiaryCreateScreen extends StatefulWidget {
  const DiaryCreateScreen({super.key});

  @override
  State<DiaryCreateScreen> createState() => _DiaryCreateScreenState();
}

class _DiaryCreateScreenState extends State<DiaryCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedImages = []; //Selected image paths (mock)
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showImagePicker() async {
    final List<String>? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CustomImagePickerSheet(),
    );

    if (result != null) {
      setState(() {
        _selectedImages = result;
        _currentImageIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffFCFCFC),
        elevation: 0,
        scrolledUnderElevation: 0, // 스크롤 시 색상 변경 방지
        centerTitle: false,
        titleSpacing: 0, // 간격 조정
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryFontColor),
          onPressed: () => Navigator.pop(context),
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: TextButton(
              onPressed: () {
                // Confirm action
                // Return data to previous screen
                final content = _textController.text;
                final image = _selectedImages.isNotEmpty
                    ? _selectedImages.first
                    : 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg'; // Default or handled by receiver

                Navigator.pop(context, {
                  'content': content,
                  'image': image,
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryFontColor,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'SeoulHangang',
                  fontSize: 16.sp,
                  color: primaryFontColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // 당겨지지 않도록 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Area
              GestureDetector(
                onTap: _showImagePicker,
                child: Container(
                  width: double.infinity,
                  height: 330.h, // Approx 1:1 or specific height
                  color:
                      const Color(0xffF0EAE6), // Light beige/grey placeholder
                  child: _selectedImages.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.photo_outlined, // Placeholder icon
                            size: 48.sp,
                            color: const Color(0xffBDBDBD),
                          ),
                        )
                      : PageView.builder(
                          itemCount: _selectedImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _selectedImages[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              SizedBox(height: 12.h),

              // Pagination Dots (Only if multiple images)
              if (_selectedImages.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_selectedImages.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? const Color(0xffD9D9D9)
                            : const Color(0xffF0F0F0),
                        border: _currentImageIndex == index
                            ? null
                            : Border.all(color: const Color(0xffD9D9D9)),
                      ),
                    );
                  }),
                )
              else
                SizedBox(height: 6.w), // 점이 없을 때 높이 유지 (혹은 제거)

              SizedBox(height: 12.h),

              // Text Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  style: TextStyle(
                    fontFamily: 'SeoulHangang',
                    fontSize: 14.sp,
                    color: primaryFontColor,
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: '일기를 작성해주세요.',
                    hintStyle: TextStyle(
                      fontFamily: 'SeoulHangang',
                      fontSize: 14.sp,
                      color: const Color(0xff999999),
                      height: 1.6,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
}

class _CustomImagePickerSheet extends StatefulWidget {
  const _CustomImagePickerSheet();

  @override
  State<_CustomImagePickerSheet> createState() =>
      _CustomImagePickerSheetState();
}

class _CustomImagePickerSheetState extends State<_CustomImagePickerSheet> {
  // Mock data for gallery
  final List<String> _mockImages = [
    'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
    'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
    'asset/image/marek-piwnicki-ktllNfb9cBs-unsplash.jpg',
    'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
    'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
    // Duplicates to fill grid
  ];

  final List<int> _selectedIndices = [];

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC), // White bg for sheet
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sheet Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Drag Handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                // Upload Button (Right Aligned)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      final selectedPaths =
                          _selectedIndices.map((i) => _mockImages[i]).toList();
                      Navigator.pop(context, selectedPaths);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffE9D5CC),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '올리기',
                        style: TextStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 13.sp,
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid Content
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(2.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 1.0,
              ),
              itemCount: _mockImages.length + 1, // +1 for Camera icon
              itemBuilder: (context, index) {
                // Camera Icon Item
                if (index == 0) {
                  return Container(
                    color: const Color(0xffF4F4F4),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: const Color(0xff999999),
                        size: 28.sp,
                      ),
                    ),
                  );
                }

                // Image Items
                final imageIndex = index - 1;
                final isSelected = _selectedIndices.contains(imageIndex);
                final selectionOrder =
                    isSelected ? _selectedIndices.indexOf(imageIndex) + 1 : 0;

                return GestureDetector(
                  onTap: () => _toggleSelection(imageIndex),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _mockImages[imageIndex],
                        fit: BoxFit.cover,
                      ),
                      // Overlay when selected
                      if (isSelected)
                        Container(
                          color: Colors.black.withOpacity(0.2), // Dim effect
                        ),
                      // Selection Indicator
                      Positioned(
                        top: 8.w,
                        right: 8.w,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xffE9D5CC)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Text(
                                    '$selectionOrder',
                                    style: TextStyle(
                                      color: primaryFontColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SeoulHangang',
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      // Border when selected
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffE9D5CC),
                              width: 3.w,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
