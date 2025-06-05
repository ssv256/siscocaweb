import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/doctors/index.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/buttons/ed_icon_button.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../widget/doctors_filter.dart';

class DoctorsDesktopView extends GetView<DoctorController> {
  const DoctorsDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterDoctors(),
          const SizedBox(height: 10),
          Obx(() => MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(
                    
                    headers: [
                      TableHeader(title: '', width: 50), // Columna para el icono
                      TableHeader(title: 'ID', width: 80),
                      TableHeader(title: 'Name', width: 150),
                      TableHeader(title: 'Surname', width: 150),
                      TableHeader(title: 'Email', width: 250),
                      TableHeader(title: 'Admin', width: 100),
                      TableHeader(title: 'Actions', width: 110),
                    ],
                    rows: controller.doctorsFiltered.map((doctor) =>
                      TableRowData(
                        onTap: () => Get.toNamed('/doctors/detail/${doctor.id}'),
                        cells: [
                          const Icon(
                            Iconsax.user_tick,
                            color: Colors.blue,
                            size: 20,
                          ),
                          Text(
                            doctor.id != null && doctor.id!.length > 9 
                              ? doctor.id!.substring(0, 9)
                              : doctor.id ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            doctor.surname,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            doctor.email,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: doctor.isAdmin == 1 
                                ? Colors.blue.withOpacity(0.1) 
                                : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doctor.isAdmin == 1 ? 'Sí' : 'No',
                              style: TextStyle(
                                color: doctor.isAdmin == 1 ? Colors.blue : const Color.fromARGB(255, 231, 64, 64),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              EdIconBtn(
                                color: Colors.blue,
                                bg: true,
                                icon: Iconsax.edit,
                                onTap: () => Get.toNamed(
                                  AppRoutes.doctorsCreate,
                                  arguments: doctor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              EdIconBtn(
                                color: Colors.red,
                                bg: true,
                                icon: Iconsax.trash,
                                onTap: () => _showDeleteDialog(context, doctor),
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

  Future<void> _showDeleteDialog(BuildContext context, Doctor doctor) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Doctor'),
        content: Text('¿Está seguro de eliminar a "${doctor.name} ${doctor.surname}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removeDoctor(doctor.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}