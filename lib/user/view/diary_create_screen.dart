import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/view/notebook_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DiaryCreateScreen extends StatefulWidget {
  const DiaryCreateScreen({super.key});

  @override
  State<DiaryCreateScreen> createState() => _DiaryCreateScreenState();
}

class _DiaryCreateScreenState extends State<DiaryCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  List<String> _selectedImages = []; // Selected image paths
  int _currentImageIndex = 0;

  // Header State
  DateTime _selectedDate = DateTime.now();
  String _selectedWeather = 'sunny'; // sunny, cloud, rain, snow
  String _selectedMood = 'happy'; // happy, neutral, sad, angry

  bool _canPop = false; // Add this flag

  static const String _draftContentKey = 'draft_content';

  static const String _draftImagesKey = 'draft_images';

  @override
  void initState() {
    super.initState();
    // 화면이 그려진 후 임시저장 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDraft();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  /// 임시저장 데이터 확인 및 로드 다이얼로그 표시
  Future<void> _checkDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftContent = prefs.getString(_draftContentKey);
    final draftImages = prefs.getStringList(_draftImagesKey);

    // 저장된 내용이 있다면 (텍스트나 이미지 중 하나라도)
    if ((draftContent != null && draftContent.isNotEmpty) ||
        (draftImages != null && draftImages.isNotEmpty)) {
      if (!mounted) return;
      _showLoadDraftDialog();
    }
  }

  /// 커스텀 다이얼로그 빌더
  Widget _buildCustomDialog({
    required String content,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return Dialog(
      backgroundColor: const Color(0xffF9F9F9), // 모달 색상 F9F9F9
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r), // 적절한 라운드
        side: const BorderSide(
            color: Color(0xffE9D5CC), width: 1.0), // 테두리 E9D5CC
      ),
      insetPadding: EdgeInsets.zero, // 기본 패딩 제거
      child: SizedBox(
        width: 260.w, // 가로 260
        height: 142.h, // 세로 142
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Content Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h), // 텍스트를 좀 더 아래로
                child: Center(
                  child: Text(
                    content,
                    textAlign: TextAlign.center, // 중앙 정렬
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
            // Buttons Area
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.h,
                  left: 35.w,
                  right: 35.w), // 여백 조정하여 버튼 크기 축소 (2/3 정도)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 취소 버튼
                  GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      width: 80.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffEEE9E5), // 취소 버튼 색
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xffE9D5CC),
                          width: 1.0,
                        ),
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
                  // 확인 버튼
                  GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      width: 80.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffE9D5CC), // 확인 버튼 색
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xffE9D5CC),
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '확인',
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
    );
  }

  /// 임시저장 불러오기 다이얼로그 (커스텀 적용)
  void _showLoadDraftDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _buildCustomDialog(
          content: '임시저장된 글을\n불러오시겠습니까?',
          onCancel: () {
            _clearDraft(); // 취소 시 임시저장 삭제
            Navigator.pop(context);
          },
          onConfirm: () {
            _loadDraft(); // 확인 시 불러오기
            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// 뒤로가기 시 저장 다이얼로그 (커스텀 적용)
  void _showSaveDraftDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildCustomDialog(
          content: '글쓰기를 취소하시겠습니까?\n작성하던 글은 임시저장 됩니다.',
          onCancel: () {
            Navigator.pop(context); // 다이얼로그 닫기 (화면 유지)
          },
          onConfirm: () async {
            await _saveDraft(); // 저장
            if (!context.mounted) return;
            Navigator.pop(context); // 다이얼로그 닫기
            Navigator.pop(context); // 화면 닫기 (뒤로가기 수행)
          },
        );
      },
    );
  }

  /// 임시저장 데이터 로드 로직
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftContent = prefs.getString(_draftContentKey) ?? '';
    final draftImages = prefs.getStringList(_draftImagesKey) ?? [];

    setState(() {
      _textController.text = draftContent;
      _selectedImages = draftImages;
      _currentImageIndex = 0;
    });
  }

  /// 임시저장 저장 로직
  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftContentKey, _textController.text);
    await prefs.setStringList(_draftImagesKey, _selectedImages);
  }

  /// 임시저장 삭제 로직
  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftContentKey);
    await prefs.remove(_draftImagesKey);
  }

  void _showImagePicker() async {
    // 이미지를 선택하는 동안 실시간으로 배경이 바뀌도록 콜백 전달
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomImagePickerSheet(
        initialSelectedPaths: _selectedImages,
        onSelectionChanged: (selectedPaths) {
          setState(() {
            _selectedImages = selectedPaths;
            if (_selectedImages.isEmpty) {
              _currentImageIndex = 0; // No images, reset index
            } else if (_currentImageIndex >= _selectedImages.length) {
              _currentImageIndex =
                  0; // If current index is out of bounds, reset
            }
          });
        },
      ),
    );
    // 닫힐 때 별도 동작 불필요 (이미 실시간 반영됨)
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_textController.text.isEmpty && _selectedImages.isEmpty) {
          setState(() {
            _canPop = true;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
          return;
        }
        _showSaveDraftDialog();
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
              if (_textController.text.isEmpty && _selectedImages.isEmpty) {
                setState(() {
                  _canPop = true;
                });
                Navigator.pop(context);
              } else {
                _showSaveDraftDialog();
              }
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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: TextButton(
                onPressed: () async {
                  await _clearDraft();

                  final content = _textController.text;
                  final image = _selectedImages.isNotEmpty
                      ? _selectedImages.first
                      : 'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg';

                  if (!context.mounted) return;

                  // Allow pop temporarily
                  setState(() {
                    _canPop = true;
                  });

                  // Delay pop to ensure widget rebuild picks up canPop: true
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.pop(context, {
                        'content': content,
                        'image': image,
                      });
                    }
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
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showImagePicker,
                  child: Container(
                    width: double.infinity,
                    height: 330.h,
                    color: const Color(0xffF0EAE6),
                    child: _selectedImages.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.photo_outlined,
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
                  SizedBox(height: 6.w),

                SizedBox(height: 2.h),

                // Header Area (Date, Weather, Mood)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      // Date Selector
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: Text(
                          DateFormat('yyyy. MM. dd (E)', 'ko_KR')
                              .format(_selectedDate),
                          style: TextStyle(
                            fontFamily: 'SeoulHangang',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryFontColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Weather Selector (Simple toggle for demo)
                      GestureDetector(
                          onTap: () {
                            // Cycle weather for demo
                            final weathers = ['sunny', 'cloud', 'rain', 'snow'];
                            final index = weathers.indexOf(_selectedWeather);
                            setState(() {
                              _selectedWeather =
                                  weathers[(index + 1) % weathers.length];
                            });
                          },
                          child: Icon(
                            _getWeatherIcon(_selectedWeather),
                            size: 20.sp,
                            color: const Color(0xff999999),
                          )),
                      SizedBox(width: 12.w),
                      // Mood Selector (Simple toggle for demo)
                      GestureDetector(
                        onTap: () {
                          // Cycle mood for demo
                          final moods = ['happy', 'neutral', 'sad', 'angry'];
                          final index = moods.indexOf(_selectedMood);
                          setState(() {
                            _selectedMood = moods[(index + 1) % moods.length];
                          });
                        },
                        child: Icon(
                          _getMoodIcon(_selectedMood),
                          size: 20.sp,
                          color: const Color(0xff999999),
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: 12.h),

                // // Divider line
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: Divider(
                //     height: 1,
                //     color: const Color(0xffE9D5CC),
                //   ),
                // ),

                SizedBox(height: 24.h), // Spacing before text

                // Text Input Area with Notebook Background
                GestureDetector(
                  onTap: () {
                    // 빈 공간 터치 시 포커스 요청
                    _focusNode.requestFocus();
                  },
                  behavior: HitTestBehavior.translucent, // 투명 영역 터치 허용
                  child: CustomPaint(
                    painter: NotebookPaperPainter(
                      lineHeight: 28.sp, // 줄 높이 설정
                      lineColor: const Color(0xffE0E0E0),
                    ),
                    child: Container(
                      // 충분한 높이를 주어 하단 터치 영역 확보
                      constraints: BoxConstraints(minHeight: 300.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        maxLines: null,
                        style: TextStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 14.sp,
                          color: primaryFontColor,
                          height:
                              2.0, // 중요: 줄 높이와 맞추기 위해 height 조정 (14 * 2 = 28)
                        ),
                        decoration: InputDecoration(
                          hintText: '오늘의 하루는 어떠셨나요?',
                          hintStyle: TextStyle(
                            fontFamily: 'SeoulHangang',
                            fontSize: 14.sp,
                            color: const Color(0xffBDBDBD), // 힌트 색상 연하게
                            height: 2.0,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero, // 패딩 제거하여 라인 맞춤
                        ),
                        // strutStyle helps to enforce line height strictly
                        strutStyle: StrutStyle(
                          fontFamily: 'SeoulHangang',
                          fontSize: 14.sp,
                          height: 2.0,
                          forceStrutHeight: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
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

class _CustomImagePickerSheet extends StatefulWidget {
  final List<String> initialSelectedPaths; // 초기 선택 이미지 경로 리스트 받기
  final ValueChanged<List<String>>? onSelectionChanged; // 콜백 추가

  const _CustomImagePickerSheet({
    this.initialSelectedPaths = const [],
    this.onSelectionChanged,
  });

  @override
  State<_CustomImagePickerSheet> createState() =>
      _CustomImagePickerSheetState();
}

class _CustomImagePickerSheetState extends State<_CustomImagePickerSheet> {
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
  ];

  final List<int> _selectedIndices = [];

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  // 전달받은 이미지 경로를 기반으로 _selectedIndices 복원
  void _initializeSelection() {
    for (String path in widget.initialSelectedPaths) {
      // Mock 이미지 리스트에서 해당 경로를 가진 모든 인덱스를 찾음
      // 실제 앱에서는 고유 ID 등을 사용해야 함. 여기서는 단순히 경로 매칭되는 첫 번째 인덱스 혹은 모든 인덱스 매칭 등 정책 필요.
      // 편의상 Mock 데이터 중복이 있으므로, 앞에서부터 매칭되는 인덱스를 찾아서 복원 시도.
      // 하지만 Mock 데이터 중복 때문에 정확한 복원이 어려울 수 있음.
      // 여기서는 간단히 '경로가 같은 첫 번째 인덱스'로 매핑하되, 이미 선택된 인덱스라면 다음 인덱스를 찾는 식으로 구현 (중복 허용 시)
      // 지금은 중복 선택 로직이 없으니 가장 간단하게 indexOf 사용.

      // *주의*: Mock 데이터에 중복 경로가 있어서 indexOf는 항상 첫 번째만 찾음.
      // 정확한 동작을 위해 중복 이미지 처리가 필요하지만, UI 데모용이므로
      // _selectedIndices에 존재하지 않는 인덱스를 찾아서 넣는 방식으로 개선.

      for (int i = 0; i < _mockImages.length; i++) {
        if (_mockImages[i] == path && !_selectedIndices.contains(i)) {
          _selectedIndices.add(i);
          break; // 하나 찾으면 다음 path로 넘어감 (각 path 당 하나의 인덱스 매핑)
        }
      }
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });

    // 변경된 선택 목록을 부모에게 실시간 전달
    if (widget.onSelectionChanged != null) {
      final selectedPaths =
          _selectedIndices.map((i) => _mockImages[i]).toList();
      widget.onSelectionChanged!(selectedPaths);
    }
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
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
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(2.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 1.0,
              ),
              itemCount: _mockImages.length + 1,
              itemBuilder: (context, index) {
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
                      if (isSelected)
                        Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
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
