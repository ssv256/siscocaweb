import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/patients/patients_list/controllers/patients_list_controller.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/buttons/ed_icon_button.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../widget/filter_patients.dart';

class PatientsDesktopView extends GetView<PatientListController> {
  const PatientsDesktopView({super.key});

  int calculateAge(String? birthDate) {
    if (birthDate == null) return 0;
    try {
      final parts = birthDate.split('-');
      if (parts.length != 3) return 0;
      
      final formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
      final birth = DateTime.parse(formattedDate);
      final today = DateTime.now();
      
      int age = today.year - birth.year;
      if (today.month < birth.month || 
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
   return 0;
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterPatients(),
          const SizedBox(height: 10),
          Obx(() => MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(
                    headers: [
                      const TableHeader(title: 'Patient No.', width: 120),
                      TableHeader(title: 'Name', width: controller.width.value * 0.8 - 450),
                      const TableHeader(title: 'Age', width: 80),
                      const TableHeader(title: 'Sex', width: 80),
                      const TableHeader(title: 'Birth Date', width: 120),
                      const TableHeader(title: 'Alerts', width: 120),
                      const TableHeader(title: 'Actions', width: 110),
                    ],
                    rows: controller.patientsFiltered.map((patient) => 
                      TableRowData(
                        onTap: () => Get.toNamed(
                          AppRoutes.patientsDetail,
                          arguments: patient
                        ),
                        cells: [
                          Text(
                            patient.patientNumber ?? patient.id!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            controller.getDisplayName(patient),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            '${calculateAge(patient.birthDate)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            patient.sex?.toUpperCase() ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          Text(
                            patient.birthDate?.toString().split(' ')[0] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            )
                          ),
                          _buildAlertIndicator(patient),
                          Row(
                            children: [
                              EdIconBtn(
                                color: Colors.blue,
                                bg: true,
                                icon: Iconsax.edit,
                                onTap: () => Get.toNamed(
                                  AppRoutes.patientsDetail,
                                  arguments: patient,
                                ),
                              ),
                              const SizedBox(width: 10),
                              EdIconBtn(
                                color: Colors.red,
                                bg: true,
                                icon: Iconsax.trash,
                                onTap: () => _showDeleteDialog(context, patient),
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

  Future<void> _showDeleteDialog(BuildContext context, User patient) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete "${controller.getDisplayName(patient)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removePatient(patient.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertIndicator(User patient) {
    // Check if patient has unread alerts
    final bool hasUnreadAlerts = controller.hasUnreadAlerts(patient.id);
    
    return SizedBox(
      width: 120,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: hasUnreadAlerts ? 100 : 70,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: hasUnreadAlerts 
              ? const Color.fromARGB(255, 247, 82, 70) // Red for unread alerts
              : const Color.fromARGB(241, 123, 202, 125), // Green for normal status
            borderRadius: BorderRadius.circular(10)
          ),
          child: hasUnreadAlerts
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 16
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Unread',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16
                  ),
                  SizedBox(width: 4),
                  Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
        ),
      ),
    );
  }
}