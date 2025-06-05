import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/news/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_button.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';

class ArticlesForm extends GetView<ArticlesCreateController> {
  const ArticlesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
      key: controller.formKey,
      child: controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ScrollableFormContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FormSection(
                        title: 'Información Básica',
                        children: [
                          TextFieldWidget(
                            id: 'title',
                            controller: controller.titleController,
                            labelText: 'Título',
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          TextFieldWidget(
                            id: 'description',
                            controller: controller.descriptionController,
                            labelText: 'Descripción',
                            required: true,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      
                      _FormSection(
                        title: 'Enlaces',
                        children: [
                          TextFieldWidget(
                            id: 'image',
                            labelText: 'URL de la Imagen',
                            controller: controller.imageUrlController,
                            required: true,
                            isUrl: true,
                          ),
                          const SizedBox(height: 12),
                          TextFieldWidget(
                            id: 'newsUrl',
                            labelText: 'URL del Artículo',
                            controller: controller.newsUrlController,
                            required: true,
                            isUrl: true,
                          ),
                        ],
                      ),
                      
                      _FormSection(
                        title: 'Configuración',
                        children: [
                          TextFieldWidget(
                            id: 'readingTime',
                            labelText: 'Tiempo de Lectura (minutos)',
                            controller: controller.readingTimeController,
                            required: true,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          CategoryDropdown(
                            selectedCategory: controller.selectedCategory.value,
                            onChanged: controller.updateCategory,
                          ),
                        ],
                      ),
                      
                      _FormSection(
                        title: 'Estado',
                        showDivider: false,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SegmentedButton<int>(
                                  segments: const [
                                    ButtonSegment<int>(
                                      value: 1,
                                      label: Text('Activo'),
                                    ),
                                    ButtonSegment<int>(
                                      value: 0,
                                      label: Text('Inactivo'),
                                    ),
                                  ],
                                  selected: {controller.status.value},
                                  onSelectionChanged: (Set<int> newSelection) {
                                    controller.updateStatus(newSelection.first);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: EdButton(
                  width: double.infinity,
                  textColor: Colors.white,
                  bgColor: Theme.of(context).primaryColor,
                  text: controller.isEdit.value ? 'Actualizar' : 'Crear',
                  onTap: controller.checkForm,
                ),
              ),
            ],
          ),
    ));
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showDivider;

  const _FormSection({
    required this.title,
    required this.children,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (showDivider) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ],
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}