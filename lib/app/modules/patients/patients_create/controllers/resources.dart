import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

///Pathologies
RxList pathologyList = [
  
  {
    'value'   : 'Anomalias de la disposición y conexión cardiacas',
    'options' : [
      'Orientación o posición cardiaca anómala',
      'Dextrocardia',
      'Atrial situs inversus',
      'Isomerismo derecho. Asplenia',
      'Isomerismo izquierdo. Poliesplenia',
      'Ventrículo derecho de doble entrada',
      'Ventrículo izquierdo de doble entrada',
      'Atresia tricúspide',
      'Atresia mitral',
      'Ventrículo único indeterminado',
      'Transposición de grandes arterias completa con septo íntedro',
      'Transposicón de grandes arterias congénitamente corregida',
      'Ventrículo derecho de doble salida tipo Fallot',
      'Ventrículo derecho de doble salida tipo transposición',
      'Ventrículo derecho de doble salida con CIV no relacionada',
      'Ventrículo izquierdo de doble salida',
      'Corazón en Criss-Cross',
      'Truncus arterial común '
    ]
  },
  {
    'value'   : 'Anomalías de las grandes venas. ',
    'options' : [
      'Vena cava superior izquierda persistente con drenaje a seno coronario.',
      'Continuación de vena cava inferior con ácigos.',
      'Anomalía venosa sistémica congénita.',
      'Anomalía venosa pulmonar',
      'Drenaje pulmonar venoso anómalo total.',
      'Drenaje pulmonar venoso anómalo parcial.',
      'Drenaje pulmonar venoso anómalo parcial tipo Síndrome de Cimitarra.'
    ]
  },
  {
    'value'   : 'Anomalías de las aurículas y septo interauricular',
    'options' : [
      'Cor triatriatum',
      'CIA',
      'CIA tipo ostim secundum',
      'CIA tipo seno venoso',
      'CIA tipo seno coronario.'
    ]
  },
  {
    'value'   : 'Anomalías de las válvulas AV o defectos septales AV.',
    'options':  [
      'insuficiencia tricuspidea congénita',
      'Anomalía de Ebstein',
      'Estenosis válvula tricúspide',
      'Insuficiencia mitral congénita',
      'Cleft mitral',
      'Estenosis mitral congénita',
      'Válvula mitral en paracaídas',
      'Canal AV: CIA tipo ostium primum aislada.',
      'Canal AV: Completo con componente auricular y ventricular y válvula común.',
      'Canal AV: Intermedio con componente auricular y ventricular y válvulas separadas.',
      'Canal AV completo disbalanceado.',
      'Anomalía de la válvula tricúspiode.',
      'Anomalía de la válvula mitral.',
    ]
  },
  {
    'value'   : 'Anomalías de los ventrículos y septo interventricular.',
    'options' : [
      'Corazón funcionalmente univentricular.',
      'Ventrículo derecho de doble cámara.',
      'Síndrome del corazón izquierdo hipoplásico.',
      'CIV.',
      'CIV perimembranosa.',
      'CIV de entrada.',
      'CIV muscular.',
      'CIV doble relacionada.',
      'Defecto tipo Gerbode (VI-AD).',
      'Aneurisma de septo membranoso.',
      'Aneurisma de septo membranoso.',
      'Tetralogía de Fallot.',
      'Atresia pulmonar con CIV (incluido tipo Fallot).'
    ]
  },
  {
      "value": "Anomalías de las válvulas VA y grandes arterias",
      "options": [
          "Ventana aortopulmonar",
          "Hemitruncus (Arteria pulmonar de aorta ascendente)",
          "Insuficiencia pulmonar congénita",
          "Estenosis subpulmonar",
          "Estenosis valvular pulmonar congénita",
          "Atresia pulmonar con septo interventricular íntegro",
          "Estenosis pulmonar supravalvular",
          "Estenosis arteria pulmonar central previa a bifurcación hiliar",
          "Estenosis arteria pulmonar periférica en la bifurcación hiliar",
          "Aneurisma arteria pulmonar",
          "Insuficiencia aórtica congénita",
          "Estenosis subaórtica",
          "Estenosis aórtica congénita",
          "Válvula aórtica bicúspide",
          "Estenosis supravalvular aórtica",
          "Dilatación aorta ascendente",
          "Aneurisma de los senos de Valsalva",
          "Túnel aorto-VI"
      ]
  },
  {
      "value": "Anomalías de las coronarias, ductus arterioso, fístulas y pericardio",
      "options": [
          "Salida anómala de coronaria de arteria pulmonar",
          "Fístula coronaria",
          "Salida anómala de aorta o recorrido anómalo",
          "Ductus arterioso persistente (DAP)",
          "Fístula pulmonar arteriovenosa",
          "Agenesia pericárdica. Otras anomalías pericárdicas"
      ]
  },
  {
      "value": "Otra cardiopatía congénita no especificada",
      "options": []
  }

].obs;

final clinicalValues = <String, RxString>{
    'endocarditis': 'No'.obs,
    'deviceCarrier': 'No'.obs,
    'pregnancyRisk': 'Riesgo nulo o muy reducido'.obs,
    'anticoagulation': 'No'.obs,
    'studies': 'REHAP'.obs,
  }.obs;

  /// Clinical error states
  final clinicalErrors = <String, RxBool>{
    'endocarditis': false.obs,
    'deviceCarrier': false.obs,
    'pregnancyRisk': false.obs,
    'anticoagulation': false.obs,
    'studies': false.obs,
  }.obs;


 const Map<String, List<VitalSignRange>> vitalSignsRanges = {
    'oxygen': [
      VitalSignRange(
        label: 'Valores muy bajos',
        color: Colors.red,
        range: '< 90%',
        maxValue: 89.9,
        displayText: '< 90%',
      ),
      VitalSignRange(
        label: 'Valores bajos',
        color: Colors.orange,
        range: '90-94%',
        minValue: 90,
        maxValue: 94.9,
        displayText: '90-94%',
      ),
      VitalSignRange(
        label: 'Valores normales',
        color: Colors.green,
        range: '95-100%',
        minValue: 95,
        maxValue: 100,
        displayText: '95-100%',
      ),
    ],
    'bloodPressure': [
      VitalSignRange(
        label: 'Valores muy bajos',
        color: Colors.red,
        range: '< 90/60 mmHg',
        maxValue: 89.9,
        displayText: '< 90/60',
      ),
      VitalSignRange(
        label: 'Valores bajos',
        color: Colors.blue,
        range: '500/60 - 109/69 mmHg',
        minValue: 90,
        maxValue: 109.9,
        displayText: '90/60 - 109/69',
      ),
      VitalSignRange(
        label: 'Valores normales',
        color: Colors.green,
        range: '110/70 - 129/84 mmHg',
        minValue: 110,
        maxValue: 129.9,
        displayText: '110/70 - 129/84',
      ),
      VitalSignRange(
        label: 'Valores altos',
        color: Colors.orange,
        range: '130/85 - 139/89 mmHg',
        minValue: 130,
        maxValue: 139.9,
        displayText: '130/85 - 139/89',
      ),
      VitalSignRange(
        label: 'Valores muy altos',
        color: Colors.red,
        range: '≥ 140/90 mmHg',
        minValue: 140,
        displayText: '≥ 140/90',
      ),
    ],
    'heartRate': [
      VitalSignRange(
        label: 'Valores muy bajos',
        color: Colors.red,
        range: '< 50 bpm',
        maxValue: 49.9,
        displayText: '< 50',
      ),
      VitalSignRange(
        label: 'Valores bajos',
        color: Colors.blue,
        range: '50-59 bpm',
        minValue: 50,
        maxValue: 59.9,
        displayText: '50-59',
      ),
      VitalSignRange(
        label: 'Valores normales',
        color: Colors.green,
        range: '60-100 bpm',
        minValue: 60,
        maxValue: 100,
        displayText: '60-100',
      ),
      VitalSignRange(
        label: 'Valores altos',
        color: Colors.orange,
        range: '101-120 bpm',
        minValue: 101,
        maxValue: 120,
        displayText: '101-120',
      ),
      VitalSignRange(
        label: 'Valores muy altos',
        color: Colors.red,
        range: '> 120 bpm',
        minValue: 120.1,
        displayText: '> 120',
      ),
    ],
  };