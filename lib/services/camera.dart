import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Camera();

  Future<XFile?> caputure(double maxWidth, double maxHeight, {int? imageQuality = 100}) async{
    return await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
  }
}