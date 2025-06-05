import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/categories_create_controller.dart';

class CategoriesForm extends GetView<CategoriesCreateController> {
  const CategoriesForm({super.key});

   @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
      key: controller.formKey,
      child: controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget(
              id: 'title',
              controller: controller.titleController,
              labelText: 'Title',
              required: true,
            ),
            const SizedBox(height: 12),
            TextFieldWidget(
              id: 'description',
              controller: controller.descriptionController,
              labelText: 'Description',
              required: true,
            ),
            const SizedBox(height: 12),
            TextFieldWidget(
              id: 'image',
              labelText: 'Image URL', 
              controller: controller.imageController,
              required: true,
              isUrl: true,
            ),
            const SizedBox(height: 20),
            EdButton(
              width: double.infinity,
              textColor: Colors.white,
              bgColor: Theme.of(context).primaryColor,
              text: controller.isEdit.value ? 'Actualizar' : 'Crear',
              onTap: () {controller.checkForm();
            
              },
            )
          ],
        ),
    ));
  }
}