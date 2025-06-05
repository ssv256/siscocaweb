import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/main/drawer/drawer_item.dart';
import '../controller/main_controller.dart';

class DrawerApp extends GetView<MainController> {

  static const double _defaultWidth = 0.0;
  static const Color _selectedColor = Color.fromRGBO(243, 243, 249, 1);
  static const Color _borderColor = Color.fromARGB(255, 233, 233, 239);
  static const Color _hoverColor = Color.fromRGBO(248, 248, 252, 1);
  static const Color _iconBgColor = Color.fromRGBO(243, 243, 249, 1);
  static const Color _iconColor = Color.fromRGBO(60, 60, 60, 1);
  static const Color _textColor = Color.fromRGBO(60, 60, 60, 1);
  static const Duration _animationDuration = Duration(milliseconds: 250);
  
  final double width;

  const DrawerApp({
    super.key,
    this.width = _defaultWidth,
  });

  // Define a constant for the accent color to ensure consistency
  static const Color _accentColor = Color.fromRGBO(100, 100, 255, 1);
  static const Color _accentBgColor = Color.fromRGBO(230, 230, 255, 1);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      width: controller.drawerWidth.value,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(color: _borderColor),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Drawer(
          elevation: 0,
          shadowColor: Colors.transparent,
          child: Column(
            children: [
              _buildDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: menuItems.map(_buildItem).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildDrawerHeader() {
    return Obx(() {
      final isDrawerExpanded = controller.isDrawerExpanded.value;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(248, 248, 252, 1),
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(240, 240, 245, 1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: isDrawerExpanded 
              ? MainAxisAlignment.spaceBetween 
              : MainAxisAlignment.center,
          children: [
            if (isDrawerExpanded)
              const Row(
                children: [
                  Icon(
                    Iconsax.menu_1,
                    color: _accentColor,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
            IconButton(
              icon: Icon(
                isDrawerExpanded ? Iconsax.arrow_left_2 : Iconsax.arrow_right_2,
                color: _iconColor,
                size: 20,
              ),
              onPressed: controller.toggleDrawer,
              tooltip: isDrawerExpanded ? 'Collapse menu' : 'Expand menu',
              splashRadius: 24,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildItem(DrawerItemData item) {
    return Obx(() {
      final isSelected = controller.selectedDrawerItem.value == item.url;
      final isExpanded = controller.expandedItems.contains(item.url);
      final isDrawerExpanded = controller.isDrawerExpanded.value;
      final hasChildren = item.children.isNotEmpty;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: isSelected || isExpanded ? _selectedColor : Colors.transparent,
            child: InkWell(
              onTap: () {
                // If it has children, toggle expansion without navigating
                if (hasChildren) {
                  controller.toggleItemExpansion(item.url);
                } else {
                  // If no children, select and navigate
                  controller.selectDrawerItem(item.url);
                }
              },
              hoverColor: _hoverColor,
              splashColor: _selectedColor,
              highlightColor: _selectedColor.withOpacity(0.5),
              child: Tooltip(
                message: isDrawerExpanded ? '' : item.name,
                preferBelow: false,
                verticalOffset: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12, 
                    horizontal: isDrawerExpanded ? 12 : 8,
                  ),
                  decoration: BoxDecoration(
                    border: isSelected || isExpanded 
                        ? const Border(
                            left: BorderSide(
                              color: _accentColor,
                              width: 3,
                            ),
                          ) 
                        : null,
                  ),
                  child: _buildVanillaItem(
                    name: item.name,
                    icon: item.icon,
                    hasArrow: hasChildren,
                    isExpanded: isExpanded,
                    isSubcategory: false,
                    isSelected: isSelected,
                    url: item.url,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            height: (isExpanded && hasChildren) 
                ? item.children.length * 48.0 
                : 0,
            color: _accentBgColor.withOpacity(0.2),
            child: ClipRect(
              child: AnimatedOpacity(
                duration: _animationDuration,
                opacity: isExpanded ? 1.0 : 0.0,
                child: isExpanded 
                    ? Column(
                        children: item.children
                            .map((child) => _buildChildItem(child))
                            .toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          // Add a small divider after items with children
          if (hasChildren)
            const Divider(height: 1, thickness: 1, color: Color.fromRGBO(240, 240, 245, 1)),
        ],
      );
    });
  }

  Widget _buildChildItem(DrawerItemChild child) {
    return Obx(() {
      final isSelected = controller.selectedDrawerItem.value == child.url;
      final isDrawerExpanded = controller.isDrawerExpanded.value;

      // Define colors for the dot indicator
      final dotColor = isSelected 
          ? _accentColor
          : const Color.fromRGBO(180, 180, 180, 1);
      
      // Define background color
      final bgColor = isSelected 
          ? _selectedColor 
          : Colors.transparent;

      return Material(
        color: bgColor,
        child: InkWell(
          onTap: () {
            controller.selectDrawerItem(child.url);
          },
          hoverColor: _hoverColor,
          splashColor: _selectedColor,
          highlightColor: _selectedColor.withOpacity(0.5),
          child: Tooltip(
            message: isDrawerExpanded ? '' : child.name,
            preferBelow: false,
            verticalOffset: 20,
            child: Container(
              height: 48,
              padding: EdgeInsets.only(
                left: isDrawerExpanded ? 48 : 16, 
                top: 12, 
                bottom: 12, 
                right: 12,
              ),
              decoration: BoxDecoration(
                border: isSelected 
                    ? const Border(
                        left: BorderSide(
                          color: _accentColor,
                          width: 3,
                        ),
                      ) 
                    : null,
              ),
              child: Row(
                children: [
                  // Add a colored dot indicator for subcategories
                  AnimatedContainer(
                    duration: _animationDuration,
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: _accentColor.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ] : null,
                    ),
                  ),
                  Expanded(
                    child: _buildVanillaItem(
                      name: child.name,
                      hasArrow: false,
                      isSubcategory: true,
                      isSelected: isSelected,
                      url: child.url,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildVanillaItem({
    required String name,
    IconData? icon,
    bool hasArrow = false,
    bool isExpanded = false,
    bool isSubcategory = false,
    bool isSelected = false,
    String url = '',
  }) {
    return Obx(() {
      final isDrawerExpanded = controller.isDrawerExpanded.value;
      
      return Row(
        mainAxisAlignment: isDrawerExpanded 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !isSubcategory)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected || isExpanded 
                    ? _accentBgColor // Use the constant
                    : _iconBgColor,
              ),
              child: Icon(
                icon, 
                color: isSelected || isExpanded ? _accentColor : _iconColor, 
                size: 18
              ),
            ),
          if (isDrawerExpanded) ...[
            if (icon != null) const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected || isExpanded ? _accentColor : _textColor, 
                  fontSize: 14,
                  fontWeight: isSubcategory ? FontWeight.normal : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (hasArrow)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: _animationDuration,
                  child: Icon(
                    Iconsax.arrow_right_3,
                    color: isExpanded ? _accentColor : _iconColor,
                    size: 16,
                  ),
                ),
              ),
          ],
        ],
      );
    });
  }
}