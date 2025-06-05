import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/doctors/doctors_view/controllers/doctors_controller.dart';

class FilterDoctors extends GetView<DoctorController> {
  const FilterDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
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
          // Filter by name or surname
          Expanded(
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
                          hintText: 'Search by name, surname, email...',
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
          
          // Reset button
          Obx(() {
            if (currentNameFilter.value.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  searchController.clear();
                  controller.filter('');
                  currentNameFilter.value = '';
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