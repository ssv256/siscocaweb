import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/hospitals_create_controller.dart';

class HospitalsForm extends GetView<HospitalCreateController> {
  const HospitalsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            id: 'name',
            controller: controller.nameController,
            labelText: 'Nombre del Hospital',
            required: true,
          ),
          TextFieldWidget(
            id: 'service',
            controller: controller.serviceController,
            labelText: 'Servicio',
            required: true,
          ),
          TextFieldWidget(
            id: 'responsiblePerson',
            controller: controller.responsiblePersonController,
            labelText: 'Persona Responsable',
            required: true,
          ),
          TextFieldWidget(
            id: 'address',
            controller: controller.addressController,
            labelText: 'Dirección',
            required: true,
          ),
          TextFieldWidget(
            id: 'city',
            controller: controller.cityController,
            labelText: 'Ciudad',
            required: true,
          ),
          TextFieldWidget(
            id: 'phone',
            controller: controller.phoneController,
            labelText: 'Teléfono',
            required: true,
            keyboardType: TextInputType.phone,
          ),
          TextFieldWidget(
            id: 'email',
            controller: controller.emailController,
            labelText: 'Correo Electrónico',
            required: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          Obx(() => EdButton(
            width: double.infinity,
            textColor: Colors.white,
            bgColor: Theme.of(context).primaryColor,
            text: controller.isEdit.value ? 'Actualizar' : 'Crear',
            onTap: controller.isLoading.value ? null : () => controller.checkForm(),
          )),
        ],
      ),
    );
  }
}