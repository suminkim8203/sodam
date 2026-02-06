import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sodamham/common/color.dart';
import 'package:sodamham/common/view/notebook_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// Block Model Definition
enum BlockType { text, youtube }

class DiaryBlock {
  final String id;
  BlockType type;
  TextEditingController? textController; // For text block
  FocusNode? focusNode; // For text block
  String? videoId; // For youtube block
  String? youtubeTitle; // For youtube block
  String? youtubeDesc; // For youtube block
  String? youtubeUrl; // For youtube block

  DiaryBlock({
    required this.id,
    required this.type,
    this.textController,
    this.focusNode,
    this.videoId,
    this.youtubeTitle,
    this.youtubeDesc,
    this.youtubeUrl,
  });

  // Serialization for Drafts
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'text': textController?.text,
      'videoId': videoId,
      'youtubeTitle': youtubeTitle,
      'youtubeDesc': youtubeDesc,
      'youtubeUrl': youtubeUrl,
    };
  }

  factory DiaryBlock.fromJson(Map<String, dynamic> json) {
    var type = json['type'] == 'BlockType.youtube'
        ? BlockType.youtube
        : BlockType.text;
    return DiaryBlock(
      id: json['id'],
      type: type,
      textController: type == BlockType.text
          ? TextEditingController(text: json['text'])
          : null,
      focusNode: type == BlockType.text ? FocusNode() : null,
      videoId: json['videoId'],
      youtubeTitle: json['youtubeTitle'],
      youtubeDesc: json['youtubeDesc'],
      youtubeUrl: json['youtubeUrl'],
    );
  }
}

class DiaryCreateScreen extends StatefulWidget {
  const DiaryCreateScreen({super.key});

  @override
  State<DiaryCreateScreen> createState() => _DiaryCreateScreenState();
}

class _DiaryCreateScreenState extends State<DiaryCreateScreen> {
  // Block List State
  List<DiaryBlock> _blocks = [];

  List<String> _selectedImages = []; // Selected image paths
  int _currentImageIndex = 0;

  // Header State
  DateTime _selectedDate = DateTime.now();
  String _selectedWeather = 'sunny'; // sunny, cloud, rain, snow
  String _selectedMood = 'happy'; // happy, neutral, sad, angry

  bool _canPop = false; // Add this flag

  static const String _draftContentKey =
      'draft_content_blocks_v2'; // Changed key for new format
  static const String _draftImagesKey = 'draft_images';

  @override
  void initState() {
    super.initState();

    // 화면이 그려진 후 임시저장 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDraft();
    });
  }

  void _addInitialBlock() {
    final block = DiaryBlock(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: BlockType.text,
      textController: TextEditingController(),
      focusNode: FocusNode(),
    );
    // Add Listener for URL detection
    block.textController!.addListener(() => _onTextChanged(block));
    setState(() {
      _blocks = [block];
    });
  }

  @override
  void dispose() {
    for (var block in _blocks) {
      block.textController?.dispose();
      block.focusNode?.dispose();
    }
    super.dispose();
  }

  // --- Logic Methods ---

  void _onTextChanged(DiaryBlock block) {
    if (block.type != BlockType.text) return;
    final text = block.textController!.text;

    // Regex for YouTube URLs (covers various formats)
    final RegExp youtubeRegex = RegExp(
      r'(https?:\/\/)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)\/(watch\?v=|embed\/|v\/|shorts\/|.+\?v=)?([^&=%\?]{11})([\w\-\.,@?^=%&:\/~\+#]*[\w\-\@?^=%&\/~\+#])?',
      caseSensitive: false,
    );

    final match = youtubeRegex.firstMatch(text);
    if (match != null) {
      final url = text.substring(match.start, match.end);
      final videoId = match.group(6);

      if (videoId != null) {
        // Split functionality
        final preText = text.substring(0, match.start);
        final postText = text.substring(match.end);

        // 1. Update current block (Pre-Text)
        block.textController!.value = TextEditingValue(
          text: preText,
          selection: TextSelection.collapsed(offset: preText.length),
        );

        // 2. Create YouTube Block
        final youtubeBlock = DiaryBlock(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_yt",
          type: BlockType.youtube,
          videoId: videoId,
          youtubeUrl: url,
        );
        _fetchYoutubeData(youtubeBlock); // Fetch Metadata

        // 3. Create Next Text Block (Post-Text)
        final nextTextBlock = DiaryBlock(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_next",
          type: BlockType.text,
          textController: TextEditingController(text: postText),
          focusNode: FocusNode(),
        );
        nextTextBlock.textController!
            .addListener(() => _onTextChanged(nextTextBlock));

        // Insert into list
        final index = _blocks.indexOf(block);
        setState(() {
          _blocks.insert(index + 1, youtubeBlock);
          _blocks.insert(index + 2, nextTextBlock);
        });

        // Move focus to next block
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nextTextBlock.focusNode?.requestFocus();
        });
      }
    } else if (text.contains('\n')) {
      // Handle Newline -> Split Block
      final splitIndex = text.indexOf('\n');
      final preText = text.substring(0, splitIndex);
      final postText = text.substring(splitIndex + 1);

      // Update current block
      block.textController!.value = TextEditingValue(
        text: preText,
        selection: TextSelection.collapsed(offset: preText.length),
      );

      // Create new block
      final nextBlock = DiaryBlock(
        id: DateTime.now().millisecondsSinceEpoch.toString() + "_split",
        type: BlockType.text,
        textController: TextEditingController(text: postText),
        focusNode: FocusNode(),
      );
      nextBlock.textController!.addListener(() => _onTextChanged(nextBlock));

      final index = _blocks.indexOf(block);
      setState(() {
        _blocks.insert(index + 1, nextBlock);
      });

      // Focus next block
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nextBlock.focusNode?.requestFocus();
        // Set cursor to start of new block
        nextBlock.textController!.selection =
            const TextSelection.collapsed(offset: 0);
      });
    }
  }

  Future<void> _fetchYoutubeData(DiaryBlock block) async {
    if (block.youtubeUrl == null) return;
    try {
      final response = await http.get(Uri.parse(
          'https://www.youtube.com/oembed?url=${block.youtubeUrl}&format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          block.youtubeTitle = data['title'];
          block.youtubeDesc =
              data['author_name']; // Use author as desc/subtitle
        });
      }
    } catch (e) {
      print("Error fetching YouTube data: $e");
    }
  }

  void _removeBlock(DiaryBlock block) {
    if (block.type == BlockType.youtube) {
      final index = _blocks.indexOf(block);
      if (index > 0 && index < _blocks.length - 1) {
        // Merge prev and next text blocks?
        // Basic: Just remove Youtube block.
        // Better: Remove Youtube block, and if prev and next are text, merge them?
        // For simplicity: Just remove. The user deals with separate text blocks.
      }
      setState(() {
        _blocks.remove(block);
      });
    }
  }

  // --- Draft Logic ---

  Future<void> _checkDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftContent = prefs.getString(_draftContentKey);
    final draftImages = prefs.getStringList(_draftImagesKey);

    if ((draftContent != null && draftContent.isNotEmpty) ||
        (draftImages != null && draftImages.isNotEmpty)) {
      if (!mounted) return;
      _showLoadDraftDialog();
    } else {
      // No draft, add initial block
      _addInitialBlock();
    }
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftContent = prefs.getString(_draftContentKey);
    final draftImages = prefs.getStringList(_draftImagesKey) ?? [];

    List<DiaryBlock> loadedBlocks = [];
    if (draftContent != null) {
      try {
        final List<dynamic> decoded = json.decode(draftContent);
        loadedBlocks = decoded.map((e) => DiaryBlock.fromJson(e)).toList();
        // Re-attach listeners for text blocks
        for (var block in loadedBlocks) {
          if (block.type == BlockType.text) {
            block.textController!.addListener(() => _onTextChanged(block));
          }
        }
      } catch (e) {
        print("Error parsing draft: $e");
        _addInitialBlock();
        return;
      }
    }

    if (loadedBlocks.isEmpty) {
      _addInitialBlock();
    } else {
      setState(() {
        _blocks = loadedBlocks;
        _selectedImages = draftImages;
        _currentImageIndex = 0;
      });
    }
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize blocks
    final String encodedBlocks =
        json.encode(_blocks.map((b) => b.toJson()).toList());

    await prefs.setString(_draftContentKey, encodedBlocks);
    await prefs.setStringList(_draftImagesKey, _selectedImages);
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftContentKey);
    await prefs.remove(_draftImagesKey);
  }

  // --- Helper Widgets ---

  Widget _buildCustomDialog({
    required String content,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return Dialog(
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
                    content,
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
                    onTap: onCancel,
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
                    onTap: onConfirm,
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

  void _showLoadDraftDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _buildCustomDialog(
          content: '임시저장된 글을\n불러오시겠습니까?',
          onCancel: () {
            _clearDraft();
            Navigator.pop(context);
            // If cleared, ensure we start with a block
            if (_blocks.isEmpty) _addInitialBlock();
          },
          onConfirm: () {
            _loadDraft();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showSaveDraftDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildCustomDialog(
          content: '글쓰기를 취소하시겠습니까?\n작성하던 글은 임시저장 됩니다.',
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: () async {
            await _saveDraft();
            if (!context.mounted) return;
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showImagePicker() async {
    /* Same implementation as before, abbreviated for brevity */
    /* Assuming _CustomImagePickerSheet exists or is imported, wait it's inline logic previously? No it was a separate class at bottom? No it used a widget */
    // Actually in previous file it was a method calling showModalBottomSheet with _CustomImagePickerSheet
    // I need to ensure _CustomImagePickerSheet is preserved or re-implemented.
    // It seems it was likely at the bottom of the file or imported.
    // Checking imports... it wasn't imported. So it must be defined in this file.
    // I must preserve it.
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
              _currentImageIndex = 0;
            } else if (_currentImageIndex >= _selectedImages.length) {
              _currentImageIndex = 0;
            }
          });
        },
      ),
    );
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    bool isContentEmpty = _blocks.every((b) =>
        b.type == BlockType.text && (b.textController?.text.isEmpty ?? true));

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isContentEmpty && _selectedImages.isEmpty) {
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
              if (isContentEmpty && _selectedImages.isEmpty) {
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
              child: GestureDetector(
                onTap: () {
                  // Build text content from blocks for compatibility with detail screen
                  String fullContent = _blocks.map((b) {
                    if (b.type == BlockType.text)
                      return b.textController?.text ?? "";
                    if (b.type == BlockType.youtube)
                      return "\n[YouTube: ${b.youtubeUrl}]\n";
                    return "";
                  }).join(
                      "\n"); // Join with newline to preserve paragraph structure

                  final postData = {
                    'content': fullContent,
                    'images': _selectedImages,
                    'date': DateFormat('yyyy. MM. dd').format(_selectedDate),
                    'author': '나',
                    'weather': _selectedWeather,
                    'mood': _selectedMood,
                  };
                  Navigator.pop(context, postData);
                },
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'SeoulHangang',
                      fontWeight: FontWeight.bold, // w700
                      fontSize: 14.sp,
                      color: primaryFontColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(), // 1. Header is part of the scrollable column
              GestureDetector(
                onTap: _focusLastBlock,
                behavior: HitTestBehavior.translucent,
                child: CustomPaint(
                  painter: NotebookPaperPainter(
                    lineHeight: 28.sp,
                    lineColor: const Color(0xffE0E0E0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: 500.h), // Minimum height for writing area
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          color: Colors.transparent,
                          child: Opacity(
                            opacity: 0.75,
                            child: Transform.scale(
                              scale: 0.95,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffFCFCFC),
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = _blocks.removeAt(oldIndex);
                          _blocks.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (int i = 0; i < _blocks.length; i++)
                          _buildBlockItem(_blocks[i], i),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        if (_selectedImages.isNotEmpty)
          GestureDetector(
            onTap: _showImagePicker,
            child: Container(
              height: 330.h,
              width: double.infinity,
              color: const Color(0xffF0EAE6), // Placeholder bg
              child: Stack(
                children: [
                  PageView.builder(
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
                  if (_selectedImages.length > 1)
                    Positioned(
                      bottom: 15.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(_selectedImages.length, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          )
        else
          GestureDetector(
            onTap: _showImagePicker,
            child: Container(
              height: 330.h,
              width: double.infinity,
              color: const Color(0xffF0EAE6),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined,
                      size: 40.sp, color: const Color(0xff999999)),
                ],
              ),
            ),
          ),
        SizedBox(height: 5.h),
        Container(
          color: const Color(0xffFCFCFC), // Opaque background to hide lines
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: const Color(0xffE9D5CC),
                            onPrimary: primaryFontColor,
                            onSurface: primaryFontColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  DateFormat('yyyy. MM. dd (E)', 'ko_KR').format(_selectedDate),
                  style: TextStyle(
                    fontFamily: 'SeoulHangang',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryFontColor,
                  ),
                ),
              ),
              const Spacer(),
              _buildIconSelector(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlockItem(DiaryBlock block, int index) {
    Widget content;
    if (block.type == BlockType.text) {
      content = KeyboardListener(
        focusNode:
            FocusNode(), // Dummy node to capture keys? No, use TextField's node?
        // Actually KeyboardListener needs to wrap the Widget that has focus.
        // But TextField consumes keys.
        // We use onChanged or just a RawKeyboardListener on the parent.
        // A better way for "Backspace on empty":
        // Use a wrapper that intercepts backspace if text is empty?
        // Flutter's TextField doesn't expose "Backspace on empty".
        // Solution: Use a custom TextEditingController or listen to RawKeyboard.
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            // Case 1: Empty block -> Delete block (existing logic)
            if (block.textController!.text.isEmpty && _blocks.length > 1) {
              _handleBackspaceOnEmptyBlock(block);
            }
            // Case 2: Cursor at start -> Delete previous embed if exists
            else if (block.textController!.selection.baseOffset == 0 &&
                index > 0) {
              final prevBlock = _blocks[index - 1];
              if (prevBlock.type == BlockType.youtube) {
                setState(() {
                  _blocks.removeAt(index - 1);
                });
              }
            }
          }
        },
        child: TextField(
          controller: block.textController,
          focusNode: block.focusNode,
          style: TextStyle(
            fontFamily: 'SeoulHangang',
            fontSize: 14.sp,
            color: primaryFontColor,
            height: 2.0, // Matches 28.sp line height (14 * 2)
          ),
          maxLines: null,
          minLines: 1, // Ensure it has at least one line height
          cursorHeight:
              22.sp, // Reduced cursor height (approx 80% of line height)
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero, // Important for alignment
          ),
        ),
      );
    } else {
      // YouTube Block
      content = _buildYoutubeCard(block);
    }

    // Wrap content in container with Key
    final container = Container(
      key: ValueKey(block.id),
      padding: EdgeInsets.symmetric(horizontal: 16.w), // Re-apply padding here
      child: content,
    );

    if (block.type == BlockType.text) {
      // Text blocks are NOT draggable directly
      return container;
    } else {
      // YouTube blocks ARE draggable via handle
      // Use Stack to position handle inside the card
      return Container(
        key: ValueKey(block.id),
        padding:
            EdgeInsets.only(top: 4.h, bottom: 4.h, left: 16.w, right: 16.w),
        child: Stack(
          children: [
            content, // The Youtube Card
            Positioned(
              top: 10.h,
              right: 12.w,
              child: ReorderableDragStartListener(
                index: index,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  color: Colors.transparent, // Hit test area
                  child: Icon(
                    Icons.menu, // Hamburger icon
                    color: Colors.white,
                    size: 18.sp,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildYoutubeCard(DiaryBlock block) {
    return GestureDetector(
      onTap: () async {
        if (block.youtubeUrl != null) {
          final uri = Uri.parse(block.youtubeUrl!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 8.h), // Reduced margin for cleaner look
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
              child: Image.network(
                'https://img.youtube.com/vi/${block.videoId}/mqdefault.jpg',
                width: 120.w,
                height: 90.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120.w,
                    height: 90.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 12.w,
                    top: 12.w,
                    bottom: 12.w,
                    right: 30.w), // Right padding to avoid handle overlap
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.youtubeTitle ?? 'YouTube Video',
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
                      block.youtubeDesc ?? block.youtubeUrl ?? '',
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

  Widget _buildIconSelector() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Toggle Weather
            // Simple cycle for demo/mvp or show dialog
            // Cycle: sunny -> cloud -> rain -> snow
            setState(() {
              if (_selectedWeather == 'sunny')
                _selectedWeather = 'cloud';
              else if (_selectedWeather == 'cloud')
                _selectedWeather = 'rain';
              else if (_selectedWeather == 'rain')
                _selectedWeather = 'snow';
              else
                _selectedWeather = 'sunny';
            });
          },
          child: Icon(
            _selectedWeather == 'sunny'
                ? Icons.wb_sunny_outlined
                : _selectedWeather == 'cloud'
                    ? Icons.cloud_outlined
                    : _selectedWeather == 'rain'
                        ? Icons.umbrella_outlined
                        : Icons.ac_unit,
            size: 20.sp,
            color: Color(0xff999999),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            // Toggle Mood
            // Cycle: happy -> neutral -> sad -> angry
            setState(() {
              if (_selectedMood == 'happy')
                _selectedMood = 'neutral';
              else if (_selectedMood == 'neutral')
                _selectedMood = 'sad';
              else if (_selectedMood == 'sad')
                _selectedMood = 'angry';
              else
                _selectedMood = 'happy';
            });
          },
          child: Icon(
            _selectedMood == 'happy'
                ? Icons.sentiment_satisfied_alt_outlined
                : _selectedMood == 'neutral'
                    ? Icons.sentiment_neutral_outlined
                    : _selectedMood == 'sad'
                        ? Icons.sentiment_dissatisfied
                        : Icons.sentiment_very_dissatisfied,
            size: 20.sp,
            color: Color(0xff999999),
          ),
        ),
      ],
    );
  }

  void _focusLastBlock() {
    if (_blocks.isEmpty) return;
    final lastBlock = _blocks.last;
    if (lastBlock.type == BlockType.text) {
      lastBlock.focusNode?.requestFocus();
    } else {
      // If last block is not text, add a new text block?
      // For now, user flow generally ends with text or they can add block manually?
      // Let's add new text block if last is youtube.
      // But _addInitialBlock logic handles "initial", maybe just append?
      // Let's keep simpler: assume text usually at end or just focus whatever last.
    }
  }

  void _handleBackspaceOnEmptyBlock(DiaryBlock block) {
    // Only remove if it's not the only block
    if (_blocks.length <= 1) return;

    final index = _blocks.indexOf(block);
    if (index > 0) {
      final prevBlock = _blocks[index - 1];

      // Remove current block
      setState(() {
        _blocks.removeAt(index);
      });

      // Focus previous
      if (prevBlock.type == BlockType.text) {
        prevBlock.focusNode?.requestFocus();
        // Move cursor to end
        prevBlock.textController!.selection = TextSelection.fromPosition(
          TextPosition(offset: prevBlock.textController!.text.length),
        );
      } else {
        // If prev is youtube, focus it (maybe show delete button?)
        // For now just removing the empty line is enough.
      }
    }
  }
}

// Preserve existing _CustomImagePickerSheet
class _CustomImagePickerSheet extends StatefulWidget {
  final List<String> initialSelectedPaths;
  final ValueChanged<List<String>> onSelectionChanged;

  const _CustomImagePickerSheet({
    required this.initialSelectedPaths,
    required this.onSelectionChanged,
  });

  @override
  State<_CustomImagePickerSheet> createState() =>
      _CustomImagePickerSheetState();
}

class _CustomImagePickerSheetState extends State<_CustomImagePickerSheet> {
  // Dummy Asset Images for Demo
  final List<String> _assetImages = [
    'asset/image/alexander-lunyov-jdBFglNgYKc-unsplash.jpg',
    'asset/image/chris-weiher-jgvEtA9yhDI-unsplash.jpg',
    'asset/image/rafael-as-martins-3sGqa8YJIXg-unsplash.jpg',
    'asset/image/edgar-X3ZDEajyqVs-unsplash.jpg',
    'asset/image/ella-arie-_CfSrr0D2hE-unsplash.jpg',
    'asset/image/marek-piwnicki-ktllNfb9cBs-unsplash.jpg',
    'asset/image/mario-scheibl-P3vvI9GZogg-unsplash.jpg',
    'asset/image/museum-of-new-zealand-te-papa-tongarewa-hFXKUCTWEMI-unsplash.jpg',
  ];

  late List<String> _selectedPaths;

  @override
  void initState() {
    super.initState();
    _selectedPaths = List.from(widget.initialSelectedPaths);
  }

  void _toggleSelection(String path) {
    setState(() {
      if (_selectedPaths.contains(path)) {
        _selectedPaths.remove(path);
      } else {
        if (_selectedPaths.length < 5) {
          _selectedPaths.add(path);
        }
      }
      widget.onSelectionChanged(_selectedPaths);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: const Color(0xffFBFAF5), // Background Color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          SizedBox(height: 15.h),
          Container(
            width: 50.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(2.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  const Color(0xffD9D9D9),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero, // Full width
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0, // 1px border effect
                mainAxisSpacing: 1.0,
              ),
              itemCount: _assetImages.length + 1, // +1 for Camera
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Camera Button
                  return Container(
                    color: const Color(0xffEEE9E5),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons
                          .camera_alt_rounded, // or outlined? Standard camera icon
                      color: const Color(0xffB1AEAE),
                      size: 24.sp,
                    ),
                  );
                }

                final path = _assetImages[index - 1];
                final isSelected = _selectedPaths.contains(path);
                final selectionIndex = _selectedPaths.indexOf(path);

                return GestureDetector(
                  onTap: () => _toggleSelection(path),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(path, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 5.w,
                        right: 5.w,
                        child: isSelected
                            ? Container(
                                width: 19.w, // Increased by 2px (17 -> 19)
                                height: 19.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xffE9D5CC),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                ),
                                child: Text(
                                  '${selectionIndex + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              )
                            : Container(
                                width: 19.w,
                                height: 19.w,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
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
