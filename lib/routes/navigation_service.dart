import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// Navigation service to handle safe navigation
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  bool _isNavigating = false;
  
  Future<T?> safeNavigate<T>(String route, {bool offAll = false, dynamic arguments}) async {
    if (_isNavigating) {
      await Future.delayed(const Duration(milliseconds: 100));
      return safeNavigate(route, offAll: offAll, arguments: arguments);
    }
    try {
      _isNavigating = true;
      if (offAll) {
        return await Get.offAllNamed<T>(route, arguments: arguments);
      }
      return await Get.toNamed<T>(route, arguments: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    } finally {
      _isNavigating = false;
    }
  }
}