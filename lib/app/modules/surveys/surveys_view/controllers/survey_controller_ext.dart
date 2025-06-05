// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../widgets/inputs/input_dropdown_ed.dart';
// import '../../../../widgets/inputs/main_input.dart';
// import '../controllers/survey_controller.dart';

// class FilterSurvey extends  GetView<SurveyController> {
//   const FilterSurvey({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         TextFieldWidget(
//           width       : 300,
//           controller : controller.textFieldController('filter'),
//           title       : 'Filtrar',
//           required    : true, 
//           titleMargin : false,
//           onchange    : (v){controller.filter(v);}
//         ),
//         const SizedBox(width: 10),
//         Obx(() =>InputDropDownEd(
//           title: 'Estado',
//           value: controller.varGet('filter', String).value,
//           items: const [
//             'Todos',
//             'Activo',
//             'Inactivo'
//           ],
//           onChage: (v){
//             controller.varSet('filter', v);
//             // controller.filterStatus(v);
//           }
//         ))
//       ]
//     );
//   }
// }