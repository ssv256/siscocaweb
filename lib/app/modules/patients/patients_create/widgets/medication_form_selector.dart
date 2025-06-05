import 'package:flutter/material.dart';

enum MedicationFormType {
  pill,
  tablet,
  sachet,
  drops,
  syrup,
  injection
}

class MedicationFormSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onSelected;
  final bool showLabel;

  const MedicationFormSelector({
    Key? key,
    required this.selectedType,
    required this.onSelected,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MedicationFormInfo> medicationForms = MedicationFormType.values
        .map((type) => MedicationFormInfo(
              type: type,
              iconData: _getIconForType(type),
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forma de medicación',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 75,
          child: ListView.builder(
            itemCount: medicationForms.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final form = medicationForms[index];
              final isSelected = selectedType == form.name;
              return GestureDetector(
                onTap: () => onSelected(form.name),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        form.iconData,
                        size: 25,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                      if (showLabel) ...[
                        const SizedBox(height: 6),
                        Text(
                          form.getLocalizedName(context),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  IconData _getIconForType(MedicationFormType type) {
    switch (type) {
      case MedicationFormType.pill:
        return Icons.medication_outlined;
      case MedicationFormType.tablet:
        return Icons.medication;
      case MedicationFormType.sachet:
        return Icons.ad_units_outlined;
      case MedicationFormType.drops:
        return Icons.water_drop_outlined;
      case MedicationFormType.syrup:
        return Icons.local_drink_outlined;
      case MedicationFormType.injection:
        return Icons.vaccines_outlined;
    }
  }
}

class MedicationFormInfo {
  final MedicationFormType type;
  final IconData iconData;

  const MedicationFormInfo({required this.type, required this.iconData});

  String get name => type.toString().split('.').last;

  String getLocalizedName(BuildContext context) {
    switch (type) {
      case MedicationFormType.pill:
        return 'Pastilla';
      case MedicationFormType.tablet:
        return 'Tableta';
      case MedicationFormType.sachet:
        return 'Sobre';
      case MedicationFormType.drops:
        return 'Gotas';
      case MedicationFormType.syrup:
        return 'Jarabe';
      case MedicationFormType.injection:
        return 'Inyección';
    }
  }

  static MedicationFormInfo? fromString(String type, BuildContext context) {
    for (var formType in MedicationFormType.values) {
      if (formType.toString().split('.').last == type) {
        IconData iconData;
        
        switch (formType) {
          case MedicationFormType.pill:
            iconData = Icons.medication_outlined;
            break;
          case MedicationFormType.tablet:
            iconData = Icons.medication;
            break;
          case MedicationFormType.sachet:
            iconData = Icons.ad_units_outlined;
            break;
          case MedicationFormType.drops:
            iconData = Icons.water_drop_outlined;
            break;
          case MedicationFormType.syrup:
            iconData = Icons.local_drink_outlined;
            break;
          case MedicationFormType.injection:
            iconData = Icons.vaccines_outlined;
            break;
        }
        
        return MedicationFormInfo(
          type: formType,
          iconData: iconData,
        );
      }
    }
    return null;
  }
} 