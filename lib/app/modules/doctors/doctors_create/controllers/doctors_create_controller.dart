import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/doctor/doctor_repository.dart';
import 'package:toastification/toastification.dart';

class DoctorCreateController extends GetxController  {
  final DoctorRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final Rxn<Doctor> currentDoctor = Rxn<Doctor>();
  
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController emailController;
  
  final RxInt status = 1.obs;
  final RxInt isAdmin = 0.obs;
  final Brain brain = Get.find<Brain>();

  DoctorCreateController({
    required this.repository,
    Doctor? doctor,
  }) {
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    
    if (doctor != null) {
      _initializeWithDoctor(doctor);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkForDoctor();
  }

  @override
  void onClose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _initializeWithDoctor(Doctor doctor) {
    nameController.text = doctor.name;
    surnameController.text = doctor.surname;
    emailController.text = doctor.email;
    status.value = doctor.status ?? 1;
    isAdmin.value = doctor.isAdmin;
    currentDoctor.value = doctor;
    isEdit.value = true;
  }

  void checkForDoctor() async {
    isLoading.value = true;
    try {
      final dynamic arguments = Get.arguments;
      if (arguments is Doctor) {
        _initializeWithDoctor(arguments);
      } else {
        isEdit.value = false;
      }
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Failed to load doctor: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(int newStatus) {
    status.value = newStatus;
  }

  void updateAdminStatus(int newStatus) {
    isAdmin.value = newStatus;
  }

  Future<void> create() async {
    try {
      final newDoctor = Doctor(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        status: status.value,
        isAdmin: isAdmin.value,
      );

      await repository.createDoctor(newDoctor);

      Get.offNamed('/doctors');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Doctor created successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error creating doctor: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    try {
      final updatedDoctor = currentDoctor.value!.copyWith(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        status: status.value,
        isAdmin: isAdmin.value,
      );

      await repository.updateDoctor(updatedDoctor.id!, updatedDoctor);
      
      Get.offNamed('/doctors');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Doctor updated successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error updating doctor: ${e.toString()}'),
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
}