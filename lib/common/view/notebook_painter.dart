import 'package:flutter/material.dart';

class NotebookPaperPainter extends CustomPainter {
  final double lineHeight;
  final Color lineColor;

  NotebookPaperPainter({
    required this.lineHeight,
    this.lineColor = const Color(0xFFE0E0E0), // 연한 회색 (기본값)
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 위에서부터 lineHeight 간격으로 선 그리기
    // 첫 번째 줄은 텍스트가 시작되는 위치를 고려하여 offset을 줄 수 있음
    // 여기서는 간단하게 0부터 시작하거나 lineHeight만큼 띄워서 그림
    for (double y = lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant NotebookPaperPainter oldDelegate) {
    return oldDelegate.lineHeight != lineHeight ||
        oldDelegate.lineColor != lineColor;
  }
}
