import 'package:domain/domain.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/doctor/doctor_repository.dart';

class DoctorController extends GetxController {
  final DoctorRepository repository;
  DoctorController({required this.repository});

  final isLoading = false.obs;
  final width = 1000.0.obs;
  final doctors = <Doctor>[].obs;
  final doctorsFiltered = <Doctor>[].obs;
  final Brain brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    isLoading.value = true;
    try {
      final result = await repository.getDoctors();
      doctors.assignAll(result);
      doctorsFiltered.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load doctors: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters doctors based on search value
  /// Matches against name, surname, and email
  void filter(String value) {
    if (value.isEmpty) {
      doctorsFiltered.assignAll(doctors);
      return;
    }
    
    final filtered = doctors.where((doctor) {
      final name = doctor.name.toLowerCase();
      final surname = doctor.surname.toLowerCase();
      final email = doctor.email.toLowerCase();
      final searchValue = value.toLowerCase();
      
      return name.contains(searchValue) ||
          surname.contains(searchValue) ||
          email.contains(searchValue);
    }).toList();
    
    doctorsFiltered.assignAll(filtered);
  }

  Future<void> removeDoctor(String id) async {
    isLoading.value = true;
    try {
      await repository.deleteDoctor(id);
      await _loadDoctors();
      Get.snackbar(
        'Success',
        'Doctor deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete doctor: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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

  /// Helper method to get admin status text
  String getAdminStatusText(int isAdmin) {
    return isAdmin == 1 ? 'Admin' : 'Regular';
  }
}