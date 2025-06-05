import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';
import 'package:siscoca/app/modules/main/drawer/drawer.dart';
import 'package:siscoca/app/modules/main/widget/screen_layout.dart';

class ResponsiveLayout extends StatelessWidget {
  static const double kTabletBreakpoint = 769;
  static const double kDesktopBreakpoint = 1024;
  static const double kMinContentWidth = 480;

  final double width;
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget? drawer;
  final MainController controller;
  final bool enableScroll;
  final Widget header;

  const ResponsiveLayout({
    super.key,
    required this.width,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.drawer,
    required this.controller,
    required this.enableScroll,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: kMinContentWidth,
      ),
      child: _buildResponsiveLayout(),
    );
  }

  Widget _buildResponsiveLayout() {
    return Obx(() {
      try {
        final currentContent = controller.currentContent.value;
        Widget content = _getContentForWidth(currentContent);

        if (width <= kDesktopBreakpoint) {
          return Scaffold(
            drawer: width <= kDesktopBreakpoint ? const DrawerApp() : null,
            body: ScreenLayout(
              content: content,
              width: width,
              header: header,
              enableScroll: enableScroll,
            ),
          );
        }
        return _buildDesktopLayout(content);
      } catch (e) {
        debugPrint('Error in _buildResponsiveLayout: $e');
        // Fallback to a simple layout in case of error
        return const Center(
          child: Text('Error loading layout. Please try again.'),
        );
      }
    });
  }

  Widget _getContentForWidth(Widget? currentContent) {
    try {
      if (currentContent != null) return currentContent;
      if (width <= kTabletBreakpoint) return mobile;
      if (width <= kDesktopBreakpoint) return tablet;
      return desktop;
    } catch (e) {
      debugPrint('Error in _getContentForWidth: $e');
      // Fallback to a simple widget in case of error
      return const Center(
        child: Text('Error loading content. Please try again.'),
      );
    }
  }

  Widget _buildDesktopLayout(Widget content) {
    return Obx(() {
      try {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: controller.drawerWidth.value,
              child: DrawerApp(width: controller.drawerWidth.value),
            ),
            Expanded(
              child: ScreenLayout(
                content: content,
                width: width - controller.drawerWidth.value,
                header: header,
                enableScroll: enableScroll,
              ),
            ),
          ],
        );
      } catch (e) {
        debugPrint('Error in _buildDesktopLayout: $e');
        // Fallback to a simple layout in case of error
        return const Center(
          child: Text('Error loading desktop layout. Please try again.'),
        );
      }
    });
  }
}