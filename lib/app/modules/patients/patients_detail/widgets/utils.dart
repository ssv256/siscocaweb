// Format condition to be more readable
import 'package:flutter/material.dart';
import 'package:health/health.dart';

String formatCondition(String condition) {
    if (condition.isEmpty) return 'Sin condición';
    
    condition = condition
      .replaceAll("x['", "")
      .replaceAll("']", "")
      .replaceAll(" > ", " mayor que ")
      .replaceAll(" < ", " menor que ")
      .replaceAll(" >= ", " mayor o igual que ")
      .replaceAll(" <= ", " menor o igual que ")
      .replaceAll(" == ", " igual a ")
      .replaceAll(" or ", " o ")
      .replaceAll(" and ", " y ");
    
    // Capitalize first letter
    if (condition.isNotEmpty) {
      condition = condition[0].toUpperCase() + condition.substring(1);
    }
    
    return condition;
  }

  // Helper method to format time ago
  String getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas';
    } else {
      return '${difference.inMinutes} minutos';
    }
  }

  /// Convert a string type to HealthDataType
  HealthDataType getHealthDataTypeFromString(String measureType) {
    // Match measure type to HealthDataType using uppercase with underscores
    if (measureType == 'BLOOD_PRESSURE') {
      return HealthDataType.BLOOD_PRESSURE_SYSTOLIC;
    } else if (measureType == 'HEART_RATE') {
      return HealthDataType.HEART_RATE;
    } else if (measureType == 'BLOOD_OXYGEN' || measureType == 'OXYGEN_SATURATION') {
      return HealthDataType.BLOOD_OXYGEN;
    } else if (measureType == 'WEIGHT') {
      return HealthDataType.WEIGHT;
    } else if (measureType == 'TEMPERATURE' || measureType == 'BODY_TEMPERATURE') {
      return HealthDataType.BODY_TEMPERATURE;
    } else if (measureType == 'GLUCOSE' || measureType == 'BLOOD_GLUCOSE') {
      return HealthDataType.BLOOD_GLUCOSE;
    } else if (measureType == 'STEPS') {
      return HealthDataType.STEPS;
    } else if (measureType == 'SLEEP_IN_BED') {
      return HealthDataType.SLEEP_IN_BED;
    } else if (measureType == 'SLEEP' || measureType == 'SLEEP_ASLEEP') {
      return HealthDataType.SLEEP_ASLEEP;
    } else if (measureType == 'WORKOUT' || measureType == 'EXERCISE') {
      return HealthDataType.WORKOUT;
    } else if (measureType == 'MOOD' || measureType == 'MINDFULNESS') {
      return HealthDataType.MINDFULNESS;
    } else if (measureType == 'HEIGHT') {
      return HealthDataType.HEIGHT;
    } else {
      return HealthDataType.HEART_RATE; // Default fallback
    }
  }

  /// Get icon for a health data type using HealthDataType enum
  IconData getHealthDataIcon(String measureType) {
    final healthDataType = getHealthDataTypeFromString(measureType);
    return getIconForHealthDataType(healthDataType);
  }

  /// Get icon directly from HealthDataType enum
  IconData getIconForHealthDataType(HealthDataType type) {
    switch (type) {
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return Icons.favorite_outline;
      case HealthDataType.HEART_RATE:
        return Icons.monitor_heart_outlined;
      case HealthDataType.BLOOD_OXYGEN:
        return Icons.air_outlined;
      case HealthDataType.WEIGHT:
        return Icons.monitor_weight_outlined;
      case HealthDataType.BODY_TEMPERATURE:
        return Icons.thermostat_outlined;
      case HealthDataType.BLOOD_GLUCOSE:
        return Icons.water_drop_outlined;
      case HealthDataType.STEPS:
        return Icons.directions_walk_outlined;
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_LIGHT:
      case HealthDataType.SLEEP_DEEP:
      case HealthDataType.SLEEP_REM:
      case HealthDataType.SLEEP_AWAKE:
        return Icons.bedtime_outlined;
      case HealthDataType.WORKOUT:
        return Icons.fitness_center_outlined;
      case HealthDataType.MINDFULNESS:
        return Icons.mood_outlined;
      case HealthDataType.HEIGHT:
        return Icons.height_outlined;
      default:
        return Icons.monitor_heart_outlined;
    }
  }

  String formatHealthDataValue(dynamic healthDataPoint, String measureType) {
    final value = healthDataPoint['value'].toString();
    final unit = healthDataPoint['unit'].toString();
    final healthDataType = getHealthDataTypeFromString(measureType);
    
    switch (healthDataType) {
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        // Format: "120/80 mmHg"
        return '$value $unit';
      case HealthDataType.BLOOD_OXYGEN:
        // Format: "98%"
        return '$value%';
      case HealthDataType.HEART_RATE:
        // Format: "72 bpm"
        return '$value bpm';
      case HealthDataType.WEIGHT:
        // Format: "70 kg"
        return '$value $unit';
      case HealthDataType.BODY_TEMPERATURE:
        // Format: "36.5 °C"
        return '$value $unit';
      case HealthDataType.BLOOD_GLUCOSE:
        // Format: "100 mg/dL"
        return '$value $unit';
      case HealthDataType.STEPS:
        // Format: "10000 pasos"
        return '$value pasos';
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
        // Format: "8 horas"
        return '$value horas';
      case HealthDataType.MINDFULNESS:
        // Map numeric value to mood
        return getMoodLabel(value);
      default:
        return '$value $unit';
    }
  }

  String getMoodLabel(String value) {
    try {
      final moodValue = int.parse(value);
      switch (moodValue) {
        case 1: return 'Muy mal';
        case 2: return 'Mal';
        case 3: return 'Regular';
        case 4: return 'Bien';
        case 5: return 'Muy bien';
        default: return value;
      }
    } catch (_) {
      return value;
    }
  }

  String getNormalRangeForMeasurement(String measureType) {
    final healthDataType = getHealthDataTypeFromString(measureType);
    
    switch (healthDataType) {
      case HealthDataType.HEART_RATE:
        return '60-100 bpm';
      case HealthDataType.BLOOD_OXYGEN:
        return '95-100%';
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return '120/80 mmHg';
      case HealthDataType.BODY_TEMPERATURE:
        return '36.1-37.2 °C';
      case HealthDataType.BLOOD_GLUCOSE:
        return '70-140 mg/dL';
      default:
        return '';
    }
  }

  String getDataTypeName(String measureType) {
    final healthDataType = getHealthDataTypeFromString(measureType);
    return getDataTypeNameFromEnum(healthDataType);
  }

  String getDataTypeNameFromEnum(HealthDataType type) {
    switch (type) {
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return 'BloodPressureValue';
      case HealthDataType.HEART_RATE:
        return 'HeartRateValue';
      case HealthDataType.BLOOD_OXYGEN:
        return 'BloodOxygenValue';
      case HealthDataType.WEIGHT:
        return 'WeightValue';
      case HealthDataType.BODY_TEMPERATURE:
        return 'TemperatureValue';
      case HealthDataType.BLOOD_GLUCOSE:
        return 'GlucoseValue';
      case HealthDataType.STEPS:
        return 'StepsValue';
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_DEEP:
        return 'SleepValue';
      case HealthDataType.MINDFULNESS:
        return 'MoodValue';
      default:
        // Convert enum name to PascalCase and add "Value"
        final name = type.name.toLowerCase().split('_').map((word) => 
          word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}'
        ).join('');
        return '${name}Value';
    }
  }

  Color getValueColor(String value, String measureType) {
    try {
      final healthDataType = getHealthDataTypeFromString(measureType);
      
      switch (healthDataType) {
        case HealthDataType.HEART_RATE:
          final heartRate = int.parse(value);
          if (heartRate < 60) return Colors.blue;
          if (heartRate > 100) return Colors.orange;
          return Colors.green;
        
        case HealthDataType.BLOOD_OXYGEN:
          final oxygen = double.parse(value);
          if (oxygen < 90) return Colors.red;
          if (oxygen < 95) return Colors.orange;
          return Colors.green;
        
        case HealthDataType.BODY_TEMPERATURE:
          final temp = double.parse(value);
          if (temp < 36.1) return Colors.blue;
          if (temp > 37.2) return Colors.orange;
          if (temp > 38) return Colors.red;
          return Colors.green;
        
        case HealthDataType.BLOOD_GLUCOSE:
          final glucose = int.parse(value);
          if (glucose < 70) return Colors.blue;
          if (glucose > 140) return Colors.orange;
          if (glucose > 180) return Colors.red;
          return Colors.green;
        
        default:
          return Colors.grey[800]!;
      }
    } catch (e) {
      return Colors.grey[800]!;
    }
  }

  Color getBloodPressureColor(int value, bool isSystolic) {
    if (isSystolic) {
      // Systolic
      if (value < 120) return Colors.green;
      if (value < 130) return Colors.lightGreen;
      if (value < 140) return Colors.orange;
      if (value < 180) return Colors.deepOrange;
      return Colors.red;
    } else {
      // Diastolic
      if (value < 80) return Colors.green;
      if (value < 85) return Colors.lightGreen;
      if (value < 90) return Colors.orange;
      if (value < 120) return Colors.deepOrange;
      return Colors.red;
    }
  }

  Color getOverallBloodPressureColor(int systolic, int diastolic) {
    // Get the more severe color
    final systolicColor = getBloodPressureColor(systolic, true);
    final diastolicColor = getBloodPressureColor(diastolic, false);
    
    // Return the more severe color (red > orange > green)
    if (systolicColor == Colors.red || diastolicColor == Colors.red) {
      return Colors.red;
    } else if (systolicColor == Colors.deepOrange || diastolicColor == Colors.deepOrange) {
      return Colors.deepOrange;
    } else if (systolicColor == Colors.orange || diastolicColor == Colors.orange) {
      return Colors.orange;
    } else if (systolicColor == Colors.lightGreen || diastolicColor == Colors.lightGreen) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  String getBloodPressureClassification(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) {
      return 'Crisis hipertensiva';
    } else if (systolic >= 140 || diastolic >= 90) {
      return 'Hipertensión Etapa 2';
    } else if (systolic >= 130 || diastolic >= 80) {
      return 'Hipertensión Etapa 1';
    } else if (systolic >= 120 && systolic < 130 && diastolic < 80) {
      return 'Presión elevada';
    } else {
      return 'Presión normal';
    }
  }

