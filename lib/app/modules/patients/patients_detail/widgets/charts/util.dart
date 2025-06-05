import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<T> processHealthData<T>({
  required List<HealthDataPoint> healthDataPoints,
  required HealthDataType dataType,
  required int? daysRange,
  required T Function(DateTime date, dynamic value) createReading,
}) {
  // Calculate start date if daysRange is provided
  final DateTime? startDate = daysRange != null
      ? DateTime.now().subtract(Duration(days: daysRange))
      : null;

  return healthDataPoints
      .where((point) =>
          point.type == dataType &&
          (startDate == null || point.dateFrom.isAfter(startDate)))
      .map((point) {
        // Handle different value types
        dynamic processedValue;
        if (point.value is BloodPressureValue) {
          final bpValue = point.value as BloodPressureValue;
          processedValue = {
            'systolic': bpValue.systolic.round(),
            'diastolic': bpValue.diastolic.round()
          };
        } else if (point.value is MoodValue) {
          processedValue = (point.value as MoodValue).moodRating;
        } else if (point.value is NumericHealthValue) {
          processedValue = (point.value as NumericHealthValue).numericValue;
        }

        // Create specific reading if value was processed successfully
        return processedValue != null
            ? createReading(point.dateFrom, processedValue)
            : null;
      })
      .whereType<T>()
      .toList()
      ..sort((a, b) => (a as dynamic).date.compareTo((b as dynamic).date));
}

String getMoodEmoji(int value) {
  switch (value) {
    case 0:
      return '😭';
    case 1:
      return '😢';
    case 2:
      return '😞';
    case 3:
      return '😕';
    case 4:
      return '😐';
    case 5:
      return '🙂';
    case 6:
      return '😊';
    case 7:
      return '😃';
    case 8:
      return '😄';
    case 9:
      return '🤩';
    case 10:
      return '🥳';
    default:
      return '❓';
  }
}

String getMoodText(int value, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  switch (value) {
    case 0:
      return l10n.moodTerrible;
    case 1:
      return l10n.moodVeryBad;
    case 2:
      return l10n.moodBad;
    case 3:
      return l10n.moodSomewhatBad;
    case 4:
      return l10n.moodRegular;
    case 5:
      return l10n.moodSomewhatGood;
    case 6:
      return l10n.moodGood;
    case 7:
      return l10n.moodVeryGood;
    case 8:
      return l10n.moodExcellent;
    case 9:
      return l10n.moodIncredible;
    case 10:
      return l10n.moodPerfect;
    default:
      return l10n.moodUnknown;
  }
}