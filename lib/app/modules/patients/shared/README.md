# Shared Components

This directory contains shared components that can be reused across different modules in the application.

## AlertThresholdsComponents

`AlertThresholdsComponents` is a utility class that provides shared functionality for working with alert thresholds across different parts of the application. It standardizes the UI components and business logic for creating, displaying, and managing patient alert thresholds.

### Key Features

- **Condition Parsing**: Methods to parse alert threshold conditions from string format
- **Condition Formatting**: Helper functions to format conditions in a human-readable way
- **UI Components**: Reusable UI elements for threshold dialogs and condition selectors
- **Data Utilities**: Standard methods for getting severity info, measurement type labels, and icons

### Usage

Import the class:

```dart
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';
```

Use the static methods and components in your widgets:

```dart
// Get severity info
final (color, icon, text) = AlertThresholdsComponents.getAlertSeverityInfo('high');

// Format a condition for display
final readableCondition = AlertThresholdsComponents.formatCondition("x['value'] > 100");

// Get measurement type label
final label = AlertThresholdsComponents.getMeasurementTypeLabel('heart_rate');

// Use dialog content in your own dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Create Alert Threshold'),
    content: AlertThresholdsComponents.buildThresholdDialogContent(
      // provide required parameters
    ),
    actions: [
      // your actions
    ],
  ),
);
```

### Benefits of Using Shared Components

1. **Consistency**: Ensures a consistent UI and behavior across different parts of the application
2. **Maintainability**: Centralized code is easier to update and maintain
3. **Reduced Code Duplication**: Eliminates duplicate code across different modules
4. **Better Testing**: Shared components can be tested once and used with confidence throughout the app

This approach aligns with the DRY (Don't Repeat Yourself) principle and encourages component reuse. 