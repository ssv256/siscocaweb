import 'package:domain/domain.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/hospital/hospital_repository.dart';
import 'package:siscoca/routes/routes.dart';
import 'package:toastification/toastification.dart';

class HospitalCreateController extends GetxController  {
  final HospitalRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final Rxn<Hospital> currentHospital = Rxn<Hospital>();
  
  late final TextEditingController nameController;
  late final TextEditingController serviceController;
  late final TextEditingController responsiblePersonController;
  late final TextEditingController addressController;
  late final TextEditingController cityController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  
  final Brain brain = Get.find<Brain>();

  HospitalCreateController({
    required this.repository,
    Hospital? hospital,
  }) {
    nameController = TextEditingController();
    serviceController = TextEditingController();
    responsiblePersonController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    
    if (hospital != null) {
      _initializeWithHospital(hospital);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkForHospital();
  }

  @override
  void onClose() {
    nameController.dispose();
    serviceController.dispose();
    responsiblePersonController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _initializeWithHospital(Hospital hospital) {
    nameController.text = hospital.name;
    serviceController.text = hospital.service;
    responsiblePersonController.text = hospital.responsiblePerson;
    addressController.text = hospital.address;
    cityController.text = hospital.city;
    phoneController.text = hospital.phone;
    emailController.text = hospital.email;
    currentHospital.value = hospital;
    isEdit.value = true;
  }

  void checkForHospital() async {
    isLoading.value = true;
    try {
      final dynamic arguments = Get.arguments;
      if (arguments is Hospital) {
        _initializeWithHospital(arguments);
      } else {
        isEdit.value = false;
      }
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Failed to load hospital: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> create() async {
    try {
      final newHospital = Hospital(
        name: nameController.text,
        service: serviceController.text,
        responsiblePerson: responsiblePersonController.text,
        address: addressController.text,
        city: cityController.text,
        phone: phoneController.text,
        email: emailController.text,
      );

      await repository.createHospital(newHospital);

      Get.offNamed(AppRoutes.hospitals);
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Hospital created successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error creating hospital: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    try {
      final updatedHospital = currentHospital.value!.copyWith(
        name: nameController.text,
        service: serviceController.text,
        responsiblePerson: responsiblePersonController.text,
        address: addressController.text,
        city: cityController.text,
        phone: phoneController.text,
        email: emailController.text,
        updatedAt: DateTime.now(),
      );

      await repository.updateHospital(updatedHospital.id!, updatedHospital);
      
     Get.offNamed(AppRoutes.hospitals);
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Hospital updated successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error updating hospital: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void checkForm() {
    if (formKey.currentState?.validate() ?? false) {
      if (isEdit.value) {
        updateData();
      } else {
        create();
      }
    }
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}