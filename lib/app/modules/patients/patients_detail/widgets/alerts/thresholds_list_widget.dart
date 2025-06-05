import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/models/models.dart';
import 'package:siscoca/app/modules/patients/shared/alert_thresholds_components.dart';
import './alerts_controller.dart';

class ThresholdsListWidget extends StatelessWidget {
  final AlertsController controller;
  final VoidCallback onCreateThreshold;
  final Function(AlertThreshold threshold) onEditThreshold;

  const ThresholdsListWidget({
    super.key,
    required this.controller,
    required this.onCreateThreshold,
    required this.onEditThreshold,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadThresholds,
      child: Obx(() {
        if (controller.isThresholdsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasThresholdsError.value || controller.thresholds.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.thresholds.length,
          itemBuilder: (context, index) {
            final threshold = controller.thresholds[index];
            return _buildThresholdCard(threshold, context);
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
            Icons.tune_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay umbrales configurados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.hasThresholdsError.value 
                ? controller.thresholdsErrorMessage.value
                : 'Puede crear umbrales personalizados para este paciente',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onCreateThreshold,
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
    final (severityColor, severityIcon, severityText) = AlertThresholdsComponents.getAlertSeverityInfo(
      threshold.severity
    );
    
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
            measurementType: AlertThresholdsComponents.getMeasurementTypeLabel(threshold.measureType),
            threshold: threshold,
            context: context,
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Condiciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...threshold.conditions.map((condition) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${formatCondition(condition)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  )
                ).toList(),
                
                if (threshold.conditions.isEmpty)
                  Text(
                    'Sin condiciones específicas',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader({
    required Color severityColor,
    required IconData severityIcon,
    required String severityText,
    required String measurementType,
    required AlertThreshold threshold,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
                  color: severityColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(severityIcon, color: severityColor, size: 18),
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
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  severityText,
                  style: TextStyle(
                    fontSize: 12,
                    color: severityColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 20),
            splashRadius: 20,
            onPressed: () => onEditThreshold(threshold),
          ),
        ],
      ),
    );
  }

  // Helpers
  String formatCondition(String condition) {
    // Implementar según las necesidades
    return condition;
  }
} 