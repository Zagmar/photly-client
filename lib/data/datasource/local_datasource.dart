import 'dart:io';

import 'package:image_picker/image_picker.dart';

class LocalDataSource {
  // get image through imagePicker
  Future<File?> getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource, preferredCameraDevice: CameraDevice.front,);
    if(image != null){
      return File(image.path);
    }
    else{
      return null;
    }
  }
}