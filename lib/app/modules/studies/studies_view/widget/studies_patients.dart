import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/studies_controller.dart';

/// Filter component for studies list
class FilterStudies extends GetView<StudyController> {
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
        // Commented filters can be implemented later
        // const SizedBox(width: 10),
        // InputDropDownEd(onChage: (v){},),
        // const SizedBox(width: 10),
        // InputDropDownEd(onChage: (v){},),
      ],
    );
  }
}