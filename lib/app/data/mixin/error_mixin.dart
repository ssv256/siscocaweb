
mixin ErrorMixin {
  
  Map<String, Map<String,String>> errors = {};
  
  void addError(String key,  String title, String message,) {
    errors[key]  = {
      'title'   : title,
      'message' : message
    };
  }

  Map<String,String> error(String key) {
    if (!errors.containsKey(key)) {
      errors[key] = {
        'title'   : '',
        'message' : ''
      };
    }
    return errors[key]!;
  }

  void clearError(String key) {
    final controller = errors[key];
    if (controller != null) {
      controller.clear();
    }
  }
 
}
