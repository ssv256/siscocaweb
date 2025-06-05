
// import 'package:file_picker/file_picker.dart';


import 'package:file_picker/file_picker.dart';

class ImageSelector {

  ///Selecciona una imagen o toma una fotografia
  ///este retorna un Map con la imagen en bytes y el archivo
  ///[fileBytes] y [file]
  static Future<Map<String, Object?>?> chooseImage({bool camera  = false})  async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type              : FileType.custom, 
      allowedExtensions : ['jpg', 'png', 'jpeg']
    );  

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      return {
        'fileBytes' : fileBytes,
        'file'      : 'file'
      };
    }else{
      return null;
    }

  }
    
}