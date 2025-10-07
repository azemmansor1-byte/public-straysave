import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

const int maxFileSizeInBytes = 5 * 1024 * 1024;

//these all functions? they handle upload images to firestorage. thats the limit of my knowledge

Future<bool> checkImageSize(File? img) async {
  if (img == null) {
    debugPrint("image is null");
    return false;
  } // No file provided

  try {
    int fileSize = await img.length();
    if (fileSize > maxFileSizeInBytes) {
      debugPrint("File too large: ${fileSize / (1024 * 1024)} MB");
      return false;
    }

    debugPrint("image pass vibe check");
    return true;
  } catch (e) {
    debugPrint("Error checking file size: $e");
    return false;
  }
}

Future<Uint8List?> compressImage(
  File img, {
  int quality = 70,
  int minWidth = 800,
  int minHeight = 800,
}) async {
  try {
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      img.path,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );

    if (compressedBytes == null) {
      debugPrint("Compression failed, using original file bytes.");
      compressedBytes = await img.readAsBytes();
    }

    return compressedBytes;
  } catch (e) {
    debugPrint("Error compressing image: $e");
    return null;
  }
}

Future<String?> uploadImage(File? img) async {
  //No image selected
  if (img == null) return null;

  try {
    Uint8List? compressedBytes = await compressImage(img);

    compressedBytes ??= await img.readAsBytes();

    int fileSize = compressedBytes.length;
    if (fileSize > maxFileSizeInBytes) {
      debugPrint(
        "File too large after compression: ${fileSize / (1024 * 1024)} MB.",
      );
      return null;
    }

    String fileName = '${Uuid().v4()}.jpg';
    Reference ref = FirebaseStorage.instance.ref().child('reports/$fileName');

    UploadTask uploadTask = ref.putData(compressedBytes);
    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    debugPrint("Error uploading image: $e");
    return null;
  }
}

Future<void> deleteImage(String imgUrl) async {
  try {
    Reference ref = FirebaseStorage.instance.refFromURL(imgUrl);
    await ref.delete();
    debugPrint("Image deleted: $imgUrl");
  } catch (e) {
    debugPrint("Error deleting image: $e");
  }
}
