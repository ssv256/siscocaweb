import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/models/models.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';
import './alerts_controller.dart';

class AlertsListWidget extends StatelessWidget {
  final AlertsController controller;

  const AlertsListWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadAlerts,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value || controller.alerts.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.alerts.length,
          itemBuilder: (context, index) {
            final alert = controller.alerts[index];
            return _buildAlertCard(alert, context);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay alertas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.hasError.value 
                ? controller.errorMessage.value
                : 'El paciente no tiene alertas activas',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Alert alert, BuildContext context) {
    final (severityColor, severityIcon, severityText) = AlertThresholdsComponents.getAlertSeverityInfo(
      alert.alertThreshold.severity
    );
    
    final measurementType = AlertThresholdsComponents.getMeasurementTypeLabel(
      alert.alertThreshold.measureType
    );
    
    // Adjust opacity based on read status
    final double contentOpacity = alert.isRead ? 0.7 : 1.0;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: alert.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: alert.isRead ? Colors.grey.shade300 : severityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showAlertDetails(alert, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              severityColor: severityColor,
              severityIcon: severityIcon,
              severityText: severityText,
              measurementType: measurementType,
              isRead: alert.isRead,
              date: alert.createdAt,
              primaryColor: primaryColor,
            ),
            
            // Content
            Opacity(
              opacity: contentOpacity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información de la alerta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condición detectada: ${alert.alertThreshold.conditions.isNotEmpty ? formatCondition(alert.alertThreshold.conditions.first) : 'Sin descripción'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    _buildHealthDataValue(alert, severityColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader({
    required Color severityColor,
    required IconData severityIcon,
    required String severityText,
    required String measurementType,
    required bool isRead,
    required DateTime date,
    required Color primaryColor,
  }) {
    final headerColor = isRead 
        ? Colors.grey[100] 
        : severityColor.withOpacity(0.1);
    
    // Adjust icon color for read alerts
    final iconColor = isRead ? Colors.grey[500]! : severityColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isRead ? Icons.check_circle : severityIcon, 
              color: iconColor, 
              size: 18
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  measurementType,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isRead ? Colors.grey[700] : Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${severityText} • ${DateFormat('dd/MM/yyyy HH:mm').format(date)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isRead ? Colors.grey[500] : primaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Nueva',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: severityColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthDataValue(Alert alert, Color severityColor) {
    // Simplificando, asumimos que siempre tendremos estos datos
    final measurementType = alert.alertThreshold.measureType;
    final healthData = alert.healthDataPoint;
    
    // Este es un diseño simplificado, se puede expandir según necesidades
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(getHealthDataIcon(measurementType), size: 16, color: severityColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tipo: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      getDataTypeName(measurementType),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Valor: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      formatHealthDataValue(healthData),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDetails(Alert alert, BuildContext context) {
    final (severityColor, severityIcon, severityText) = AlertThresholdsComponents.getAlertSeverityInfo(
      alert.alertThreshold.severity
    );
    
    final formattedCondition = alert.alertThreshold.conditions.isNotEmpty 
        ? formatCondition(alert.alertThreshold.conditions.first)
        : 'Sin descripción';
        
    final measurementType = AlertThresholdsComponents.getMeasurementTypeLabel(
      alert.alertThreshold.measureType
    );

    // Mark alert as read if it's not already read
    if (!alert.isRead) {
      controller.markAlertAsRead(alert);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(severityIcon, color: severityColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            measurementType,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            severityText,
                            style: TextStyle(
                              fontSize: 14,
                              color: severityColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles de la alerta',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Fecha y hora',
                      value: DateFormat('dd/MM/yyyy HH:mm').format(alert.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      icon: Icons.description_outlined,
                      label: 'Condición detectada',
                      value: formattedCondition,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      icon: Icons.medical_services_outlined,
                      label: 'Tipo de medición',
                      value: measurementType,
                    ),
                    
                    // Health data value
                    const SizedBox(height: 20),
                    const Text(
                      'Valor detectado',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHealthDataDetailView(alert, severityColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthDataDetailView(Alert alert, Color severityColor) {
    final measurementType = alert.alertThreshold.measureType;
    final formattedValue = formatHealthDataValue(alert.healthDataPoint);
    final valueColor = severityColor;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(getHealthDataIcon(measurementType), size: 18, color: severityColor),
              ),
              const SizedBox(width: 10),
              Text(
                'Tipo: ${getDataTypeName(measurementType)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Row(
              children: [
                Text(
                  'Valor: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  formattedValue,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funciones de formateo
  String formatHealthDataValue(dynamic healthData) {
    if (healthData == null) {
      return "Valor no disponible";
    }
    try {
      if (healthData is Map) {
        final measureType = healthData['type']?.toString() ?? "";
        
        // Format based on measurement type
        if (measureType.contains('BLOOD_PRESSURE')) {
          final valueMap = healthData['value'];
          if (valueMap is Map) {
            final systolic = valueMap['systolic'];
            final diastolic = valueMap['diastolic'];
            
            if (systolic != null && diastolic != null) {
              return "$systolic/$diastolic mmHg";
            }
          }
        } 
        else if (measureType.contains('blood_oxygen') || measureType.contains('oxygen_saturation')) {
          final value = healthData['value'];
          if (value != null) {
            // Handle both direct values and NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              return "${value['numericValue']}%";
            } else {
              return "${value.toString()}%";
            }
          }
        } 
        else if (measureType.contains('heart_rate')) {
          final value = healthData['value'];
          if (value != null) {
            // Handle both direct values and NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              return "${value['numericValue']} BPM";
            } else {
              return "${value.toString()} BPM";
            }
          }
        } 
        else if (measureType.contains('temperature')) {
          // Para temperatura
          final value = healthData['value'];
          if (value != null) {
            double? numValue;
            
            // Handle NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              try {
                numValue = double.parse(value['numericValue'].toString());
              } catch (e) {
                // Continue with fallback
              }
            } else {
              // Try parsing the raw value
              try {
                numValue = double.parse(value.toString());
              } catch (e) {
                // Continue with fallback
              }
            }
            
            if (numValue != null) {
              return "${numValue.toStringAsFixed(1)} °C";
            } else {
              return "${value.toString()} °C";
            }
          }
        } 
        else if (measureType.contains('weight')) {
          // Para peso
          final value = healthData['value'];
          if (value != null) {
            double? numValue;
            
            // Handle NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              try {
                numValue = double.parse(value['numericValue'].toString());
              } catch (e) {
                // Continue with fallback
              }
            } else {
              // Try parsing the raw value
              try {
                numValue = double.parse(value.toString());
              } catch (e) {
                // Continue with fallback
              }
            }
            
            if (numValue != null) {
              return "${numValue.toStringAsFixed(1)} kg";
            } else {
              return "${value.toString()} kg";
            }
          }
        }
        else if (measureType.contains('glucose')) {
          // Para niveles de glucosa
          final value = healthData['value'];
          if (value != null) {
            // Handle both direct values and NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              return "${value['numericValue']} mg/dL";
            } else {
              return "${value.toString()} mg/dL";
            }
          }
        }
        else if (measureType.contains('STEPS')) {
          final value = healthData['value'];
          if (value != null) {
            // Handle both direct values and NumericHealthValue objects
            if (value is Map && value.containsKey('numericValue')) {
              final steps = value['numericValue'];
              return NumberFormat.decimalPattern().format(steps);
            } else {
              return value.toString();
            }
          }
        }
        if (healthData['value'] != null) {
          final value = healthData['value'];
          if (value is Map && value.containsKey('numericValue')) {
            return value['numericValue'].toString();
          } else {
            return value.toString();
          }
        }
      }
    } catch (e) {
      debugPrint("Error formatting health data: $e");
    }
    return healthData.toString();
  }

  String formatCondition(String condition) {
    return condition;
  }

  String getDataTypeName(String type) {
    
    if (type.contains('BLOOD_PRESSURE')) {
      return 'Presión arterial';
    } else if (type.contains('BLOOD_OXYGEN') || type.contains('OXYGEN_SATURATION')) {
      return 'Oxígeno en sangre';
    } else if (type.contains('heart_rate')) {
      return 'Ritmo cardíaco';
    } else if (type.contains('temperature')) {
      return 'Temperatura';
    } else if (type.contains('weight')) {
      return 'Peso';
    } else if (type.contains('glucose')) {
      return 'Glucosa';
    } else {
      return type;
    }
  }

  IconData getHealthDataIcon(String type) {
    if (type.contains('BLOOD_PRESSURE')) {
      return Icons.monitor_weight_outlined;
    } else if (type.contains('BLOOD_OXYGEN')) {
      return Icons.air;
    } else if (type.contains('HEART_RATE')) {
      return Icons.favorite_border;
    } else if (type.contains('BODY_TEMPERATURE')) {
      return Icons.thermostat_outlined;
    } else if (type.contains('WEIGHT')) {
      return Icons.fitness_center;  
    } else if (type.contains('BLOOD_GLUCOSE')) {
      return Icons.water_drop_outlined;
    } else if (type.contains('STEPS')) {
      return Icons.directions_walk_outlined;
    } else if (type.contains('SLEEP_IN_BED')) {
      return Icons.bedtime_outlined;
    } else {
      return Icons.monitor_heart_outlined;
    }
  }
} 