import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';

class AuthMiddleware extends GetMiddleware {
  final Brain brain = Get.find<Brain>();

  @override
  RouteSettings? redirect(String? route) {
    if (route == '/auth' && brain.isLoggedIn) {
      return const RouteSettings(name: '/home');
    }
    if (!brain.isLoggedIn && route != '/auth') {
      return const RouteSettings(name: '/auth');
    }
    return null;
  }
}

class AdminMiddleware extends GetMiddleware {
  final Brain brain = Get.find<Brain>();

  @override
  RouteSettings? redirect(String? route) {
    if (!brain.isAdminUser) {
      Get.snackbar(
        'Access Denied',
        'You need administrator privileges to access this section',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2));
      return const RouteSettings(name: '/home');
    }
    return null;
  }
}