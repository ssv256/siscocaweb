import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ScrollableFormContent extends StatefulWidget {
  final Widget child;

  const ScrollableFormContent({super.key, required this.child});

  @override
  State<ScrollableFormContent> createState() => ScrollableFormContentState();
}

class ScrollableFormContentState extends State<ScrollableFormContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final isAtBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent - 50;
    if (isAtBottom != !_showScrollIndicator) {
      setState(() {
        _showScrollIndicator = !isAtBottom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: widget.child,
        ),
        if (_showScrollIndicator)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.arrow_down_2,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
