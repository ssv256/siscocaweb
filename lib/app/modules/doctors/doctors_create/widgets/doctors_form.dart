import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/doctors/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/main_input.dart';

class DoctorsForm extends GetView<DoctorCreateController> {
  const DoctorsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            id: 'name',
            controller: controller.nameController,
            labelText: 'Name',
            required: true,
          ),
          TextFieldWidget(
            id: 'surname',
            controller: controller.surnameController,
            labelText: 'Surname',
            required: true,
          ),
          TextFieldWidget(
            id: 'email',
            controller: controller.emailController,
            labelText: 'Email',
            required: true,
            isEmail: true,
          ),
          const SizedBox(height: 16),
          
          // Status Selection
          Text(
            'Status',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: controller.status.value,
                onChanged: (value) => controller.updateStatus(value ?? 1),
              ),
              const Text('Active'),
              const SizedBox(width: 16),
              Radio(
                value: 0,
                groupValue: controller.status.value,
                onChanged: (value) => controller.updateStatus(value ?? 0),
              ),
              const Text('Inactive'),
            ],
          ),
          
          // Admin Status Selection
          Text(
            'Administrative Role',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: controller.isAdmin.value,
                onChanged: (value) => controller.updateAdminStatus(value ?? 1),
              ),
              const Text('Admin'),
              const SizedBox(width: 16),
              Radio(
                value: 0,
                groupValue: controller.isAdmin.value,
                onChanged: (value) => controller.updateAdminStatus(value ?? 0),
              ),
              const Text('Regular User'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : EdButton(
                  width: double.infinity,
                  textColor: Colors.white,
                  bgColor: Theme.of(context).primaryColor,
                  text: controller.isEdit.value ? 'Update' : 'Save',
                  onTap: () => controller.checkForm(),
                ),
        ],
      ),
    ));
  }
}