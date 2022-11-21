// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantit/components/verify.dart';
import '../components/bottom_sheet_reset_password.dart';
import '../components/t_button.dart';
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';

class PlantFunctions {
  var imageFile,
      url,
  
      user = FirebaseAuth.instance,
      store = FirebaseFirestore.instance;

  dynamic get file {
    return imageFile;
  }

  deleteFile() {
    imageFile = null;
    url = null;
  }

  getFromGallery() async {
    // ignore: deprecated_member_use
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile == null) return;
    imageFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (imageFile == null) return;
    imageFile = await compressImage(imageFile.path, 35);
  }

  Future<File> compressImage(String path, int i) async {
    final newFile = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}${p.extension(path)}');
    // ignore: prefer_typing_uninitialized_variables
    var result;

    result = await FlutterImageCompress.compressAndGetFile(path, newFile,
        quality: i);

    return result;
  }
}
