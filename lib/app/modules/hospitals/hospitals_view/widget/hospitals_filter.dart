import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/hospitals/hospitals_view/controllers/hospitals_controller.dart';

class FilterHospitals extends GetView<HospitalController> {
  const FilterHospitals({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a TextEditingController for the search field
    final searchController = TextEditingController();
    // Create observables for dropdown states
    final isServicesDropdownOpen = false.obs;
    final isCitiesDropdownOpen = false.obs;
    final isNameFilterFocused = false.obs;
    final currentNameFilter = ''.obs;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter by name
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name filter input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          isNameFilterFocused.value = hasFocus;
                        },
                        child: Obx(() {
                          final hasFocus = isNameFilterFocused.value;
                          return TextField(
                            controller: searchController,
                            onChanged: (value) {
                              controller.filter(value);
                              currentNameFilter.value = value;
                            },
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search by name, city, service...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: hasFocus ? Colors.blue : Colors.grey.shade600,
                                size: 20,
                              ),
                              suffixIcon: Obx(() => currentNameFilter.value.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close, size: 16),
                                      onPressed: () {
                                        searchController.clear();
                                        controller.filter('');
                                        currentNameFilter.value = '';
                                      },
                                    )
                                  : const SizedBox.shrink()),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Services filter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown trigger
                    InkWell(
                      onTap: () => isServicesDropdownOpen.value = !isServicesDropdownOpen.value,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filter by Services',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show count of selected services
                            Obx(() {
                              if (controller.selectedServices.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.selectedServices.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                            const Spacer(),
                            // Dropdown indicator icon
                            Obx(() => Icon(
                              isServicesDropdownOpen.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.grey.shade700,
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    // Dropdown content
                    Obx(() {
                      if (!isServicesDropdownOpen.value) {
                        // Show selected services as chips when dropdown is closed
                        if (controller.selectedServices.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.selectedServices.map((service) {
                              return Chip(
                                label: Text(
                                  service,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.updateSelectedServices(service, false);
                                },
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.isLoadingServices.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          
                          if (controller.availableServices.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.medical_services,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No services available',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          // Add a wrap for service filtering
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableServices.map((service) {
                                      return Obx(() {
                                        final isSelected = controller.selectedServices.contains(service);
                                        return FilterChip(
                                          label: Text(
                                            service,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            controller.updateSelectedServices(service, selected);
                                          },
                                          backgroundColor: Colors.grey.shade50,
                                          selectedColor: Colors.blue,
                                          checkmarkColor: Colors.white,
                                          visualDensity: VisualDensity.compact,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            side: BorderSide(
                                              color: isSelected ? Colors.blue : Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Cities filter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown trigger
                    InkWell(
                      onTap: () => isCitiesDropdownOpen.value = !isCitiesDropdownOpen.value,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city_outlined,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filter by Cities',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show count of selected cities
                            Obx(() {
                              if (controller.selectedCities.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.selectedCities.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                            const Spacer(),
                            // Dropdown indicator icon
                            Obx(() => Icon(
                              isCitiesDropdownOpen.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.grey.shade700,
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    // Dropdown content
                    Obx(() {
                      if (!isCitiesDropdownOpen.value) {
                        // Show selected cities as chips when dropdown is closed
                        if (controller.selectedCities.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.selectedCities.map((city) {
                              return Chip(
                                label: Text(
                                  city,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.updateSelectedCities(city, false);
                                },
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.isLoadingCities.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          
                          if (controller.availableCities.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No cities available',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          // Add a wrap for city filtering
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableCities.map((city) {
                                      return Obx(() {
                                        final isSelected = controller.selectedCities.contains(city);
                                        return FilterChip(
                                          label: Text(
                                            city,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            controller.updateSelectedCities(city, selected);
                                          },
                                          backgroundColor: Colors.grey.shade50,
                                          selectedColor: Colors.blue,
                                          checkmarkColor: Colors.white,
                                          visualDensity: VisualDensity.compact,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            side: BorderSide(
                                              color: isSelected ? Colors.blue : Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          
          // Reset button row
          Obx(() {
            if (controller.selectedServices.isEmpty && controller.selectedCities.isEmpty && currentNameFilter.value.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      searchController.clear();
                      controller.resetAllFilters();
                      isServicesDropdownOpen.value = false;
                      isCitiesDropdownOpen.value = false;
                      currentNameFilter.value = '';
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Clear All Filters'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      textStyle: const TextStyle(fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}