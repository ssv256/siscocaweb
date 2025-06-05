import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/studies_controller.dart';

/// Filter component for studies list
class FilterStudies extends GetView<StudyAdminController> {
  const FilterStudies({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextFieldWidget(
          width: 300,
          controller: controller.searchController,
          title: 'Filter',
          required: false,
          titleMargin: false,
          onchange: controller.filter,
        ),
      ],
    );
  }
}