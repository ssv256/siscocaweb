import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/surveys/surveys_view/controllers/survey_controller.dart';

class FilterSurveys extends GetView<SurveyController> {
  const FilterSurveys({super.key});

  @override
  Widget build(BuildContext context) {
    final isStatusDropdownOpen = false.obs;
    final isDateDropdownOpen = false.obs;
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
                            controller: controller.searchController,
                            onChanged: (value) {
                              controller.filter(value);
                              currentNameFilter.value = value;
                            },
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre, descripción...',
                              prefixIcon: Icon(
                                Iconsax.search_normal,
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
              Expanded(
                flex: 3,
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
                              Iconsax.status_up,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filtrar por Estado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show selected status if not "Todos"
                            Obx(() {
                              if (controller.selectedStatus.value == 'Todos') {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  controller.selectedStatus.value,
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
                        // Show selected status as chip when dropdown is closed
                        if (controller.selectedStatus.value == 'Todos') {
                          return const SizedBox.shrink();
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                label: Text(
                                  controller.selectedStatus.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.selectedStatus.value = 'Todos';
                                  controller.filterByStatus();
                                },
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ],
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Status options
                            for (final status in ['Todos', 'Activo', 'Inactivo'])
                              InkWell(
                                onTap: () {
                                  controller.selectedStatus.value = status;
                                  controller.filterByStatus();
                                  isStatusDropdownOpen.value = false;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          
          // Date Range Filter
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date filter dropdown trigger
                    InkWell(
                      onTap: () => isDateDropdownOpen.value = !isDateDropdownOpen.value,
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
                              Iconsax.calendar,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Filtrar por Fecha',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Show date range if active
                            Obx(() {
                              if (!controller.isDateFilterActive.value) {
                                return const SizedBox.shrink();
                              }
                              
                              final dateFormat = DateFormat('dd/MM/yyyy');
                              final startFormatted = controller.startDate.value != null 
                                  ? dateFormat.format(controller.startDate.value!) 
                                  : '';
                              final endFormatted = controller.endDate.value != null 
                                  ? dateFormat.format(controller.endDate.value!) 
                                  : dateFormat.format(DateTime.now());
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$startFormatted - $endFormatted',
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
                              isDateDropdownOpen.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.grey.shade700,
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    // Date filter dropdown content
                    Obx(() {
                      if (!isDateDropdownOpen.value) {
                        // Show date range chip when dropdown is closed
                        if (!controller.isDateFilterActive.value) {
                          return const SizedBox.shrink();
                        }
                        
                        final dateFormat = DateFormat('dd/MM/yyyy');
                        final startFormatted = controller.startDate.value != null 
                            ? dateFormat.format(controller.startDate.value!) 
                            : '';
                        final endFormatted = controller.endDate.value != null 
                            ? dateFormat.format(controller.endDate.value!) 
                            : dateFormat.format(DateTime.now());
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                label: Text(
                                  '$startFormatted - $endFormatted',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  controller.clearDateFilter();
                                },
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxHeight: 400),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Date range picker
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha Inicio',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          final pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: controller.startDate.value ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                          );
                                          
                                          if (pickedDate != null) {
                                            controller.filterByDateRange(
                                              pickedDate, 
                                              controller.endDate.value
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Obx(() {
                                            final dateFormat = DateFormat('dd/MM/yyyy');
                                            final formattedDate = controller.startDate.value != null
                                                ? dateFormat.format(controller.startDate.value!)
                                                : 'Seleccionar';
                                            
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                    color: controller.startDate.value != null
                                                        ? Colors.black87
                                                        : Colors.grey.shade600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Icon(
                                                  Iconsax.calendar_1,
                                                  size: 18,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha Fin',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          // Ensure start date is selected first
                                          if (controller.startDate.value == null) {
                                            Get.snackbar(
                                              'Error',
                                              'Seleccione primero la fecha de inicio',
                                              snackPosition: SnackPosition.BOTTOM,
                                            );
                                            return;
                                          }
                                          
                                          final pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: controller.endDate.value ?? DateTime.now(),
                                            firstDate: controller.startDate.value!,
                                            lastDate: DateTime.now(),
                                          );
                                          
                                          if (pickedDate != null) {
                                            controller.filterByDateRange(
                                              controller.startDate.value, 
                                              pickedDate
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Obx(() {
                                            final dateFormat = DateFormat('dd/MM/yyyy');
                                            final formattedDate = controller.endDate.value != null
                                                ? dateFormat.format(controller.endDate.value!)
                                                : 'Seleccionar';
                                            
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                    color: controller.endDate.value != null
                                                        ? Colors.black87
                                                        : Colors.grey.shade600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Icon(
                                                  Iconsax.calendar_1,
                                                  size: 18,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    controller.clearDateFilter();
                                    isDateDropdownOpen.value = false;
                                  },
                                  child: const Text('Limpiar'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    if (controller.startDate.value != null) {
                                      isDateDropdownOpen.value = false;
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Seleccione al menos la fecha de inicio',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Aplicar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 