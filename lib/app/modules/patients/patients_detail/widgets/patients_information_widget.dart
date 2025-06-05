import 'package:domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../controllers/patients_detail_controller.dart';

class PatientsInformationWidget extends GetView<PatientsDetailController> {
  const PatientsInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final User patient = Get.arguments as User;
    return Obx(() {
      final constants = controller.medicalPassport.value?.patientConstants.firstOrNull;
      return MainCard(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // First row with gender icon, name and ID
            Row(
              children: [
                Icon(
                  patient.sex?.toUpperCase() == 'W' ? Icons.female : Icons.male,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '${patient.name} ${patient.surname}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(ID: ${patient.patientNumber ?? 'N/A'})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second row with additional information
            Row(
              children: [
                _buildInfoItem(
                  Icons.cake_outlined,
                  'Edad: ${patient.birthDate ?? 'N/A'} (${_calculateAge(patient.birthDate)} años)',
                ),
                _buildVerticalDivider(),
                _buildInfoItem(
                  Icons.monitor_weight_outlined,
                  'Peso: ${constants?.weight.toString() ?? 'N/A'} kg',
                ),
                _buildVerticalDivider(),
                _buildInfoItem(
                  Icons.height_outlined,
                  'Altura: ${_formatHeight(constants?.height)} cm',
                ),
                _buildVerticalDivider(),
                _buildInfoItem(
                  Icons.email_outlined,
                  'Email: ${patient.email ?? 'N/A'}',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 24,
        width: 1,
        color: Colors.grey[300],
      ),
    );
  }

  String _formatHeight(double? height) {
    if (height == null) return 'N/A';
    return (height ).toStringAsFixed(0);
  }

  int _calculateAge(String? birthDate) {
    if (birthDate == null) return 0;
    final parts = birthDate.split('-');
    if (parts.length != 3) return 0;
    final birth = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    final today = DateTime.now();
    var age = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    return age;
  }
}