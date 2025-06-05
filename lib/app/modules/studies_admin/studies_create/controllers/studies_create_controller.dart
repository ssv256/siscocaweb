import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart' as repo;
import 'package:siscoca/routes/routes.dart';
import 'package:toastification/toastification.dart';

class StudyAdminCreateController extends GetxController {
  final repo.StudyRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final Rxn<Study> currentStudy = Rxn<Study>();
  
  late final TextEditingController studyNameController;
  late final TextEditingController descriptionController;
  late final TextEditingController hospitalController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController responsiblePersonController;
  late final TextEditingController additionalDataController;
  
  final RxInt status = 1.obs;
  final Brain brain = Get.find<Brain>();

  StudyAdminCreateController({
    required this.repository,
    Study? study,
  }) {
    studyNameController = TextEditingController();
    descriptionController = TextEditingController();
    hospitalController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    responsiblePersonController = TextEditingController();
    additionalDataController = TextEditingController();
    
    if (study != null) {
      _initializeWithStudy(study);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkForStudy();
  }

  @override
  void onClose() {
    studyNameController.dispose();
    descriptionController.dispose();
    hospitalController.dispose();
    emailController.dispose();
    phoneController.dispose();
    responsiblePersonController.dispose();
    additionalDataController.dispose();
    super.onClose();
  }

  void _initializeWithStudy(Study study) {
    studyNameController.text = study.studyName;
    descriptionController.text = study.description;
    hospitalController.text = study.hospital;
    emailController.text = study.email;
    phoneController.text = study.phone;
    responsiblePersonController.text = study.responsiblePerson;
    additionalDataController.text = study.additionalData;
    status.value = study.status ?? 1;
    currentStudy.value = study;
    isEdit.value = true;
  }

  void checkForStudy() async {
    isLoading.value = true;
    try {
      final dynamic arguments = Get.arguments;
      if (arguments is Study) {
        _initializeWithStudy(arguments);
      } else {
        isEdit.value = false;
      }
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Failed to load study: ${e.toString()}'),
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

  Future<void> create() async {
    try {
      final newStudy = Study(
        studyName: studyNameController.text,
        description: descriptionController.text,
        hospital: hospitalController.text,
        email: emailController.text,
        phone: phoneController.text,
        responsiblePerson: responsiblePersonController.text,
        additionalData: additionalDataController.text,
        status: status.value,
      );

      await repository.createStudy(newStudy);

      Get.offNamed(AppRoutes.studiesAdmin);
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Study created successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error creating study: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    try {
      final updatedStudy = currentStudy.value!.copyWith(
        studyName: studyNameController.text,
        description: descriptionController.text,
        hospital: hospitalController.text,
        email: emailController.text,
        phone: phoneController.text,
        responsiblePerson: responsiblePersonController.text,
        additionalData: additionalDataController.text,
        status: status.value,
        updatedAt: DateTime.now(),
      );

      await repository.updateStudy(updatedStudy.id!, updatedStudy);
      
      Get.offNamed(AppRoutes.studiesAdmin);
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Study updated successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error updating study: ${e.toString()}'),
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
