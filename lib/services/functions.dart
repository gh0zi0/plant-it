// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as p;
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
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';

class Functions {
  var imageFile,
      url,
      user = FirebaseAuth.instance,
      store = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  sharePost(
      GlobalKey<FormState> key, BuildContext context, String content) async {
    if (!key.currentState!.validate()) {
      return;
    }

    try {
      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('Post/')
            .child(DateTime.now().toIso8601String());
        final result = await ref.putFile(imageFile);
        url = await result.ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('posts').add({
        'content': content,
        'image': url ?? '',
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
        'name': user.currentUser!.displayName,
        'Uimage': user.currentUser!.photoURL ?? ''
      });
      imageFile = null;
      url = null;
      Get.back();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content: const Text('shared').tr()));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  

  countdownDialog(BuildContext context, String email, String pass) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Verify(
          email: email,
          password: pass,
        );
      },
    );
  }

  verifyEmail(BuildContext context, String email, String pass) async {
    if (user.currentUser!.emailVerified) {
      Get.off(() => const HomeScreen());
    } else {
      countdownDialog(context, email, pass);
      await user.currentUser!.sendEmailVerification();
    }
  }

  authentication(
      BuildContext context,
      String email,
      String password,
      String name,
      GlobalKey<FormState> key,
      FocusNode focusE,
      FocusNode focusP,
      FocusNode focusN,
      bool authentication) async {
    if (!key.currentState!.validate()) {
      return;
    }
    focusE.unfocus();
    focusP.unfocus();
    focusN.unfocus();

    try {
      if (authentication) {
        await user.createUserWithEmailAndPassword(
            email: email, password: password);
        if (imageFile != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('Profile/')
              .child(DateTime.now().toIso8601String());
          final result = await ref.putFile(imageFile);
          url = await result.ref.getDownloadURL();
          await user.currentUser!.updatePhotoURL(url);
        }
        await store.collection('users').doc(user.currentUser!.uid).set({
          'name': name,
          'points': 0,
          'plants': 0,
          'water': 0,
          'email': email,
          'uid': user.currentUser!.uid,
          'image': url ?? ''
        });

        // ignore: use_build_context_synchronously
      } else {
        await user.signInWithEmailAndPassword(email: email, password: password);
      }
      // ignore: use_build_context_synchronously
      await verifyEmail(context, email, password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  forgetPass(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return const BottomSheetReset();
      },
    );
  }

  signInGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await user.signInWithCredential(credential);

      await store
          .collection('users')
          .doc(user.currentUser!.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          await store.collection('users').doc(user.currentUser!.uid).set({
            'name': googleSignInAccount.displayName,
            'points': 0,
            'plants': 0,
            'water': 0,
            'email': googleSignInAccount.email,
            'uid': user.currentUser!.uid,
            'image': googleSignInAccount.photoUrl ?? ''
          });
        }
      });

      Get.off(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  dynamic get file {
    return imageFile;
  }

  auth() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (user.currentUser?.uid != null && user.currentUser!.emailVerified) {
      Get.off(() => const HomeScreen());
    } else {
      Get.off(() => const RegisterScreen());
    }
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
