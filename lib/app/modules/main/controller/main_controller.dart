import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:siscoca/app/modules/main/drawer/drawer_item.dart';
import 'package:siscoca/routes/routes.dart';

class MainController extends GetxController {
  // Existing properties
  final RxBool isDrawerExpanded = true.obs;
  final RxDouble drawerWidth = 250.0.obs;
  final RxString currentRoute = ''.obs;
  final RxString selectedDrawerItem = ''.obs;
  final Rx<Widget?> currentContent = Rx<Widget?>(null);
  final RxBool isDynamicContent = false.obs;
  final RxString previousRoute = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString hospital = ''.obs;
  final RxString study = ''.obs;
  
  // Property to track expanded items
  final RxList<String> expandedItems = <String>[].obs;
  
  // Screen size worker
  Worker? _mediaQueryWorker;
  
  late Doctor doctor;
  late bool isAdmin;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Drawer dimensions
  static const double expandedDrawerWidth = 260.0;
  static const double collapsedDrawerWidth = 70.0;
  static const Duration drawerAnimationDuration = Duration(milliseconds: 250);

  MainController() {
    doctor = Doctor(email: 'email', isAdmin: 1, name: 'name', surname: 'surname');
    isAdmin = doctor.isAdmin == 1;
  }

  @override
  void onInit() {
    super.onInit();
    initializeDrawer();
    
    // Set the home route as the default selected item
    selectedDrawerItem.value = AppRoutes.home;
    currentRoute.value = AppRoutes.home;
    
    updateCurrentRoute();
    
    // Use a safer approach to listen to screen size changes
    _setupScreenSizeListener();
  }
  
  void _setupScreenSizeListener() {
    try {
      // Cancel any existing worker
      _mediaQueryWorker?.dispose();
      
      // Create a new worker with debounce to avoid too frequent updates
      _mediaQueryWorker = debounce(
        Get.mediaQuery.obs, 
        (mediaQuery) {
          try {
            final screenWidth = mediaQuery.size.width;
            if (screenWidth > 0) {
              resetDrawerWidth(screenWidth);
            }
          } catch (e) {
            debugPrint('Error in media query worker: $e');
          }
        },
        time: const Duration(milliseconds: 100),
      );
    } catch (e) {
      debugPrint('Error setting up screen size listener: $e');
    }
  }

  @override
  void onClose() {
    // Clean up resources
    _mediaQueryWorker?.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void initializeDrawer() {
    try {
      // Start with expanded drawer by default
      isDrawerExpanded.value = true;
      drawerWidth.value = expandedDrawerWidth;
      
      // Set home as the default selected item if none is selected
      if (selectedDrawerItem.value.isEmpty) {
        selectedDrawerItem.value = AppRoutes.home;
        currentRoute.value = AppRoutes.home;
      }
      
      // We'll defer the actual width calculation to when the screen size is available
      // This will be handled by resetDrawerWidth which is called from the UI
      
      // If Get.width is available, use it, otherwise we'll rely on resetDrawerWidth later
      if (Get.context != null && Get.height > 0) {
        final screenWidth = Get.width;
        if (screenWidth > 0) {
          if (screenWidth > 1024) {
            isDrawerExpanded.value = true;
            drawerWidth.value = expandedDrawerWidth;
          } else {
            isDrawerExpanded.value = false;
            drawerWidth.value = collapsedDrawerWidth;
          }
        }
      }
    } catch (e) {
      debugPrint('Error initializing drawer: $e');
      // Default to expanded drawer if there's an error
      isDrawerExpanded.value = true;
      drawerWidth.value = expandedDrawerWidth;
    }
  }

  void updateCurrentRoute() {
    try {
      if (!isDynamicContent.value) {
        final route = Get.currentRoute;
        
        // Only update if we have a valid route that's not the initial route
        if (route.isNotEmpty && route != '/') {
          currentRoute.value = route;
          selectedDrawerItem.value = _getBaseRoute(route);
          
          // Auto-expand parent items when a child is selected
          _expandParentOfSelectedItem();
        } else if (selectedDrawerItem.value.isEmpty) {
          // If no drawer item is selected yet, default to home
          selectedDrawerItem.value = AppRoutes.home;
          currentRoute.value = AppRoutes.home;
        }
      }
      update();
    } catch (e) {
      debugPrint('Error updating current route: $e');
    }
  }

  void _expandParentOfSelectedItem() {
    try {
      // Find if the selected item is a child of any parent
      for (var menuItem in menuItems) {
        for (var child in menuItem.children) {
          if (child.url == selectedDrawerItem.value) {
            // Add parent to expanded items if not already there
            if (!expandedItems.contains(menuItem.url)) {
              expandedItems.add(menuItem.url);
            }
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('Error expanding parent item: $e');
    }
  }

  String _getBaseRoute(String route) {
    try {
      final segments = route.split('/');
      if (segments.length >= 2) {
        return '/${segments[1]}';
      }
      return route;
    } catch (e) {
      debugPrint('Error getting base route: $e');
      return route;
    }
  }

  void toggleDrawer() {
    try {
      isDrawerExpanded.value = !isDrawerExpanded.value;
      
      // Animate the drawer width change
      if (isDrawerExpanded.value) {
        drawerWidth.value = expandedDrawerWidth;
      } else {
        // When collapsing, close all expanded items
        expandedItems.clear();
        drawerWidth.value = collapsedDrawerWidth;
      }
      update();
    } catch (e) {
      debugPrint('Error toggling drawer: $e');
    }
  }
  
  void toggleItemExpansion(String url) {
    try {
      // Only allow expansion when drawer is expanded
      if (!isDrawerExpanded.value) {
        isDrawerExpanded.value = true;
        drawerWidth.value = expandedDrawerWidth;
        // Use a safer approach for delayed execution
        Future.microtask(() => _toggleExpansion(url));
      } else {
        _toggleExpansion(url);
      }
    } catch (e) {
      debugPrint('Error toggling item expansion: $e');
    }
  }
  
  void _toggleExpansion(String url) {
    try {
      if (expandedItems.contains(url)) {
        expandedItems.remove(url);
      } else {
        expandedItems.add(url);
        
        // Select this item without navigating
        selectedDrawerItem.value = url;
        currentRoute.value = url;
      }
      update();
    } catch (e) {
      debugPrint('Error in _toggleExpansion: $e');
    }
  }

  void selectDrawerItem(String route) {
    try {
      if (isDynamicContent.value) {
        clearContent();
      }
      
      // If drawer is collapsed and we're selecting an item, expand it
      if (!isDrawerExpanded.value && Get.width > 1024) {
        isDrawerExpanded.value = true;
        drawerWidth.value = expandedDrawerWidth;
      }
      
      selectedDrawerItem.value = route;
      currentRoute.value = route;
      
      // Use a safer approach for navigation
      Future.microtask(() => navigateToRoute(route));
      update();
    } catch (e) {
      debugPrint('Error selecting drawer item: $e');
    }
  }

  void resetDrawerWidth(double screenWidth) {
    try {
      // Ensure we have a valid screen width
      if (screenWidth <= 0) {
        debugPrint('Warning: Invalid screen width provided to resetDrawerWidth: $screenWidth');
        return;
      }
      
      if (screenWidth > 1024) {
        drawerWidth.value = isDrawerExpanded.value
            ? expandedDrawerWidth
            : collapsedDrawerWidth;
      } else {
        drawerWidth.value = 0;
      }
      update();
    } catch (e) {
      debugPrint('Error resetting drawer width: $e');
    }
  }

  void setContent(Widget content) {
    try {
      if (!isDynamicContent.value) {
        previousRoute.value = currentRoute.value;
      }
      currentContent.value = content;
      isDynamicContent.value = true;
      update();
    } catch (e) {
      debugPrint('Error setting content: $e');
    }
  }

  void clearContent() {
    try {
      currentContent.value = null;
      isDynamicContent.value = false;
      if (previousRoute.value.isNotEmpty) {
        currentRoute.value = previousRoute.value;
        selectedDrawerItem.value = _getBaseRoute(previousRoute.value);
      }
      update();
    } catch (e) {
      debugPrint('Error clearing content: $e');
    }
  }

  Future<void> navigateToRoute(String route) async {
    try {
      if (!isDynamicContent.value) {
        // Use a safer approach for navigation
        await Get.toNamed(route)?.catchError((e) {
          debugPrint('Navigation error in catchError: $e');
        });
        
        // Update route after navigation completes
        updateCurrentRoute();
      }
    } catch (e) {
      debugPrint('Navigation error in try/catch: $e');
    }
  }

  Future<void> changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorToast('New passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorToast('No user logged in');
        return;
      }

      // Check if the user has a password provider
      final providerData = user.providerData;
      final hasPasswordProvider = providerData.any(
        (userInfo) => userInfo.providerId == 'password'
      );
      
      if (!hasPasswordProvider) {
        _showErrorToast('This account does not use password authentication');
        return;
      }

      // Verify current password
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        debugPrint('Reauthentication error: ${e.code} - ${e.message}');
        String message = 'Failed to verify current password';
        if (e.code == 'wrong-password') {
          message = 'Current password is incorrect';
        } else if (e.code == 'too-many-requests') {
          message = 'Too many attempts. Please try again later';
        } else if (e.code == 'user-not-found') {
          message = 'User account not found';
        } else if (e.code == 'network-request-failed') {
          message = 'Network error. Please check your connection';
        }
        _showErrorToast(message);
        return;
      }

      // Update password
      try {
        await user.updatePassword(newPasswordController.text);
        
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        _showSuccessToast('Password changed successfully');
      } on FirebaseAuthException catch (e) {
        debugPrint('Update password error: ${e.code} - ${e.message}');
        String message = 'Failed to change password';
        if (e.code == 'weak-password') {
          message = 'Password is too weak. Please use a stronger password';
        } else if (e.code == 'requires-recent-login') {
          message = 'This operation requires recent authentication. Please log in again';
        }
        _showErrorToast(message);
      }
    } catch (e) {
      debugPrint('Unexpected error in changePassword: $e');
      _showErrorToast('An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); 
      _showSuccessToast('Profile updated successfully');
    } catch (e) {
      _showErrorToast('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessToast(String message) {
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.check, color: Colors.white),
      title: Text(message, style: const TextStyle(color: Colors.white)),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
      backgroundColor: Colors.green,
    );
  }

  void _showErrorToast(String message) {
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
      title: Text(message, style: const TextStyle(color: Colors.white)),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
      backgroundColor: Colors.red,
    );
  }
}