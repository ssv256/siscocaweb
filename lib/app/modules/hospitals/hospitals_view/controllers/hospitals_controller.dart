import 'package:domain/domain.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/hospital/hospital_repository.dart';

class HospitalController extends GetxController {
  final HospitalRepository repository;
  HospitalController({required this.repository});

  final isLoading = false.obs;
  final width = 1000.0.obs;
  final hospitals = <Hospital>[].obs;
  final hospitalsFiltered = <Hospital>[].obs;
  
  // Service filtering properties
  final availableServices = <String>[].obs;
  final selectedServices = <String>[].obs;
  final isLoadingServices = false.obs;
  
  // City filtering properties
  final availableCities = <String>[].obs;
  final selectedCities = <String>[].obs;
  final isLoadingCities = false.obs;

  // Brain instance for global app state
  final Brain brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    isLoading.value = true;
    try {
      final result = await repository.getHospitals();
      hospitals.assignAll(result);
      hospitalsFiltered.assignAll(result);
      
      // Extract unique services from hospitals
      final Set<String> services = {};
      // Extract unique cities from hospitals
      final Set<String> cities = {};
      
      for (var hospital in result) {
        if (hospital.service.isNotEmpty) {
          services.add(hospital.service);
        }
        if (hospital.city.isNotEmpty) {
          cities.add(hospital.city);
        }
      }
      availableServices.assignAll(services.toList()..sort());
      availableCities.assignAll(cities.toList()..sort());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load hospitals: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters hospitals based on search value
  /// Matches against name, city, service, and responsible person
  void filter(String value) {
    if (value.isEmpty && selectedServices.isEmpty && selectedCities.isEmpty) {
      hospitalsFiltered.assignAll(hospitals);
      return;
    }
    
    var filtered = hospitals.toList();
    
    // Apply text search filter if provided
    if (value.isNotEmpty) {
      filtered = filtered.where((hospital) {
        final name = hospital.name.toLowerCase();
        final city = hospital.city.toLowerCase();
        final service = hospital.service.toLowerCase();
        final responsiblePerson = hospital.responsiblePerson.toLowerCase();
        final searchValue = value.toLowerCase();
        
        return name.contains(searchValue) ||
            city.contains(searchValue) ||
            service.contains(searchValue) ||
            responsiblePerson.contains(searchValue);
      }).toList();
    }
    
    // Apply service filter if any services are selected
    if (selectedServices.isNotEmpty) {
      filtered = filtered.where((hospital) {
        return selectedServices.contains(hospital.service);
      }).toList();
    }
    
    // Apply city filter if any cities are selected
    if (selectedCities.isNotEmpty) {
      filtered = filtered.where((hospital) {
        return selectedCities.contains(hospital.city);
      }).toList();
    }
    
    hospitalsFiltered.assignAll(filtered);
  }
  
  /// Update the selected services list and filter hospitals
  void updateSelectedServices(String service, bool isSelected) {
    if (isSelected && !selectedServices.contains(service)) {
      selectedServices.add(service);
    } else if (!isSelected && selectedServices.contains(service)) {
      selectedServices.remove(service);
    }
    filter(''); // Reapply filters with current text filter
  }
  
  /// Update the selected cities list and filter hospitals
  void updateSelectedCities(String city, bool isSelected) {
    if (isSelected && !selectedCities.contains(city)) {
      selectedCities.add(city);
    } else if (!isSelected && selectedCities.contains(city)) {
      selectedCities.remove(city);
    }
    filter(''); // Reapply filters with current text filter
  }
  
  /// Reset service filters
  void resetServiceFilters() {
    selectedServices.clear();
    filter(''); // Reapply any text filter that might be active
  }
  
  /// Reset city filters
  void resetCityFilters() {
    selectedCities.clear();
    filter(''); // Reapply any text filter that might be active
  }
  
  /// Reset all filters
  void resetAllFilters() {
    selectedServices.clear();
    selectedCities.clear();
    filter(''); // Reapply any text filter that might be active
  }

  Future<void> removeHospital(int id) async {
    isLoading.value = true;
    try {
      await repository.deleteHospital(id);
      await _loadHospitals();
      Get.snackbar(
        'Success',
        'Hospital deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete hospital: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to format date
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}