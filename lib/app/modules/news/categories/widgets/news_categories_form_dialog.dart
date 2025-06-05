import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/news/categories/controllers/news_categories_controller.dart';
import 'package:siscoca/app/widgets/inputs/main_input.dart';

class NewsCategoriesFormDialog extends GetView<NewsCategoriesController> {
  const NewsCategoriesFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isDialogOpen.value) {
        return const SizedBox.shrink();
      }
      
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.isEditMode.value ? 'Edit Category' : 'Create Category',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.closeDialog,
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Form
              Obx(() => Form(
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
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        id: 'description',
                        controller: controller.descriptionController,
                        labelText: 'Description',
                        required: true,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        id: 'image',
                        labelText: 'Image URL', 
                        controller: controller.imageUrlController,
                        required: true,
                        isUrl: true,
                      ),
                      const SizedBox(height: 24),
                      
                      // Preview image if URL is provided
                      if (controller.imageUrlController.text.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Image Preview:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  controller.imageUrlController.text,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Invalid image URL',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: controller.closeDialog,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: controller.saveCategory,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              controller.isEditMode.value ? 'Update' : 'Create',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              )),
            ],
          ),
        ),
      );
    });
  }
} 