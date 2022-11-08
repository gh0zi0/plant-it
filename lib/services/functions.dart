import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Functions {
  var imageFile, url;

  sharPost(
      GlobalKey<FormState> Gkey, BuildContext context, String content) async {
    if (!Gkey.currentState!.validate()) {
      return;
    }

    try {
      if (imageFile != null) {
        final ref = await FirebaseStorage.instance
            .ref()
            .child('Post/')
            .child(DateTime.now().toIso8601String());
        final result = await ref.putFile(imageFile);
        url = await result.ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('posts').add({
        'content': content,
        'image': url ?? '',
        'uid': FirebaseAuth.instance.currentUser!.uid
      });
      imageFile = null;
      url = null;
      Get.back();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('post shared')));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  dynamic get file {
    return imageFile;
  }

  deleteFile() {
    imageFile = null;
    url = null;
  }

  getFromGallery() async {
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
