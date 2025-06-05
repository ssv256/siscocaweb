import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/main/appbar/profile_page.dart';
import 'package:siscoca/app/modules/main/appbar/faqpage.dart';
import 'package:siscoca/app/widgets/buttons/ed_icon_button.dart';
import '../controller/main_controller.dart';
import 'package:siscoca/app/modules/auth/auth_login/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarC extends GetView<MainController> {
  // Constants for layout configuration
  static const double _appBarHeight = 50.0;
  static const double _desktopBreakpoint = 1024.0;
  static const double _tabletBreakpoint = 768.0;
  static const double _desktopLeadingWidth = 250.0;
  static const double _mobileLeadingWidth = 200.0;
  
  final bool withBack;
  final String pageBack;

  const AppBarC({
    super.key,
    this.withBack = false,
    this.pageBack = '',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > _desktopBreakpoint;
    final isTablet = screenWidth > _tabletBreakpoint;

    return Container(
      height: _appBarHeight,
      padding: EdgeInsets.only(right: isDesktop ? 15 : 8),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(17, 39, 43, 1),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 233, 233, 239),
          ),
        ),
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: isDesktop ? _desktopLeadingWidth : _mobileLeadingWidth,
        toolbarHeight: _appBarHeight,
        leading: _buildLeading(context),
        backgroundColor: Colors.transparent,
        actions: _buildActions(context, isDesktop, isTablet),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 35,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(
          AppLocalizations.of(context).appTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 25 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, bool isDesktop) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Iconsax.category,
        color: Color.fromARGB(255, 244, 244, 239),
        size: 20,
      ),
      onPressed: () {
        if (isDesktop) {
          controller.toggleDrawer();
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (withBack) return Container();
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > _desktopBreakpoint;
    final isTablet = screenWidth > _tabletBreakpoint;

    return Container(
      width: isDesktop ? _desktopLeadingWidth : _mobileLeadingWidth,
      margin: EdgeInsets.only(left: isDesktop ? 20 : 10),
      child: Row(
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          if (!isDesktop) ...[
            _buildMenuButton(context, false),
            SizedBox(width: isTablet ? 20 : 10),
          ],
          _buildTitle(context, isDesktop),
          if (isDesktop) _buildMenuButton(context, true),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final authController = AuthController.to;
        await authController.logout();
      } catch (e) {
        Get.snackbar(
          l10n.error,
          l10n.logoutError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  List<Widget> _buildActions(BuildContext context, bool isDesktop, bool isTablet) {
    // final colorNotifier = Provider.of<ColorNotifier>(context);
    final l10n = AppLocalizations.of(context);

    return [
      if (isTablet || isDesktop) ...[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _handleLogout(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.logout,
                    color: Colors.red[400],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.logout,
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        // EdIconBtn(
        //   icon: colorNotifier.getIsDark ? Iconsax.sun_1 : Iconsax.moon,
        //   color: colorNotifier.getIsDark 
        //     ? const Color(0xFFFFD700)
        //     : const Color(0xFFC4C4C4),
        //   bg: false,
        //   onTap: () {
        //     colorNotifier.setIsDark = !colorNotifier.getIsDark;
        //   },
        // ),
        EdIconBtn(
          icon: Iconsax.support,
          color: Colors.white,
          bg: false,
          onTap: () {
            final controller = Get.find<MainController>();
            controller.setContent(const FaqPage());
          },
        ),
        EdIconBtn(
          icon: Iconsax.user,
          color: Colors.white,
          bg: false,
          onTap: () {
            final controller = Get.find<MainController>();
            controller.setContent(const ProfileSettingScreen());
          },
        ),
      ],     
    ];
  }
}