import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_list/controllers/patients_list_controller.dart';

class FilterPatients extends GetView<PatientListController> {
  const FilterPatients({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final isStudiesDropdownOpen = false.obs;
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
      child: Row(
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
                          hintText: 'Search by name, email...',
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
          
          // Studies filter
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown trigger
                InkWell(
                  onTap: () => isStudiesDropdownOpen.value = !isStudiesDropdownOpen.value,
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
                          Icons.science_outlined,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Filter by Studies',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Show count of selected studies
                        Obx(() {
                          if (controller.selectedStudies.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${controller.selectedStudies.length}',
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
                          isStudiesDropdownOpen.value
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
                  if (!isStudiesDropdownOpen.value) {
                    // Show selected studies as chips when dropdown is closed
                    if (controller.selectedStudies.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.selectedStudies.map((study) {
                          return Chip(
                            label: Text(
                              study.studyName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.blue,
                            deleteIconColor: Colors.white,
                            onDeleted: () {
                              controller.updateSelectedStudies(study, false);
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
                      if (controller.isLoadingStudies.value) {
                        return const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      
                      if (controller.studies.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.science,
                                  size: 32,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No studies available',
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
                      
                      // Add a search bar for study filtering
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.studies.map((study) {
                                  return Obx(() {
                                    final isSelected = controller.selectedStudies.contains(study);
                                    return FilterChip(
                                      label: Text(
                                        study.studyName,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontSize: 12,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.updateSelectedStudies(study, selected);
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
          
          // Reset button
          Obx(() {
            if (controller.selectedStudies.isEmpty && currentNameFilter.value.isEmpty) {
              return const SizedBox(width: 10);
            }
            
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (controller.selectedStudies.isNotEmpty) {
                    controller.resetStudyFilters();
                    isStudiesDropdownOpen.value = false;
                  }
                  
                  if (currentNameFilter.value.isNotEmpty) {
                    searchController.clear();
                    controller.filter('');
                    currentNameFilter.value = '';
                  }
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Clear All'),
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
            );
          }),
        ],
      ),
    );
  }
}