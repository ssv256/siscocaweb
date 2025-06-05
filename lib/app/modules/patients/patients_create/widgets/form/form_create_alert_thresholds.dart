import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/controllers/patients_create_controller.dart';
import 'package:domain/models/alerts/alerts_threshold.dart';
import 'package:siscoca/app/modules/patients/patients_create/widgets/submit_button.dart';
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';

class FormCreateAlertThresholds extends GetView<PatientsCreateController> {
  const FormCreateAlertThresholds({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildAlertThresholdsList(),
                const SizedBox(height: 30),
                FormSubmitButton(
                  formKey: _formKey,
                  onSubmit: controller.validateAndContinue,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurar Alertas Personalizadas',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure umbrales de alerta personalizados para este paciente. Las alertas se generarán cuando las mediciones superen estos umbrales.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _showAddAlertThresholdDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Agregar Umbral de Alerta'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertThresholdsList() {
    return Obx(() {
      final thresholds = controller.personalizedAlertThresholds;
      
      if (thresholds.isEmpty) {
        return _buildEmptyState();
      }
      
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: thresholds.length,
        itemBuilder: (context, index) => _buildAlertThresholdCard(thresholds[index], index, context),
      );
    });
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey[500]),
          const SizedBox(height: 16),
          Text(
            'No hay umbrales configurados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agregue umbrales de alerta para recibir notificaciones cuando los valores del paciente estén fuera del rango normal.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddAlertThresholdDialog(Get.context!),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Umbral de Alerta'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertThresholdCard(AlertThreshold threshold, int index, BuildContext context) {
    // Get severity color
    final (severityColor, severityIcon, _) = AlertThresholdsComponents.getAlertSeverityInfo(threshold.severity);
    
    // Get user-friendly display name
    String measureTypeDisplay = AlertThresholdsComponents.getMeasurementTypeLabel(threshold.measureType);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: severityColor.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: severityColor),
                      ),
                      child: Text(
                        threshold.severity.toUpperCase(),
                        style: TextStyle(
                          color: severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      measureTypeDisplay,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditAlertThresholdDialog(context, threshold, index),
                      tooltip: 'Editar',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteAlertThreshold(context, index),
                      tooltip: 'Eliminar',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Condiciones:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            ...threshold.conditions.map((condition) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                '• ${AlertThresholdsComponents.formatCondition(condition)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _showAddAlertThresholdDialog(BuildContext context) {
    _showAlertThresholdDialog(context, null, -1);
  }

  void _showEditAlertThresholdDialog(BuildContext context, AlertThreshold threshold, int index) {
    _showAlertThresholdDialog(context, threshold, index);
  }

  void _showAlertThresholdDialog(BuildContext context, AlertThreshold? existingThreshold, int index) {
    // debugPrint debug info
    if (existingThreshold != null) {
      debugPrint('Editing threshold: ${existingThreshold.id}, type: ${existingThreshold.measureType}, conditions: ${existingThreshold.conditions}');
    }
    
    // Setup controllers
    final measureTypeController = TextEditingController(
      text: existingThreshold?.measureType ?? 'BLOOD_PRESSURE'
    );
    final severityController = TextEditingController(
      text: existingThreshold?.severity ?? 'warning'
    );
    
    // Parse existing conditions or set defaults
    String existingCondition = existingThreshold?.conditions.isNotEmpty == true 
        ? existingThreshold!.conditions.first 
        : "x['systolic'] > 140";
    
    debugPrint('Parsing condition: $existingCondition');
    
    // Default values for condition builders
    String selectedField = 'systolic';
    String selectedOperator = '>';
    String selectedValue = '140';
    String secondaryField = 'diastolic';
    String secondaryOperator = '>';
    String secondaryValue = '90';
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

    // Define options
    final measureTypeOptions = [
      {'value': 'BLOOD_PRESSURE', 'label': 'Presión Arterial'},
      {'value': 'HEART_RATE', 'label': 'Ritmo Cardíaco'},
      {'value': 'OXYGEN_SATURATION', 'label': 'Oxígeno en Sangre'},
      {'value': 'VAS', 'label': 'Escala de Dolor'},
    ];

    final severityOptions = [
      {'value': 'warning', 'label': 'MEDIA'},
      {'value': 'high', 'label': 'ALTA'},
      {'value': 'low', 'label': 'BAJA'},
    ];

    // Show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingThreshold == null ? 'Agregar Alerta Personalizada' : 'Editar Alerta Personalizada'),
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
          isEditing: existingThreshold != null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
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
              
              final threshold = AlertThreshold(
                id: existingThreshold?.id ?? 0, // ID will be assigned by backend
                patientId: controller.patient.value?.id != null ? controller.patient.value!.id : null,
                measureType: measureTypeController.text,
                severity: severityController.text,
                conditions: conditions,
              );

              if (index >= 0) {
                controller.updatePersonalizedAlertThreshold(index, threshold);
              } else {
                controller.addPersonalizedAlertThreshold(threshold);
              }

              Navigator.of(context).pop();
            },
            child: Text(existingThreshold == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAlertThreshold(BuildContext context, int index) {
    final AlertThreshold threshold = controller.personalizedAlertThresholds[index];
    final String measureTypeDisplay = AlertThresholdsComponents.getMeasurementTypeLabel(threshold.measureType);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar el umbral de alerta para "$measureTypeDisplay"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.removePersonalizedAlertThreshold(index);
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 