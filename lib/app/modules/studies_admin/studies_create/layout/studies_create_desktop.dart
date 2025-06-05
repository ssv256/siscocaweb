import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/studies_admin/studies_create/index.dart';
import '../../../../widgets/list/list_Template.dart';

/// Desktop view for creating and editing studies
class StudiesCreateDesktopView extends GetView<StudyAdminCreateController> {
  const StudiesCreateDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height - 140,
        ),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListTemplate(
              controller: ScrollController(),
              children: [
                EstudiesForm(
                  key: ValueKey(controller.isEdit.value),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
