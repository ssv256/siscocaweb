import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';


class CollapsiblePatientHeatMap extends GetView<PatientsDetailController> {
  final Map<DateTime, int> data;
  
  const CollapsiblePatientHeatMap({
    super.key,
    this.data = const {},
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(31, 102, 145, 237),
                  width: 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.isHeatmapExpanded.value = !controller.isHeatmapExpanded.value;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    controller.isHeatmapExpanded.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            // HeatMap container with animated visibility
            if (controller.isHeatmapExpanded.value)
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.isHeatmapExpanded.value ? 1.0 : 0.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(31, 102, 145, 237),
                        width: 3,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: HeatMap(
                        scrollable: true,
                        colorMode: ColorMode.color,
                        showColorTip: false,
                        datasets: data,
                        size: 14,
                        colorsets: const {
                          1: Color.fromARGB(100, 22, 171, 245),
                          2: Color.fromARGB(140, 22, 160, 235),
                          3: Color.fromARGB(180, 22, 149, 225),
                          4: Color.fromARGB(200, 22, 138, 215),
                          5: Color.fromARGB(220, 22, 127, 205),
                          6: Color.fromARGB(240, 22, 116, 195),
                          7: Color.fromARGB(255, 22, 105, 185),
                        },
                        onClick: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(value.toString())),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
      }
    );
  }
}