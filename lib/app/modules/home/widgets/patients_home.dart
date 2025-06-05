import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/home/controllers/home_controller.dart';
import 'package:siscoca/app/widgets/card/v1/card/main_card.dart';
import 'package:siscoca/app/widgets/list/list_table.dart';

class PatientsHome extends StatelessWidget {
 final List<User> patients;
 
 const PatientsHome({
   super.key, 
   required this.patients,
 });

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
  final screenWidth = MediaQuery.of(context).size.width;
  final tableWidth = screenWidth * 0.65; // 65% of screen width for table area
  
  // Calculate proportional widths for each column
  final nameWidth = tableWidth * 0.3; // 30% for name
  final idWidth = tableWidth * 0.15; // 15% for ID
  final standardWidth = tableWidth * 0.11; // 11% for standard columns
  final statusWidth = tableWidth * 0.11; // 11% for status
  
  // Get the home controller to check for unread alerts
  final HomeController controller = Get.find<HomeController>();

  return MainCard(
    height: MediaQuery.of(context).size.height - 225,
    margin: EdgeInsets.zero,
    child: Obx(() => ListTableWidget(
      headers: [
        TableHeader(title: 'N.', width: idWidth),
        TableHeader(title: 'Name', width: nameWidth),
        TableHeader(title: 'Age', width: standardWidth),
        TableHeader(title: 'Sex', width: standardWidth),
        TableHeader(title: 'Alerts', width: statusWidth),
      ],
      rows: patients.map((patient) => TableRowData(
        onTap: () => Get.toNamed('/patients/detail', arguments: patient),
        cells: [
          Text(patient.patientNumber!,
            style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text('${patient.name ?? ''} ${patient.surname ?? ''}',
            style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text('${calculateAge(patient.birthDate)}',
            style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text(patient.sex?.toUpperCase() ?? 'N/A',
            style: const TextStyle(color: Colors.black, fontSize: 14)),
          _buildStatusIndicator(patient, controller),
        ]
      )).toList(),
    ))
  );
  }

  Widget _buildStatusIndicator(User patient, HomeController controller) {
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
              children: const [
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
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16
                ),
              ],
            )
      ),
    ),
  );
  }
}