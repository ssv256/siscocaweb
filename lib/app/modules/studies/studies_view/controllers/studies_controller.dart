import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart' as repo;

/// Controller for managing studies data and UI state
class StudyController extends GetxController {
  final repo.StudyRepository repository;
  
  StudyController({required this.repository});

  final searchController = TextEditingController();
  final isLoading = false.obs;
  final width = 1000.0.obs;
  final studies = <Study>[].obs;
  final studiesFiltered = <Study>[].obs;
  final Brain brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    _loadStudies();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Handler for search field changes
  void _onSearchChanged() {
    filter(searchController.text);
  }

  Future<void> _loadStudies() async {
    isLoading.value = true;
    try {
      final result = await repository.getStudies();
      studies.assignAll(result);
      studiesFiltered.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load studies: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters studies based on search value
  void filter(String value) {
    if (value.trim().isEmpty) {
      studiesFiltered.assignAll(studies);
      return;
    }

    final searchValue = value.toLowerCase().trim();
    
    final filtered = studies.where((study) {
      return study.studyName.toLowerCase().contains(searchValue) ||
             study.description.toLowerCase().contains(searchValue) ||
             study.hospital.toLowerCase().contains(searchValue) ||
             study.responsiblePerson.toLowerCase().contains(searchValue);
    }).toList();

    studiesFiltered.assignAll(filtered);
  }


  /// Helper method to format date
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Helper method to get status text
  String getStatusText(int? status) {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }
}