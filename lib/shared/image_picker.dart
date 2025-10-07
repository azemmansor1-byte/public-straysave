import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

//makes magic. just kidding, lets user pick image from their phone gallery
Future<File?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    debugPrint('Image picked: ${pickedFile.path}');
    return File(pickedFile.path);
  } else {
    return null;
  }
}
