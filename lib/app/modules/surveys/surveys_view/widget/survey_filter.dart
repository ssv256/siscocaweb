import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/surveys/index.dart';

class FilterSurvey extends GetView<SurveyController> {
  const FilterSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    // Create observables for tracking states
    final isStatusDropdownOpen = false.obs;
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
                        controller: controller.searchController,
                        onChanged: (value) {
                          controller.filter(value);
                          currentNameFilter.value = value;
                        },
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Buscar encuesta...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: hasFocus ? Colors.blue : Colors.grey.shade600,
                            size: 20,
                          ),
                          suffixIcon: Obx(() => currentNameFilter.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  onPressed: () {
                                    controller.searchController.clear();
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
          
          // Status filter
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown trigger
                InkWell(
                  onTap: () => isStatusDropdownOpen.value = !isStatusDropdownOpen.value,
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
                          Icons.filter_list,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => Text(
                            controller.selectedStatus.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                        ),
                        const SizedBox(width: 4),
                        // Dropdown indicator icon
                        Obx(() => Icon(
                          isStatusDropdownOpen.value
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
                  if (!isStatusDropdownOpen.value) {
                    return const SizedBox.shrink();
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(12),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: ['Todos', 'Activo', 'Inactivo'].map((status) {
                        return InkWell(
                          onTap: () {
                            controller.selectedStatus.value = status;
                            controller.filterByStatus();
                            isStatusDropdownOpen.value = false;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: controller.selectedStatus.value == status
                                          ? Colors.blue
                                          : Colors.black87,
                                      fontWeight: controller.selectedStatus.value == status
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (controller.selectedStatus.value == status)
                                  const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          // Reset button
          Obx(() {
            if (controller.selectedStatus.value == 'Todos' && currentNameFilter.value.isEmpty) {
              return const SizedBox(width: 10);
            }
            
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (controller.selectedStatus.value != 'Todos') {
                    controller.selectedStatus.value = 'Todos';
                    controller.filterByStatus();
                    isStatusDropdownOpen.value = false;
                  }
                  
                  if (currentNameFilter.value.isNotEmpty) {
                    controller.searchController.clear();
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