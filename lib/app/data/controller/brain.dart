import 'package:domain/models/doctor/doctor.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/controller/main_controller.dart';

class Brain extends GetxController with WidgetsBindingObserver {
  static Brain get to => Get.find();

  // Authentication state
  final currentDoctor = Rxn<Doctor>();
  final isAuthenticated = false.obs;
  final isAdmin = false.obs;

  final isLoading = false.obs;
  final bool production = true;

  // Layout properties
  final RxDouble contentWidth = 0.0.obs;
  final RxDouble contentHeight = 0.0.obs;
  final RxBool isDesktop = false.obs;
  final RxBool isTablet = false.obs;
  final RxBool isMobile = false.obs;
  
  // Data status
  final RxBool _dataStatus = true.obs;
  RxBool get dataStatus => _dataStatus;
  set dataStatus(data) {
    _dataStatus.value = data;
    update();
  }
  late final MainController mainController;
  
  // Computed properties
  bool get isLoggedIn => isAuthenticated.value;
  bool get isAdminUser => isAdmin.value;
  Doctor? get doctor => currentDoctor.value;

  void updateAuthState({
    required Doctor? doctor,
    required bool authenticated,
  }) {
    currentDoctor.value = doctor;
    isAuthenticated.value = authenticated;
    isAdmin.value = doctor?.isAdmin == 1;
  }

  void clearAuthState() {
    currentDoctor.value = null;
    isAuthenticated.value = false;
    isAdmin.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<MainController>()) {
      Get.put(MainController());
    }
    mainController = Get.find<MainController>();
    WidgetsBinding.instance.addObserver(this);
    resetWidth();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    resetWidth();
  }

  void resetWidth() {
    final screenWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    
    // Desktop layout (>1024px)
    if (screenWidth > 1024) {
      contentWidth.value = screenWidth - mainController.drawerWidth.value;
      contentWidth.value = contentWidth.value > 1280 ? 1280 : contentWidth.value;
      _updateDeviceType(isDesktop: true);
    }
    // Tablet layout (600-1024px)
    else if (screenWidth > 600) {
      contentWidth.value = screenWidth.toDouble();
      _updateDeviceType(isTablet: true);
    }
    // Mobile layout (<600px)
    else {
      contentWidth.value = screenWidth.toDouble();
      _updateDeviceType(isMobile: true);
    }
    
    // Update height
    contentHeight.value = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height - 140;
    update();
  }

  void _updateDeviceType({
    bool isDesktop = false,
    bool isTablet = false,
    bool isMobile = false,
  }) {
    this.isDesktop.value = isDesktop;
    this.isTablet.value = isTablet;
    this.isMobile.value = isMobile;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}