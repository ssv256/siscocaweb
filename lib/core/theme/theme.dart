import 'package:flutter/material.dart';

class ColorNotifier extends ChangeNotifier {
  bool isDark = false;
  
  // Colores base
  static const lightContainer = Color(0xFFF5F5F5);
  static const darkContainer = Color(0xFF1E1E1E);
  static const darkSurface = Color(0xFF2D2D2D);
  static const lightSurface = Colors.white;
  
  set setIsDark(bool value) {
    isDark = value;
    notifyListeners();
  }
  
  bool get getIsDark => isDark;
  Color get getContainer => isDark ? darkContainer : lightContainer;
  Color get getBgColor => isDark ? lightContainer : darkContainer;
  Color get getContentColor => isDark ? darkContainer.withOpacity(0.8) : lightContainer.withOpacity(0.8);
  Color get getSurface => isDark ? darkSurface : lightSurface;
  
  ThemeData getTheme(BuildContext context) {
    return isDark ? _darkTheme(context) : _lightTheme(context);
  }

  ThemeData _lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightContainer,
      colorScheme: ColorScheme.light(
        surface: lightContainer,
        onSurface: Colors.grey[800] ?? Colors.grey,
        primary: Colors.blue,
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: lightSurface,
        collapsedBackgroundColor: lightSurface,
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        iconColor: Colors.grey[700],
        collapsedIconColor: Colors.grey[700],
      ),
    );
  }

  ThemeData _darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkContainer,
      colorScheme: ColorScheme.dark(
        surface: darkSurface,
        onSurface: Colors.grey[300] ?? Colors.grey,
        primary: Colors.blue,
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: darkSurface,
        collapsedBackgroundColor: darkSurface,
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        iconColor: Colors.grey[400],
        collapsedIconColor: Colors.grey[400],
      ),
    );
  }
}