import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';
import '../controllers/patients_detail_controller.dart';
import 'package:domain/models/models.dart';

class PatientPassportTab extends GetView<PatientsDetailController> {
  const PatientPassportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User patient = Get.arguments as User;
    return Obx(() {
      final passport = controller.medicalPassport.value;
      if (passport == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.badge_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay pasaporte médico disponible',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Crea un pasaporte médico para este paciente',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/create-medical-passport', arguments: patient),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Crear Pasaporte Médico'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                patientF(patient, context),
                pathologia(passport.pathology, context),              
                constantes(passport.patientConstants.firstOrNull, context),
                informacionClinica(passport.clinicalInfo, context),
                procedimiento(passport.procedures, context),
                residualLesion(passport.residualLesions, context),
                medicacion(passport.medications, context),
                estudios(passport.studies, context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget estudios(List<Study> studies, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.science_outlined,
            title: 'Estudios Clínicos',
            color: const Color(0xFF805AD5),
            context: context,
          ),
          if (studies.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No hay estudios clínicos registrados',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: studies.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final study = studies[index];
                  return _buildStudyCard(study, context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStudyCard(Study study, BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF805AD5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.science_outlined,
                    size: 24,
                    color: Color(0xFF805AD5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        study.studyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        study.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.local_hospital_outlined,
                    label: 'Hospital',
                    value: study.hospital,
                    context: context,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.person_outline,
                    label: 'Responsable',
                    value: study.responsiblePerson,
                    context: context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.email_outlined,
                    label: 'Email de contacto',
                    value: study.email,
                    context: context,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.phone_outlined,
                    label: 'Teléfono',
                    value: study.phone,
                    context: context,
                  ),
                ),
              ],
            ),
            if (study.additionalData.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoItem(
                icon: Icons.info_outline,
                label: 'Información adicional',
                value: study.additionalData,
                context: context,
              ),
            ],
            if (study.status != null) ...[
              const SizedBox(height: 12),
              _buildStudyStatus(study.status!, context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStudyStatus(int status, BuildContext context) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 1:
        statusText = 'Activo';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 2:
        statusText = 'Completado';
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
      case 3:
        statusText = 'Suspendido';
        statusColor = Colors.orange;
        statusIcon = Icons.pause_circle_outline;
        break;
      case 0:
      default:
        statusText = 'Pendiente';
        statusColor = Colors.grey;
        statusIcon = Icons.pending_outlined;
        break;
    }

    return Row(
      children: [
        Icon(
          statusIcon,
          size: 18,
          color: statusColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Estado: $statusText',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget patientF(User patient, BuildContext context){
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final passport = controller.medicalPassport.value;
    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildSectionHeader(
                icon: Icons.person_outline,
                title: 'Información del Paciente',
                color: theme.primaryColor,
                context: context,
              ),
              Positioned(
                right: 16,
                top: 14,
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => Get.toNamed(
                        AppRoutes.patientsCreate, 
                        arguments: [patient, passport]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Editar',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.badge_outlined,
                        label: 'Paciente',
                        value: patient.name ?? 'N/A',
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.person_outline,
                        label: 'Apellido',
                        value: patient.surname ?? 'N/A',
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.wc_outlined,
                        label: 'Sexo',
                        value: patient.sex ?? 'N/A',
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.cake_outlined,
                        label: 'Fecha nacimiento',
                        value: patient.birthDate ?? 'N/A',
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.numbers_outlined,
                        label: 'Número de Paciente',
                        value: patient.patientNumber ?? 'N/A',
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.email_outlined,
                        label: 'Correo',
                        value: patient.email ?? 'N/A',
                        context: context,
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

  Widget constantes(PatientConstant? constants, BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.monitor_heart_outlined,
            title: 'Constantes',
            color: const Color(0xFF3182CE),
            context: context,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.monitor_weight_outlined,
                        label: 'Peso',
                        value: '${constants?.weight ?? 'N/A'} kg',
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.height_outlined,
                        label: 'Altura',
                        value: '${constants?.height ?? 'N/A'} m',
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.air_outlined,
                        label: 'Oxígeno',
                        value: '${constants?.oxygenSaturation ?? 'N/A'}%',
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.favorite_outline,
                        label: 'Ritmo cardíaco',
                        value: '${constants?.pulseRate ?? 'N/A'} bpm',
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.speed_outlined,
                        label: 'Presión sanguínea',
                        value: constants?.bloodPressure ?? 'N/A',
                        context: context,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pathologia(Pathology pathology, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!, 
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.medical_information_outlined,
            title: 'Patologías',
            color: const Color(0xFFED8936),
            context: context,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _buildInfoItem(
                  icon: Icons.medical_services_outlined,
                  label: 'Patología',
                  value: pathology.generalPathology,
                  context: context,
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  icon: Icons.medical_information_outlined,
                  label: 'Patología específica',
                  value: pathology.specificPathology,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget informacionClinica(ClinicalInfo? info, BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.health_and_safety_outlined,
            title: 'Información Clínica',
            color: const Color(0xFF68D391),
            context: context,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.favorite_border,
                        label: 'Riesgo de endocarditis',
                        value: info?.increaseEndocarditisRisk == true ? 'Sí' : 'No',
                        context: context,
                        valueColor: info?.increaseEndocarditisRisk == true ? Colors.red : null,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.devices_other_outlined,
                        label: 'Portador de dispositivo',
                        value: (info?.implantableDevices.isNotEmpty ?? false) ? 'Sí' : 'No',
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.pregnant_woman_outlined,
                        label: 'Riesgo de embarazo',
                        value: info?.pregnantRisk ?? 'No',
                        context: context,
                        valueColor: info?.pregnantRisk != null && info!.pregnantRisk.isNotEmpty ? Colors.orange : null,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.bloodtype_outlined,
                        label: 'Anticoagulación',
                        value: info?.anticoagulation == true ? 'Sí' : 'No',
                        context: context,
                        valueColor: info?.anticoagulation == true ? Colors.orange : null,
                      ),
                    ),
                  ],
                ),
                if (info?.anticoagulationMedication.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.medication_outlined,
                    label: 'Medicación anticoagulante',
                    value: info?.anticoagulationMedication ?? '',
                    context: context,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget procedimiento(List<Procedure> procedures, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!, 
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.medical_services_outlined,
            title: 'Procedimientos',
            color: const Color(0xFF4299E1),
            context: context,
          ),
          if (procedures.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay procedimientos registrados',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Los procedimientos médicos aparecerán aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: procedures.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4299E1).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4299E1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Procedimiento ${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              procedures[index].description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget residualLesion(List<ResidualLesions> residualLesions, BuildContext context) {
   return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!, 
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.warning_amber_rounded,
            title: 'Lesiones Residuales',
            color: const Color(0xFFECC94B),
            context: context,
          ),
          if (residualLesions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay lesiones residuales registradas',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Las lesiones residuales aparecerán aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: residualLesions.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECC94B).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFECC94B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lesión ${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              residualLesions[index].description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget medicacion(List<Medication> medications, BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.medication_outlined,
            title: 'Medicación',
            color: const Color(0xFF9F7AEA),
            context: context,
          ),
          if (medications.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay medicación registrada',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'La información sobre medicación aparecerá aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medications.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final med = medications[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9F7AEA).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9F7AEA),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                if (med.amount != null && med.amount!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dosis: ${med.amount}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                                if (med.description != null && med.description!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Instrucciones: ${med.description}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 8),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
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
}