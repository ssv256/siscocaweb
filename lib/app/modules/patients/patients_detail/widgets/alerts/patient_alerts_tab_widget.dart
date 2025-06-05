import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/models/models.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_threshold_impl_rep.dart';
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';
import './alerts_controller.dart';
import './alerts_list_widget.dart';
import './thresholds_list_widget.dart';

class PatientAlertsTabWidget extends StatefulWidget {
  const PatientAlertsTabWidget({super.key});

  @override
  State<PatientAlertsTabWidget> createState() => _PatientAlertsTabWidgetState();
}

class _PatientAlertsTabWidgetState extends State<PatientAlertsTabWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RxInt currentTabIndex = 0.obs;
  late User patient;
  late AlertsController alertsController;
  final AlertThresholdRepositoryImpl thresholdRepository = Get.find<AlertThresholdRepositoryImpl>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    patient = Get.arguments as User;
    
    // Inicializar el controlador
    alertsController = AlertsController(
      alertRepository: Get.find<AlertRepositoryImpl>(),
      thresholdRepository: Get.find<AlertThresholdRepositoryImpl>(),
    );
    
    // Establecer el paciente y cargar los datos
    alertsController.setPatient(patient);
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

  void _showCreateThresholdDialog() {
    _showThresholdDialog();
  }
  
  void _showThresholdDialog({AlertThreshold? threshold}) {
    final isEditing = threshold != null;
    
    final measureTypeController = TextEditingController(
      text: threshold?.measureType ?? 'HEART_RATE'
    );
    final severityController = TextEditingController(
      text: threshold?.severity ?? 'medium'
    );
    
    // Parse existing conditions or set defaults
    String existingCondition = threshold?.conditions.isNotEmpty == true 
        ? threshold!.conditions.first 
        : "x['value'] > 100";
    
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
    
    // List of measure types with user-friendly labels
    final measureTypeOptions = [
      {'value': 'HEART_RATE', 'label': 'Ritmo Cardíaco'},
      {'value': 'BLOOD_PRESSURE', 'label': 'Presión Arterial'},
      {'value': 'BLOOD_OXYGEN', 'label': 'Oxígeno en Sangre'},
      {'value': 'BODY_TEMPERATURE', 'label': 'Temperatura'},
      {'value': 'BLOOD_GLUCOSE', 'label': 'Glucosa'},
      {'value': 'WEIGHT', 'label': 'Peso'},
      {'value': 'SLEEP_IN_BED', 'label': 'Sueño'},
      {'value': 'STEPS', 'label': 'Pasos'},
    ];
    
    // List of severity options with user-friendly labels
    final severityOptions = [
      {'value': 'low', 'label': 'Baja'},
      {'value': 'medium', 'label': 'Media'},
      {'value': 'high', 'label': 'Alta'},
    ];
    
    // Create a formatted title
    final String title = isEditing 
        ? 'Editar nivel para ${AlertThresholdsComponents.getMeasurementTypeLabel(threshold.measureType)}' 
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
              
              // Create or update threshold
              try {
                if (isEditing) {
                  final updatedThreshold = AlertThreshold(
                    id: threshold.id,
                    patientId: patient.id,
                    measureType: threshold.measureType,
                    severity: severityController.text,
                    conditions: conditions,
                  );
                  
                  await thresholdRepository.updateAlertThreshold(
                    threshold.id, 
                    updatedThreshold
                  );
                  
                  Get.snackbar(
                    'Éxito', 
                    'Nivel de alerta actualizado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green[100],
                    colorText: Colors.green[900],
                  );
                } else {
                  // Create new threshold with a temporary ID
                  // The backend will assign the actual ID
                  final newThreshold = AlertThreshold(
                    id: 0, // Temporary ID
                    patientId: patient.id,
                    measureType: measureTypeController.text,
                    severity: severityController.text,
                    conditions: conditions,
                  );
                  
                  await thresholdRepository.createAlertThreshold(newThreshold);
                  
                  Get.snackbar(
                    'Éxito', 
                    'Nivel de alerta creado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green[100],
                    colorText: Colors.green[900],
                  );
                }
                
                // Reload thresholds after creating/updating
                alertsController.loadThresholds();
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
                // Tab de Alertas
                AlertsListWidget(controller: alertsController),
                
                // Tab de Umbrales
                ThresholdsListWidget(
                  controller: alertsController, 
                  onCreateThreshold: _showCreateThresholdDialog,
                  onEditThreshold: (threshold) => _showThresholdDialog(threshold: threshold),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        // Solo mostrar el FAB en la pestaña de umbrales
        if (currentTabIndex.value == 1) {
          return FloatingActionButton(
            onPressed: _showCreateThresholdDialog,
            child: const Icon(Icons.add),
            tooltip: 'Crear nuevo nivel de alerta',
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
} 