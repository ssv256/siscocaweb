import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/hospitals/index.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/buttons/ed_icon_button.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../widget/hospitals_filter.dart';

class HospitalsDesktopView extends GetView<HospitalController> {
  const HospitalsDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterHospitals(),
          const SizedBox(height: 10),
          Obx(() => MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(
                    headers: const [
                      TableHeader(title: 'Name', width: 300),
                      TableHeader(title: 'Service', width: 300),
                      TableHeader(title: 'City', width: 150),
                      TableHeader(title: 'Responsable', width: 150),
                      TableHeader(title: 'Actions', width: 110),
                    ],
                    rows: controller.hospitalsFiltered.map((hospital) => 
                      TableRowData(
                        onTap: () => Get.toNamed(
                          AppRoutes.hospitalsCreate, 
                          arguments: hospital 
                        ),
                        cells: [
                          Text(
                            hospital.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            hospital.service,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            hospital.city,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            hospital.responsiblePerson,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Row(
                            children: [
                              EdIconBtn(
                                color: Colors.blue,
                                bg: true,
                                icon: Iconsax.edit,
                                onTap: () => Get.toNamed(
                                  AppRoutes.hospitalsCreate,
                                  arguments: hospital,
                                ),
                              ),
                              const SizedBox(width: 10),
                              EdIconBtn(
                                color: Colors.red,
                                bg: true,
                                icon: Iconsax.trash,
                                onTap: () => _showDeleteDialog(context, hospital),
                              ),
                            ],
                          ),
                        ]
                      )
                    ).toList(),
                  ),
          )),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Hospital hospital) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hospital'),
        content: Text('Are you sure you want to delete "${hospital.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removeHospital(hospital.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}