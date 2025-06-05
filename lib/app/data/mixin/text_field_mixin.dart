import 'package:flutter/material.dart';

mixin TextFieldMixin {
  
  Map<String, TextEditingController> textControllers = {};
  
  void addTextField(String controllerId, String initialValue) {
    textControllers[controllerId] = TextEditingController(text: initialValue);
  }

  TextEditingController textFieldController(String controllerId) {
    if (!textControllers.containsKey(controllerId)) {
      textControllers[controllerId] = TextEditingController();
    }
    return textControllers[controllerId]!;
  }

  void clearTextField(String controllerId) {
    final controller = textControllers[controllerId];
    if (controller != null) {
      controller.clear();
    }
  }
 
  void disposeTextControllers() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    textControllers.clear();
  }
}
