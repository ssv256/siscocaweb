import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  static const double kMaxContentWidth = 1280;

  final Widget content;
  final double width;
  final Widget header;
  final bool enableScroll;

  const ScreenLayout({
    super.key,
    required this.content,
    required this.width,
    required this.header,
    required this.enableScroll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        Expanded(
          child: _buildScrollableContent(),
        ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    final contentWidget = SizedBox(
      width: width,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kMaxContentWidth,
          ),
          child: content,
        ),
      ),
    );

    return enableScroll
        ? SingleChildScrollView(child: contentWidget)
        : contentWidget;
  }
} 