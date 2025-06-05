import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/articles_controller.dart';

class FilterArticles extends GetView<ArticlesController> {
  const FilterArticles({super.key});

  @override
  Widget build(BuildContext context) {
    final isNameFilterFocused = false.obs;
    final currentNameFilter = ''.obs;
    final isCategoriesDropdownOpen = false.obs;
    final isStatusesDropdownOpen = false.obs;
    final isReadingTimesDropdownOpen = false.obs;
    final searchController = TextEditingController();

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
              // Filter by title/description
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              hintText: 'Search by title, description...',
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => isCategoriesDropdownOpen.value = !isCategoriesDropdownOpen.value,
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
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filter by Category',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(() {
                              if (controller.selectedCategories.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.selectedCategories.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                            const Spacer(),
                            Obx(() => Icon(
                              isCategoriesDropdownOpen.value
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
                      if (!isCategoriesDropdownOpen.value) {
                        // Show selected categories as chips when dropdown is closed
                        if (controller.selectedCategories.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.selectedCategories.map((category) {
                              return Chip(
                                label: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.updateSelectedCategories(category, false);
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
                          if (controller.isLoadingCategories.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          
                          if (controller.availableCategories.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No categories available',
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
                          
                          // Add a wrap for category filtering
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableCategories.map((category) {
                                      return Obx(() {
                                        final isSelected = controller.selectedCategories.contains(category);
                                        return FilterChip(
                                          label: Text(
                                            category,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            controller.updateSelectedCategories(category, selected);
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
          
          const SizedBox(height: 16),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status filter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown trigger
                    InkWell(
                      onTap: () => isStatusesDropdownOpen.value = !isStatusesDropdownOpen.value,
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
                              Icons.check_circle_outline,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filter by Status',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show count of selected statuses
                            Obx(() {
                              if (controller.selectedStatuses.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.selectedStatuses.length}',
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
                              isStatusesDropdownOpen.value
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
                      if (!isStatusesDropdownOpen.value) {
                        // Show selected statuses as chips when dropdown is closed
                        if (controller.selectedStatuses.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.selectedStatuses.map((status) {
                              return Chip(
                                label: Text(
                                  controller.getStatusText(status),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: status == 1 ? Colors.green : Colors.red,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.updateSelectedStatuses(status, false);
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
                          if (controller.isLoadingStatuses.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          
                          if (controller.availableStatuses.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No statuses available',
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
                          
                          // Add a wrap for status filtering
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableStatuses.map((status) {
                                      return Obx(() {
                                        final isSelected = controller.selectedStatuses.contains(status);
                                        return FilterChip(
                                          label: Text(
                                            controller.getStatusText(status),
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            controller.updateSelectedStatuses(status, selected);
                                          },
                                          backgroundColor: Colors.grey.shade50,
                                          selectedColor: status == 1 ? Colors.green : Colors.red,
                                          checkmarkColor: Colors.white,
                                          visualDensity: VisualDensity.compact,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            side: BorderSide(
                                              color: isSelected ? (status == 1 ? Colors.green : Colors.red) : Colors.grey.shade300,
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
              
              // Reading Time filter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown trigger
                    InkWell(
                      onTap: () => isReadingTimesDropdownOpen.value = !isReadingTimesDropdownOpen.value,
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
                              Icons.timer_outlined,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filter by Reading Time',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show count of selected reading times
                            Obx(() {
                              if (controller.selectedReadingTimes.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.selectedReadingTimes.length}',
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
                              isReadingTimesDropdownOpen.value
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
                      if (!isReadingTimesDropdownOpen.value) {
                        // Show selected reading times as chips when dropdown is closed
                        if (controller.selectedReadingTimes.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.selectedReadingTimes.map((readingTime) {
                              return Chip(
                                label: Text(
                                  controller.getReadingTimeText(readingTime),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.updateSelectedReadingTimes(readingTime, false);
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
                          if (controller.isLoadingReadingTimes.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          
                          if (controller.availableReadingTimes.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No reading times available',
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
                          
                          // Add a wrap for reading time filtering
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableReadingTimes.map((readingTime) {
                                      return Obx(() {
                                        final isSelected = controller.selectedReadingTimes.contains(readingTime);
                                        return FilterChip(
                                          label: Text(
                                            controller.getReadingTimeText(readingTime),
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            controller.updateSelectedReadingTimes(readingTime, selected);
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
            if (controller.selectedCategories.isEmpty && 
                controller.selectedStatuses.isEmpty && 
                controller.selectedReadingTimes.isEmpty && 
                currentNameFilter.value.isEmpty) {
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
                      isCategoriesDropdownOpen.value = false;
                      isStatusesDropdownOpen.value = false;
                      isReadingTimesDropdownOpen.value = false;
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