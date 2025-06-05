import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/doctors/index.dart';

import '../../../../widgets/card/v1/card/main_card.dart';

class DoctorsCreateDesktopView extends GetView<DoctorCreateController> {
  const DoctorsCreateDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:  BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.of(context).size.height - 140),
        child: MainCard(
          width       : controller.brain.contentWidth.value,
          height      : MediaQuery.of(context).size.height - 150,
          child       : Container(
            margin      : const EdgeInsets.all(15),
            child       : const DoctorsForm()
          )
        ),
      )
    );
  }
}