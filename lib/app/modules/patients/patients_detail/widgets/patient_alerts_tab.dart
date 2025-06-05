import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/models/models.dart';
import 'package:intl/intl.dart';
import 'package:health/health.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/utils.dart';
import '../controllers/patients_detail_controller.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_threshold_impl_rep.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';

class PatientAlertsTab extends StatefulWidget {
  const PatientAlertsTab({super.key});

  @override
  State<PatientAlertsTab> createState() => _PatientAlertsTabState();
}

class _PatientAlertsTabState extends State<PatientAlertsTab> with SingleTickerProviderStateMixin {
  final PatientsDetailController controller = Get.find<PatientsDetailController>();
  final AlertRepositoryImpl alertRepository = Get.find<AlertRepositoryImpl>();
  final AlertThresholdRepositoryImpl thresholdRepository = Get.find<AlertThresholdRepositoryImpl>();
  
  late TabController _tabController;
  final RxList<Alert> alerts = <Alert>[].obs;
  final RxList<AlertThreshold> thresholds = <AlertThreshold>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isThresholdsLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool hasThresholdsError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString thresholdsErrorMessage = ''.obs;
  final RxInt currentTabIndex = 0.obs;
  late User patient;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    patient = Get.arguments as User;
    _loadAlerts();
    _loadThresholds();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != currentTabIndex.value) {
      currentTabIndex.value = _tabController.index;
    }
  }

  Future<void> _loadAlerts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final patientAlerts = await alertRepository.getPatientAlerts(patient.id!);
      alerts.assignAll(patientAlerts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error al cargar las alertas: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadThresholds() async {
    try {
      isThresholdsLoading.value = true;
      hasThresholdsError.value = false;
      
      final patientThresholds = await thresholdRepository.getThresholdsByPatient(patient.id!);
      thresholds.assignAll(patientThresholds);
    } catch (e) {
      hasThresholdsError.value = true;
      thresholdsErrorMessage.value = 'Error al cargar los umbrales de alerta: $e';
    } finally {
      isThresholdsLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(
                  icon: Icon(Icons.notifications_active_outlined),
                  text: 'Alertas',
                ),
                Tab(
                  icon: Icon(Icons.tune_outlined),
                  text: 'Umbrales',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAlertsTab(),
                _buildThresholdsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        // Only show the FAB on the thresholds tab
        if (currentTabIndex.value == 1) {
          return FloatingActionButton(
            onPressed: _showCreateThresholdDialog,
            child: Icon(Icons.add),
            tooltip: 'Crear nuevo nivel de alerta',
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildAlertsTab() {
    return RefreshIndicator(
      onRefresh: _loadAlerts,
      child: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hasError.value || alerts.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          itemBuilder: (context, index) => _buildAlertCard(alerts[index], context),
        );
      }),
    );
  }

  Widget _buildThresholdsTab() {
    return RefreshIndicator(
      onRefresh: _loadThresholds,
      child: Obx(() {
        if (isThresholdsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (thresholds.isEmpty || hasThresholdsError.value) {
          return _buildThresholdsEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: thresholds.length,
          itemBuilder: (context, index) => _buildThresholdCard(thresholds[index], context),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No hay alertas para este paciente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las alertas aparecerán cuando se detecten anomalías en las mediciones',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Alert alert, BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    
    // Get alert properties
    final (severityColor, severityIcon, severityText) = _getAlertSeverityInfo(alert.alertThreshold.severity);
    final formattedCondition = alert.alertThreshold.conditions.isNotEmpty 
        ? formatCondition(alert.alertThreshold.conditions.first)
        : 'Sin descripción';
    final measurementType = _getMeasurementTypeLabel(alert.alertThreshold.measureType);

    // Apply different styling for read alerts
    final cardColor = alert.isRead ? Colors.grey[50] : Colors.white;
    final cardElevation = alert.isRead ? 1.0 : 2.0;
    final contentOpacity = alert.isRead ? 0.7 : 1.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: cardElevation,
      color: cardColor,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: alert.isRead 
            ? BorderSide(color: Colors.grey[300]!, width: 1) 
            : BorderSide.none,
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
                    // Condition
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.description_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Condición',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                formattedCondition,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Health data value
                    if (alert.healthDataPoint != null) ...[
                      const SizedBox(height: 12),
                      _buildHealthDataValue(
                        alert.healthDataPoint,
                        alert.alertThreshold.measureType,
                        severityColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (alert.isRead)
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Leída ${alert.readAt != null ? getTimeAgo(alert.readAt!) : ""}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showAlertDetails(alert, context),
                          icon: Icon(
                            Icons.visibility_outlined, 
                            size: 14, 
                            color: alert.isRead ? Colors.grey[600] : primaryColor
                          ),
                          label: Text(
                            'Ver detalles',
                            style: TextStyle(
                              fontSize: 13,
                              color: alert.isRead ? Colors.grey[600] : primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    // Adjust color opacity for read alerts
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _buildBadge(
                      text: 'Severidad: $severityText',
                      color: isRead ? Colors.grey[500]! : severityColor,
                      fontSize: 11,
                    ),
                    const SizedBox(width: 8),
                    if (!isRead)
                      _buildBadge(
                        text: 'Nueva',
                        color: primaryColor,
                        fontSize: 11,
                      ),
                    if (isRead)
                      _buildBadge(
                        text: 'Leída',
                        color: Colors.green[700]!,
                        fontSize: 11,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            DateFormat('dd/MM/yy').format(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color color,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildHealthDataValue(
    dynamic healthDataPoint,
    String measureType,
    Color severityColor,
  ) {
  
    final healthDataType = _getHealthDataType(measureType);
    final formattedValue = formatHealthDataValue(healthDataPoint, measureType);
    final iconData = _getIconForHealthDataType(healthDataType);
    final normalizedType = _getMeasurementTypeString(healthDataType);
    
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
            child: Icon(iconData, size: 16, color: severityColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '_type: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _getDataTypeName(healthDataType),
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
                      formattedValue,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: getValueColor(healthDataPoint['value'].toString(), normalizedType),
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

  // Widget _buildBloodPressureValue( dynamic healthDataPoint, Color severityColor ) {
  //   final value = healthDataPoint['value'].toString();
  //   final parts = value.split('/');
 
  //   int systolic = 0;
  //   int diastolic = 0;
    
  //   if (parts.length == 2) {
  //     try {
  //       systolic = int.parse(parts[0].trim());
  //       diastolic = int.parse(parts[1].trim());
  //     } catch (e) {
  //       // Use defaults if parsing fails
  //     }
  //   }
    
  //   // Determine colors based on values
  //   final systolicColor = getBloodPressureColor(systolic, true);
  //   final diastolicColor = getBloodPressureColor(diastolic, false);
    
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey[300]!, width: 1),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Type header
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(6),
  //               decoration: BoxDecoration(
  //                 color: severityColor.withOpacity(0.1),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(_getIconForHealthDataType(HealthDataType.BLOOD_PRESSURE_SYSTOLIC), size: 14, color: severityColor),
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               '_type: ${_getDataTypeName(HealthDataType.BLOOD_PRESSURE_SYSTOLIC)}',
  //               style: TextStyle(
  //                 fontSize: 11,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.grey[700],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         // Values
  //         Padding(
  //           padding: const EdgeInsets.only(left: 28),
  //           child: Row(
  //             children: [
  //               // Systolic
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'systolic:',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.grey[600],
  //                     ),
  //                   ),
  //                   Text(
  //                     '$systolic',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w700,
  //                       color: systolicColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(width: 24),
  //               // Diastolic
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'diastolic:',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.grey[600],
  //                     ),
  //                   ),
  //                   Text(
  //                     '$diastolic',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w700,
  //                       color: diastolicColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         // Reference ranges
  //         Padding(
  //           padding: const EdgeInsets.only(left: 28),
  //           child: Text(
  //             'Normal: <120 / <80',
  //             style: TextStyle(
  //               fontSize: 10,
  //               color: Colors.grey[500],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailHealthDataValue(
    dynamic healthDataPoint,
    String measureType,
    Color severityColor,
  ) {
    // Convert to HealthDataType for more robust comparison
    final healthDataType = _getHealthDataType(measureType);
    
    // For blood pressure, use specialized display
    if (healthDataType == HealthDataType.BLOOD_PRESSURE_SYSTOLIC || 
        healthDataType == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
      return _buildDetailBloodPressureValue(healthDataPoint, severityColor);
    }
    
    // For other measurement types
    final formattedValue = formatHealthDataValue(healthDataPoint, measureType);
    final normalRange = getNormalRangeForMeasurement(measureType);
    final valueColor = getValueColor(healthDataPoint['value'].toString(), measureType);
    final iconData = _getIconForHealthDataType(healthDataType);
    
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
          // Type header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, size: 18, color: severityColor),
              ),
              const SizedBox(width: 10),
              Text(
                '_type: ${_getDataTypeName(healthDataType)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Value
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Row(
              children: [
                Text(
                  'value: ',
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
          if (normalRange.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                'Rango normal: $normalRange',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailBloodPressureValue(
    dynamic healthDataPoint,
    Color severityColor,
  ) {
    final value = healthDataPoint['value'].toString();
    final parts = value.split('/');
    
    // Default values if parsing fails
    int systolic = 0;
    int diastolic = 0;
    
    // Try to parse values
    if (parts.length == 2) {
      try {
        systolic = int.parse(parts[0].trim());
        diastolic = int.parse(parts[1].trim());
      } catch (e) {
        // Use defaults if parsing fails
      }
    }
    
    // Determine colors based on values
    final systolicColor = getBloodPressureColor(systolic, true);
    final diastolicColor = getBloodPressureColor(diastolic, false);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconForHealthDataType(HealthDataType.BLOOD_PRESSURE_SYSTOLIC), size: 18, color: severityColor),
              ),
              const SizedBox(width: 12),
              Text(
                '_type: ${_getDataTypeName(HealthDataType.BLOOD_PRESSURE_SYSTOLIC)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Values
          Row(
            children: [
              // Systolic
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: systolicColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'systolic:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$systolic',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: systolicColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Normal: <120',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Diastolic
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: diastolicColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'diastolic:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$diastolic',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: diastolicColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Normal: <80',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Classification
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getOverallBloodPressureColor(systolic, diastolic).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: getOverallBloodPressureColor(systolic, diastolic).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                getBloodPressureClassification(systolic, diastolic),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: getOverallBloodPressureColor(systolic, diastolic),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate data type name based on HealthDataType 
  String _getDataTypeName(HealthDataType type) {
    return getDataTypeNameFromEnum(type);
  }
  
  /// Get icon for a specific HealthDataType
  IconData _getIconForHealthDataType(HealthDataType type) {
    return getIconForHealthDataType(type);
  }

  void _showAlertDetails(Alert alert, BuildContext context) {
    final (severityColor, severityIcon, severityText) = _getAlertSeverityInfo(alert.alertThreshold.severity);
    final formattedCondition = alert.alertThreshold.conditions.isNotEmpty 
        ? formatCondition(alert.alertThreshold.conditions.first)
        : 'Sin descripción';
    final measurementType = _getMeasurementTypeLabel(alert.alertThreshold.measureType);

    // Mark alert as read if it's not already read
    if (!alert.isRead) {
      _markAlertAsRead(alert);
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
                              color: severityColor,
                            ),
                          ),
                          Text(
                            'Severidad: $severityText',
                            style: const TextStyle(
                              fontSize: 13,
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
                    if (alert.healthDataPoint != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Valor registrado',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailHealthDataValue(
                        alert.healthDataPoint,
                        alert.alertThreshold.measureType,
                        severityColor,
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Future<void> _markAlertAsRead(Alert alert) async {
    try {
      final doctor = Brain.to.currentDoctor.value;    
      final alertId = alert.id.toString();
      
      await alertRepository.markAsRead(alertId, doctor!.id!);
      
      final index = alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        final updatedAlert = Alert(
          id: alert.id,
          patientId: alert.patientId,
          healthDataPoint: alert.healthDataPoint,
          alertThreshold: alert.alertThreshold,
          createdAt: alert.createdAt,
          isRead: true,
          readAt: DateTime.now(),
          readByDoctorId: doctor.id.toString(),
        );
        alerts[index] = updatedAlert;
      }
      
      // Show success message
      Get.snackbar(
        'Éxito',
        'Alerta marcada como leída correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo marcar la alerta como leída en este momento. Intente nuevamente más tarde.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Helper methods
  _getAlertSeverityInfo(String severity) {
    return AlertThresholdsComponents.getAlertSeverityInfo(severity);
  }

  String _getMeasurementTypeLabel(String measureType) {
    return AlertThresholdsComponents.getMeasurementTypeLabel(measureType);
  }

  /// Convert a string measurement type to HealthDataType enum
  HealthDataType _getHealthDataType(String measureType) {
    return getHealthDataTypeFromString(measureType);
  }
  
  /// Get the standardized measurement type string from a HealthDataType
  String _getMeasurementTypeString(HealthDataType healthDataType) {
    return healthDataType.name;
  }
  
  /// Get a list of all available health data types for the UI
  List<Map<String, String>> _getAllHealthDataTypeOptions() {
    return [
      {'value': _getMeasurementTypeString(HealthDataType.HEART_RATE), 'label': 'Ritmo Cardíaco'},
      {'value': _getMeasurementTypeString(HealthDataType.BLOOD_PRESSURE), 'label': 'Presión Arterial'},
      {'value': _getMeasurementTypeString(HealthDataType.BLOOD_OXYGEN), 'label': 'Oxígeno en Sangre'},
      {'value': _getMeasurementTypeString(HealthDataType.BODY_TEMPERATURE), 'label': 'Temperatura'},
      {'value': _getMeasurementTypeString(HealthDataType.BLOOD_GLUCOSE), 'label': 'Glucosa'},
      {'value': _getMeasurementTypeString(HealthDataType.WEIGHT), 'label': 'Peso'},
      {'value': _getMeasurementTypeString(HealthDataType.SLEEP_IN_BED), 'label': 'Sueño'},
      {'value': _getMeasurementTypeString(HealthDataType.STEPS), 'label': 'Pasos'},
      {'value': 'vas', 'label': 'Escala de Dolor'}, // Special case not in HealthDataType
    ];
  }

  Widget _buildThresholdsEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tune_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No hay umbrales de alerta personalizados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Puede crear umbrales personalizados para este paciente',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateThresholdDialog,
            icon: const Icon(Icons.add),
            label: const Text('Crear nivel de alerta'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdCard(AlertThreshold threshold, BuildContext context) {
    final (severityColor, severityIcon, severityText) = _getAlertSeverityInfo(threshold.severity);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with color based on severity
          _buildCardHeader(
            severityColor: severityColor,
            severityIcon: severityIcon,
            severityText: severityText,
            measurementType: _getMeasurementTypeLabel(threshold.measureType),
            isRead: true, // Thresholds don't have read state
            date: DateTime.now(), // Thresholds don't have date
            primaryColor: Theme.of(context).primaryColor,
          ),
          // Card body with conditions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Severity indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(severityIcon, size: 16, color: severityColor),
                      const SizedBox(width: 4),
                      Text(
                        'Severidad: $severityText',
                        style: TextStyle(
                          color: severityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),         
                const SizedBox(height: 16),

                const Text(
                  'Condiciones:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...threshold.conditions.map((condition) {
                  final formattedCondition = AlertThresholdsComponents.formatCondition(condition);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      formattedCondition,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          // Card actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit button
                OutlinedButton.icon(
                  onPressed: () => _editThreshold(threshold),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                OutlinedButton.icon(
                  onPressed: () => _deleteThreshold(threshold),
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editThreshold(AlertThreshold threshold) {
    _showThresholdDialog(threshold: threshold);
  }

  void _deleteThreshold(AlertThreshold threshold) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nivel de alerta'),
        content: Text('¿Está seguro que desea eliminar este nivel de alerta para "${_getMeasurementTypeLabel(threshold.measureType)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await thresholdRepository.deleteAlertThreshold(threshold.id);
                thresholds.removeWhere((t) => t.id == threshold.id);
                Get.snackbar(
                  'Éxito', 
                  'nivel de alerta eliminado correctamente',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green[100],
                  colorText: Colors.green[900],
                );
              } catch (e) {
                Get.snackbar(
                  'Error', 
                  'No se pudo eliminar el nivel de alerta: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[900],
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateThresholdDialog() {
    _showThresholdDialog();
  }

  void _showThresholdDialog({AlertThreshold? threshold}) {
    final isEditing = threshold != null;
    final measureTypeController = TextEditingController(
      text: threshold?.measureType ?? _getMeasurementTypeString(HealthDataType.HEART_RATE)
    );
    final severityController = TextEditingController(
      text: threshold?.severity ?? 'medium'
    );
    
    // Parse existing conditions or set defaults
    String existingCondition = threshold?.conditions.isNotEmpty == true 
        ? threshold!.conditions.first 
        : "x['value'] > 100";
    
    debugPrint('Parsing condition: $existingCondition');
    
    // Default values for condition builders
    String selectedField = 'value';
    String selectedOperator = '>';
    String selectedValue = '100';
    String secondaryField = 'value';
    String secondaryOperator = '<';
    String secondaryValue = '60';
    bool useSecondaryCondition = false;
    
    // Parse existing condition if available
    if (existingCondition.contains(' or ')) {
      useSecondaryCondition = true;
      final parts = existingCondition.split(' or ');
      
      // Parse primary condition
      AlertThresholdsComponents.parseCondition(parts[0], (field, operator, value) {
        selectedField = field;
        selectedOperator = operator;
        selectedValue = value;
      });
      
      // Parse secondary condition
      AlertThresholdsComponents.parseCondition(parts[1], (field, operator, value) {
        secondaryField = field;
        secondaryOperator = operator;
        secondaryValue = value;
      });
    } else {
      AlertThresholdsComponents.parseCondition(existingCondition, (field, operator, value) {
        selectedField = field;
        selectedOperator = operator;
        selectedValue = value;
      });
    }
    
    // Reactive values for the UI
    final measureType = measureTypeController.text.obs;
    final selectedFieldRx = selectedField.obs;
    final selectedOperatorRx = selectedOperator.obs;
    final selectedValueRx = selectedValue.obs;
    final secondaryFieldRx = secondaryField.obs;
    final secondaryOperatorRx = secondaryOperator.obs;
    final secondaryValueRx = secondaryValue.obs;
    final useSecondaryConditionRx = useSecondaryCondition.obs;
    
    // Use our new utility function to get consistent health data type options
    final measureTypeOptions = _getAllHealthDataTypeOptions();
    
    // List of severity options with user-friendly labels
    final severityOptions = [
      {'value': 'low', 'label': 'Baja'},
      {'value': 'medium', 'label': 'Media'},
      {'value': 'high', 'label': 'Alta'},
    ];
    
    // Create a formatted title
    final String title = isEditing 
        ? 'Editar nivel para ${_getMeasurementTypeLabel(threshold.measureType)}' 
        : 'Crear nuevo nivel de alerta';
    
    // Show a form in dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: AlertThresholdsComponents.buildThresholdDialogContent(
          context: context,
          measureTypeController: measureTypeController,
          severityController: severityController,
          measureType: measureType,
          selectedField: selectedFieldRx,
          selectedOperator: selectedOperatorRx,
          selectedValue: selectedValueRx,
          secondaryField: secondaryFieldRx,
          secondaryOperator: secondaryOperatorRx,
          secondaryValue: secondaryValueRx,
          useSecondaryCondition: useSecondaryConditionRx,
          measureTypeOptions: measureTypeOptions,
          severityOptions: severityOptions,
          isEditing: isEditing,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Build final condition string
              final conditionString = AlertThresholdsComponents.buildConditionString(
                field: selectedFieldRx.value, 
                operator: selectedOperatorRx.value, 
                value: selectedValueRx.value,
                useSecondary: useSecondaryConditionRx.value,
                secondaryField: secondaryFieldRx.value,
                secondaryOperator: secondaryOperatorRx.value,
                secondaryValue: secondaryValueRx.value,
              );
              
              final conditions = [conditionString];
              
              try {
                if (isEditing) {
                  final updatedThreshold = AlertThreshold(
                    id: threshold.id,
                    patientId: patient.id,
                    measureType: threshold.measureType,
                    severity: severityController.text,
                    conditions: conditions,
                  );
                  
                  final result = await thresholdRepository.updateAlertThreshold(
                    threshold.id, 
                    updatedThreshold
                  );
                  final index = thresholds.indexWhere((t) => t.id == threshold.id);
                  if (index >= 0) {
                    thresholds[index] = result;
                  }
                  Get.snackbar(
                    'Éxito', 
                    'nivel de alerta actualizado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green[100],
                    colorText: Colors.green[900],
                  );
                } else {
                  // Create new threshold with a temporary ID
                  final newThreshold = AlertThreshold(
                    id: 0, // Temporary ID
                    patientId: patient.id,
                    measureType: measureTypeController.text,
                    severity: severityController.text,
                    conditions: conditions,
                  );
                  
                  final result = await thresholdRepository.createAlertThreshold(newThreshold);
                  thresholds.add(result);
                  
                  Get.snackbar(
                    'Éxito', 
                    'nivel de alerta creado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green[100],
                    colorText: Colors.green[900],
                  );
                }
                
                Navigator.of(context).pop();
              } catch (e) {
                Get.snackbar(
                  'Error', 
                  'No se pudo ${isEditing ? 'actualizar' : 'crear'} el nivel de alerta: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[900],
                );
              }
            },
            child: Text(isEditing ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }
} 