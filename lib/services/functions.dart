// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/t_button.dart';
import 'package:plantit/components/verify.dart';
import 'package:plantit/services/restart_app.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import '../components/bottom_sheet_reset_password.dart';
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';

class Functions {
  var imageFile,
      url,
      sure = tr('sure'),
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
        'timestamp': DateTime.now()
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

  settingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(30),
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  trailing: const Icon(Icons.language),
                  title: const Text('changeLan').tr(),
                  onTap: () {
                    if (context.locale.toString() != 'ar') {
                      context.setLocale(const Locale('ar'));
                      RestartWidget.restartApp(context);
                    } else {
                      context.setLocale(const Locale('en'));
                      RestartWidget.restartApp(context);
                    }
                  },
                ),
                ListTile(
                  trailing:
                      Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  title: Text(Get.isDarkMode ? 'lightMode' : 'darkMode').tr(),
                  onTap: () {
                    ThemeModeBuilderConfig.toggleTheme();
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.share),
                  title: const Text('share').tr(),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Cooming soon')));
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.disabled_by_default_rounded),
                  title: const Text('deleteAcc').tr(),
                  onTap: () {
                    Get.defaultDialog(
                        title: sure,
                        content: const Text('deleteAccM').tr(),
                        confirm: TButton(
                            title: 'yes',
                            function: () async {
                              Get.off(() => const RegisterScreen());
                              await store
                                  .collection('users')
                                  .doc(user.currentUser!.uid)
                                  .delete();
                              await user.currentUser!.delete();
                              user.signOut();
                            }),
                        cancel: TButton(
                            title: 'no',
                            function: () {
                              Get.back();
                            }));
                  },
                ),
              ],
            ));
      },
    );
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

  verifyEmail(BuildContext context, String email, dynamic pass) async {
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

      await user.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      await verifyEmail(context,'google',credential);

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
