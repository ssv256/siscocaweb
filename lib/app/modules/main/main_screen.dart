import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/appbar/app_bar.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';
import 'package:siscoca/app/modules/main/widget/page_header.dart';
import 'package:siscoca/app/modules/main/widget/responsive_drawer.dart';
import 'package:siscoca/app/modules/main/widget/responsive_layout.dart';
import 'package:siscoca/app/widgets/ui/loader_main.dart';

class MainScreen extends GetView<MainController> {
  final bool loader;
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget? appBar;
  final Widget? drawer;
  final VoidCallback? headerAction;
  final List<Map<String, String>> routes;
  final String title;
  final bool enableScroll;

  const MainScreen({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.appBar,
    this.drawer,
    this.loader = false,
    this.headerAction,
    this.routes = const [],
    this.title = '',
    this.enableScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Use a safer approach to reset drawer width and ensure home is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (width > 0) {
          controller.resetDrawerWidth(width);
          
          // Ensure home is selected when the app first loads
          if (controller.selectedDrawerItem.value.isEmpty || 
              controller.selectedDrawerItem.value == '/') {
            controller.selectedDrawerItem.value = '/';
            controller.currentRoute.value = '/';
          }
        } else {
          debugPrint('Warning: Invalid screen width in MainScreen: $width');
        }
      } catch (e) {
        debugPrint('Error resetting drawer width in MainScreen: $e');
      }
    });
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: appBar ?? const AppBarC(),
      ),
      drawer: ResponsiveDrawer(
        width: width,
        drawer: drawer,
      ),
      body: _buildBody(width),
    );
  }

  Widget _buildBody(double width) {
    if (!loader) return const LoaderMain();
    
    return ResponsiveLayout(
      width: width,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      drawer: drawer,
      controller: controller,
      enableScroll: enableScroll,
      header: PageHeader(
        title: title,
        headerAction: headerAction,
        routes: routes,
      ),
    );
  }

  void goBack() {
    try {
      controller.clearContent();
    } catch (e) {
      debugPrint('Error in goBack: $e');
    }
  }
}
