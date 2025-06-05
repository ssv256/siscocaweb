import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';

/// A utility class providing shared components and methods for managing alert thresholds
/// Used by both PatientAlertsTab and FormCreateAlertThresholds
class AlertThresholdsComponents {
  /// Parse a condition string into its components
  static void parseCondition(String condition, Function(String, String, String) callback) {
    try {
      // Remove x[] and spaces
      condition = condition.trim();

      final fieldMatch = RegExp(r"x\['([^']+)'\]").firstMatch(condition);
      final field = fieldMatch != null ? fieldMatch.group(1) ?? 'value' : 'value';
      String operator = '>';
      for (final op in ['>=', '<=', '==', '>', '<']) {
        if (condition.contains(op)) {
          operator = op;
          break;
        }
      }
      
      // Extract value
      final parts = condition.split(operator);
      if (parts.length > 1) {
        final valueStr = parts[1].trim();
        callback(field, operator, valueStr);
      } else {

        String defaultValue = '0';
        if (field == 'systolic') defaultValue = '140';
        else if (field == 'diastolic') defaultValue = '90';
        else if (field == 'value') {
          // Set appropriate default based on context
          if (condition.toLowerCase().contains('heart')) defaultValue = '100';
          else if (condition.toLowerCase().contains('oxygen')) defaultValue = '95';
          else if (condition.toLowerCase().contains('temperature')) defaultValue = '37.5';
          else if (condition.toLowerCase().contains('glucose')) defaultValue = '180';
        }
        
        callback(field, operator, defaultValue);
      }
    } catch (e) {
      debugPrint('Error parsing condition: $e');
      // Provide safe defaults
      callback('value', '>', '100');
    }
  }
  
  static String buildConditionString({
    required String field, 
    required String operator, 
    required String value,
    required bool useSecondary,
    required String secondaryField,
    required String secondaryOperator,
    required String secondaryValue,
  }) {
    final primary = "x['$field'] $operator $value";
    if (useSecondary) {
      return "$primary or x['$secondaryField'] $secondaryOperator $secondaryValue";
    }
    return primary;
  }
  
  /// Build a condition selector UI component
  static Widget buildConditionSelector({
    required String measureType,
    required Rx<String> selectedField,
    required Rx<String> selectedOperator,
    required Rx<String> selectedValue,
    required List<String> operators,
    required Map<String, String> Function(String) getFieldOptions,
    required List<String> Function(String, String) getDefaultValues,
    Rx<String>? secondaryField,
  }) {
 
    
    final fieldOptions = getFieldOptions(measureType);
    final defaultValues = getDefaultValues(measureType, selectedField.value);
    
    if (!defaultValues.contains(selectedValue.value)) {
      defaultValues.add(selectedValue.value);
    }
    
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: selectedField.value,
            decoration: const InputDecoration(
              labelText: 'Campo',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            items: fieldOptions.entries.map((entry) => DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedField.value = value;
                
                // For blood pressure, ensure secondary field is different
                if (measureType == 'BLOOD_PRESSURE' && secondaryField != null) {
                  // If both fields would be the same, switch the secondary field
                  if (value == secondaryField.value) {
                    secondaryField.value = (value == 'systolic') ? 'diastolic' : 'systolic';
                  }
                }
                
                // Get new default values for the selected field
                final newDefaultValues = getDefaultValues(measureType, value);
                // Set value to appropriate default
                selectedValue.value = newDefaultValues.isNotEmpty ? newDefaultValues.first : '0';
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        // Operator selector
        Expanded(
          flex: 2,
          child: Obx(() => DropdownButtonFormField<String>(
            value: selectedOperator.value,
            decoration: const InputDecoration(
              labelText: 'Operador',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            items: operators.map((op) => DropdownMenuItem(
              value: op,
              child: Text(op),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedOperator.value = value;
              }
            },
          )),
        ),
        const SizedBox(width: 8),
        // Value selector
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: selectedValue.value,
            decoration: const InputDecoration(
              labelText: 'Valor',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            items: defaultValues.map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedValue.value = value;
              }
            },
          ),
        ),
      ],
    );
  }

  /// Format a condition for readability
  static String formatCondition(String condition) {
    if (condition.isEmpty) return 'Sin condición';
    
    if (condition.contains(' or ')) {
      final parts = condition.split(' or ');
      return '${formatSingleCondition(parts[0])}\nO\n${formatSingleCondition(parts[1])}';
    } else {
      return formatSingleCondition(condition);
    }
  }
  
  /// Format a single condition for readability
  static String formatSingleCondition(String condition) {
    // Replace x['field'] with a more readable format
    condition = condition
      .replaceAll("x['", "")
      .replaceAll("']", "")
      .replaceAll(" > ", " mayor que ")
      .replaceAll(" < ", " menor que ")
      .replaceAll(" >= ", " mayor o igual que ")
      .replaceAll(" <= ", " menor o igual que ")
      .replaceAll(" == ", " igual a ");
    
    // Capitalize first letter
    if (condition.isNotEmpty) {
      condition = condition[0].toUpperCase() + condition.substring(1);
    }
    
    return condition;
  }

  /// Get alert severity information (color, icon, text)
  static (Color, IconData, String) getAlertSeverityInfo(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return (Colors.red, Icons.warning_amber_rounded, 'Alta');
      case 'medium':
      case 'warning':
        return (Colors.orange, Icons.warning_outlined, 'Media');
      case 'low':
        return (Colors.blue, Icons.info_outline, 'Baja');
      default:
        return (Colors.blue, Icons.info_outline, 'Baja');
    }
  }

  /// Get measurement type label
  static String getMeasurementTypeLabel(String measureType) {
    // Get health data type
    final healthDataType = _getHealthDataType(measureType);
    
    switch (healthDataType) {
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return 'Presión Arterial';
      case HealthDataType.HEART_RATE:
        return 'Ritmo Cardíaco';
      case HealthDataType.BLOOD_OXYGEN:
        return 'Oxígeno en Sangre';
      case HealthDataType.WEIGHT:
        return 'Peso';
      case HealthDataType.BODY_TEMPERATURE:
        return 'Temperatura';
      case HealthDataType.BLOOD_GLUCOSE:
        return 'Glucosa';
      case HealthDataType.STEPS:
        return 'Pasos';
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
      case HealthDataType.SLEEP_DEEP:
      case HealthDataType.SLEEP_LIGHT:
      case HealthDataType.SLEEP_REM:
        return 'Sueño';
      case HealthDataType.WORKOUT:
        return 'Ejercicio';
      case HealthDataType.MINDFULNESS:
        return 'Estado de ánimo';
      case HealthDataType.HEIGHT:
        return 'Altura';
      default:
        // Handle special cases without normalizing case
        if (measureType == 'symptom' || measureType == 'SYMPTOM' || measureType == 'Symptom') {
          return 'Sintomatología';
        } else if (measureType == 'vas' || measureType == 'VAS' || measureType == 'Vas') {
          return 'Escala de Dolor';
        }
        return measureType;
    }
  }

  /// Convert string type to HealthDataType
  static HealthDataType _getHealthDataType(String measureType) {
    
    switch (measureType) {
      case 'BLOOD_PRESSURE':
        return HealthDataType.BLOOD_PRESSURE_SYSTOLIC; // Using systolic as representative for blood pressure
      case 'HEART_RATE':
        return HealthDataType.HEART_RATE;
      case 'BLOOD_OXYGEN':
      case 'OXYGEN_SATURATION':
        return HealthDataType.BLOOD_OXYGEN;
      case 'WEIGHT':
        return HealthDataType.WEIGHT;
      case 'BODY_TEMPERATURE':
        return HealthDataType.BODY_TEMPERATURE;
      case 'BLOOD_GLUCOSE':
        return HealthDataType.BLOOD_GLUCOSE;
      case 'STEPS':
        return HealthDataType.STEPS;
      case 'SLEEP_IN_BED':
        return HealthDataType.SLEEP_IN_BED;
      case 'SLEEP_ASLEEP':
        return HealthDataType.SLEEP_ASLEEP;
      case 'WORKOUT':
        return HealthDataType.WORKOUT;
      case 'MOOD':
        return HealthDataType.MOOD;
      case 'MINDFULNESS':
        return HealthDataType.MINDFULNESS;
      case 'HEIGHT':
        return HealthDataType.HEIGHT;
      case 'SYMPTOM':
        return HealthDataType.SYMPTOM;
      default:
        return HealthDataType.HEART_RATE; 
    }
  }

  /// Get measurement type icon
  static IconData getMeasurementTypeIcon(String measureType) {
    // Convert string to HealthDataType
    final healthDataType = _getHealthDataType(measureType);
    
    // Assign icons based on HealthDataType
    switch (healthDataType) {
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return Icons.favorite_outline;
      case HealthDataType.HEART_RATE:
        return Icons.favorite;
      case HealthDataType.BLOOD_OXYGEN:
        return Icons.water_drop;
      case HealthDataType.WEIGHT:
        return Icons.monitor_weight;
      case HealthDataType.BODY_TEMPERATURE:
        return Icons.thermostat;
      case HealthDataType.BLOOD_GLUCOSE:
        return Icons.science;
      case HealthDataType.STEPS:
        return Icons.directions_walk;
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
      case HealthDataType.SLEEP_DEEP:
      case HealthDataType.SLEEP_LIGHT:
      case HealthDataType.SLEEP_REM:
        return Icons.hotel;
      case HealthDataType.WORKOUT:
        return Icons.fitness_center_outlined;
      case HealthDataType.MINDFULNESS:
        return Icons.mood_outlined;
      case HealthDataType.HEIGHT:
        return Icons.height_outlined;
      default:
        // Handle special cases that don't map directly to HealthDataType
        // Do not normalize letter case here
        if (measureType == 'symptom' || measureType == 'SYMPTOM' || measureType == 'Symptom') {
          return Icons.sick_outlined;
        } else if (measureType == 'vas' || measureType == 'VAS' || measureType == 'Vas') {
          return Icons.scale_outlined;
        }
        return Icons.healing;
    }
  }

  /// Common field options for different measurement types
  static Map<String, String> getFieldOptions(String measureType) {
    final healthDataType = _getHealthDataType(measureType);
    
    // Special case for blood pressure which has multiple fields
    if (healthDataType == HealthDataType.BLOOD_PRESSURE_SYSTOLIC || 
        healthDataType == HealthDataType.BLOOD_PRESSURE_DIASTOLIC ||
        measureType == 'BLOOD_PRESSURE') {
      return {
        'systolic': 'Sistólica',
        'diastolic': 'Diastólica',
      };
    }
    
    // For most health data types, we just need a 'value' field
    return {
      'value': 'Valor',
    };
  }
  
  /// Common default values for different measurement types and fields
  static List<String> getDefaultValues(String measureType, String field) {

    final healthDataType = _getHealthDataType(measureType);
    if (measureType == 'BLOOD_PRESSURE') {
      if (field == 'systolic') {
        return ['120', '130', '140', '150', '160', '170', '180'];
      } else if (field == 'diastolic') {
        return ['80', '85', '90', '95', '100', '110'];
      }
    }
    // Use HealthDataType for other measurements
    switch (healthDataType) {
      case HealthDataType.HEART_RATE:
        return ['60', '70', '80', '90', '100', '110', '120'];
      case HealthDataType.BLOOD_OXYGEN:
        return ['100', '98', '95', '92', '90', '88', '85'];
      case HealthDataType.BODY_TEMPERATURE:
        return ['36.0', '36.5', '37.0', '37.5', '38.0', '38.5', '39.0'];
      case HealthDataType.BLOOD_GLUCOSE:
        return ['70', '100', '140', '180', '200', '250', '300'];
      case HealthDataType.WEIGHT:
        return ['50', '60', '70', '80', '90', '100', '110', '120'];
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_DEEP:
        return ['4', '5', '6', '7', '8', '9', '10'];
      case HealthDataType.STEPS:
        return ['1000', '3000', '5000', '7000', '10000', '15000', '20000'];
      case HealthDataType.HEIGHT:
        return ['150', '160', '170', '180', '190', '200'];
      default:
        // Handle special cases not directly mapped to HealthDataType
        // Do not normalize letter case here
        if (measureType == 'vas' || measureType == 'VAS' || measureType == 'Vas') {
          return ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
        }
        return ['0', '50', '100', '150', '200'];
    }
  }
  
  /// Common operators for condition building
  static List<String> getCommonOperators() {
    return [
      '>',
      '>=',
      '<',
      '<=',
      '==',
    ];
  }
  
  /// Build a threshold dialog UI 
  static Widget buildThresholdDialogContent({
    required BuildContext context,
    required TextEditingController measureTypeController,
    required TextEditingController severityController,
    required Rx<String> measureType,
    required Rx<String> selectedField,
    required Rx<String> selectedOperator,
    required Rx<String> selectedValue,
    required Rx<String> secondaryField,
    required Rx<String> secondaryOperator,
    required Rx<String> secondaryValue,
    required RxBool useSecondaryCondition,
    required List<Map<String, String>> measureTypeOptions,
    required List<Map<String, String>> severityOptions,
    required bool isEditing,
  }) {
    final operators = getCommonOperators();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de medición',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton<String>(
                value: measureType.value,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                borderRadius: BorderRadius.circular(8),
                items: measureTypeOptions.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
                onChanged: isEditing ? null : (value) {
                  if (value != null) {
                    measureTypeController.text = value;
                    measureType.value = value;
                    
                    // Get HealthDataType for the selected measure type
                    final healthDataType = _getHealthDataType(value);

                    if (value == 'BLOOD_PRESSURE') {
                      selectedField.value = 'systolic';
                      secondaryField.value = 'diastolic';
                      selectedValue.value = '140';
                      secondaryValue.value = '90';
                      selectedOperator.value = '>';
                      secondaryOperator.value = '>';
                      // Make sure we always use both conditions for blood pressure
                      useSecondaryCondition.value = true;
                    } else {
                      selectedField.value = 'value';
                      secondaryField.value = 'value';
                      selectedOperator.value = '>';
                      
                      // Set appropriate default values based on HealthDataType
                      switch (healthDataType) {
                        case HealthDataType.HEART_RATE:
                          selectedValue.value = '100';
                          secondaryValue.value = '60';
                          secondaryOperator.value = '>';
                          break;
                        case HealthDataType.BLOOD_OXYGEN:
                          selectedValue.value = '95';
                          selectedOperator.value = '>';
                          secondaryValue.value = '90';
                          secondaryOperator.value = '>';
                          break;
                        case HealthDataType.BODY_TEMPERATURE:
                          selectedValue.value = '37.5';
                          secondaryValue.value = '36';
                          secondaryOperator.value = '>';
                          break;
                        case HealthDataType.BLOOD_GLUCOSE:
                          selectedValue.value = '180';
                          secondaryValue.value = '70';
                          secondaryOperator.value = '>';
                          break;
                        case HealthDataType.WEIGHT:
                          selectedValue.value = '100';
                          secondaryValue.value = '50';
                          secondaryOperator.value = '<';
                          break;
                        case HealthDataType.SLEEP_IN_BED:
                          selectedValue.value = '8';
                          selectedOperator.value = '<';
                          secondaryValue.value = '4';
                          secondaryOperator.value = '>';
                          break;
                        case HealthDataType.STEPS:
                          selectedValue.value = '10000';
                          selectedOperator.value = '<';
                          secondaryValue.value = '5000';
                          secondaryOperator.value = '<';
                          break;
                        default:
                          selectedValue.value = '100';
                          secondaryValue.value = '50';
                          secondaryOperator.value = '<';
                          break;
                      }
                    }
                  }
                },
              )),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Severidad',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: severityController.text,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                borderRadius: BorderRadius.circular(8),
                items: severityOptions.map((severity) {
                  return DropdownMenuItem<String>(
                    value: severity['value'],
                    child: Text(severity['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    severityController.text = value;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Condiciones de Alerta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => buildConditionSelector(
            measureType: measureType.value,
            selectedField: selectedField,
            selectedOperator: selectedOperator,
            selectedValue: selectedValue,
            operators: operators,
            getFieldOptions: getFieldOptions,
            getDefaultValues: getDefaultValues,
            secondaryField: secondaryField,
          )),
          const SizedBox(height: 8),
          Obx(() => CheckboxListTile(
            title: const Text('Agregar condición secundaria (OR)'),
            value: useSecondaryCondition.value,
            onChanged: (value) => useSecondaryCondition.value = value ?? false,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          )),
          Obx(() => useSecondaryCondition.value 
            ? Column(
                children: [
                  const SizedBox(height: 8),
                  buildConditionSelector(
                    measureType: measureType.value,
                    selectedField: secondaryField,
                    selectedOperator: secondaryOperator,
                    selectedValue: secondaryValue,
                    operators: operators,
                    getFieldOptions: getFieldOptions,
                    getDefaultValues: getDefaultValues,
                    secondaryField: selectedField,
                  ),
                ],
              ) 
            : const SizedBox.shrink()
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            'Vista previa: ${buildConditionString(
              field: selectedField.value, 
              operator: selectedOperator.value, 
              value: selectedValue.value,
              useSecondary: useSecondaryCondition.value,
              secondaryField: secondaryField.value,
              secondaryOperator: secondaryOperator.value,
              secondaryValue: secondaryValue.value,
            )}',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          )),
        ],
      ),
    );
  }
} 