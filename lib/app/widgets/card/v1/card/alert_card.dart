import 'package:domain/models/alerts/alerts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';
import 'package:domain/models/user/user.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';

class AlertCard extends StatelessWidget {
  final double width;
  final Alert alert;

  const AlertCard({
    required this.alert,
    super.key, 
    this.width = 0,
  });

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas';
    } else {
      return '${difference.inMinutes} minutos';
    }
  }

  String _getTypeName(String type) {
    switch (type.toUpperCase()) {
      case 'BLOOD_PRESSURE':
        return 'Presión sanguínea';
      case 'HEART_RATE':
        return 'Ritmo cardíaco';
      case 'TEMPERATURE':
        return 'Temperatura';
      case 'OXYGEN':
        return 'Oxígeno';
      default:
        return type;
    }
  }

  Widget _buildValueDisplay(Map<String, dynamic> healthDataPoint) {
    if (healthDataPoint['type']?.toString().toUpperCase() == 'BLOOD_PRESSURE') {
      final value = healthDataPoint['value'] as Map<String, dynamic>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valor: Sistólica: ${value['systolic']?.toString() ?? 'N/A'} / Diastólica: ${value['diastolic']?.toString() ?? 'N/A'}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
          if (value['heartrate'] != null && value['heartrate'] != 0)
            Text(
              'Ritmo cardíaco: ${value['heartrate']}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      );
    }
    
    // Extract numeric value from the health data point
    String valueStr = 'N/A';
    final value = healthDataPoint['value'];

    if (value != null) {
      // Handle NumericHealthValue objects
      if (value is Map && value.containsKey('numericValue')) {
        valueStr = value['numericValue'].toString();
      } else {
        valueStr = value.toString();
      }
      final measureType = healthDataPoint['type']?.toString().toLowerCase() ?? "";
      if (measureType.contains('heart_rate')) {
        valueStr = '$valueStr BPM';
      } else if (measureType.contains('blood_oxygen') || measureType.contains('oxygen')) {
        valueStr = '$valueStr%';
      } else if (measureType.contains('temperature')) {
        valueStr = '$valueStr °C';
      } else if (measureType.contains('steps')) {
        valueStr = valueStr;
      }
    }
    
    return Text(
      'Valor: $valueStr',
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      overflow: TextOverflow.ellipsis,
    );
  }

  void _navigateToPatientDetails() async {
    final patientId = alert.healthDataPoint['patient_id'];
    try {
      final patientData = await _getPatientById(patientId);
      
      if (patientData != null) {
        Get.toNamed(
          AppRoutes.patientsDetail,
          arguments: patientData,
        );

        Future.delayed(const Duration(milliseconds: 100), () {
          try {
            final controller = Get.find<PatientsDetailController>();
            controller.setSelectedTabIndex(1);    
          } catch (e) {
            debugPrint('Error setting tab index: $e');
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar los detalles del paciente: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Method to get patient data by ID
  Future<User?> _getPatientById(String patientId) async {
    try {
      final patientRepository = Get.find<PatientRepository>();
      return await patientRepository.getPatientsById(patientId);
    } catch (e) {
      debugPrint('Error getting patient data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(alert.alertThreshold.severity);
    
    return GestureDetector(
      onTap: _navigateToPatientDetails,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromARGB(13, 0, 0, 0),
            width: .5
          ),
          color: alert.isRead ? Colors.white : Color.fromARGB(10, severityColor.red, severityColor.green, severityColor.blue),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: .5)
                ),
                child: const Icon(Icons.warning, color: Colors.white, size: 20)
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Paciente ${alert.healthDataPoint['patient_id']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 62, 90, 190)
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if(!alert.isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: const Text(
                              'Nuevo',
                              style: TextStyle(fontSize: 12, color: Colors.white)
                            )
                          )
                      ]
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Hace ${_getTimeAgo(alert.createdAt)}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54)
                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo: ${_getTypeName(alert.healthDataPoint['type'])}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                        _buildValueDisplay(alert.healthDataPoint),
                        Text(
                          'Severidad: ${alert.alertThreshold.severity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: severityColor
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]
          ),
        )
      )
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.yellow;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}