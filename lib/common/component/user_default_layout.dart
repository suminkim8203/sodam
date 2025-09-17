import 'package:flutter/material.dart';

class UserDefaultLayout extends StatelessWidget {
  final Widget body;

  const UserDefaultLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, child: body),
      backgroundColor: Color(0XFFFBFAF5),
    );
  }
}
