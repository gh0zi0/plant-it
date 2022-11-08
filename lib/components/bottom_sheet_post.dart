import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/functions.dart';
import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class BottomSheetPost extends StatefulWidget {
  const BottomSheetPost({super.key});

  @override
  State<BottomSheetPost> createState() => _BottomSheetPostState();
}

class _BottomSheetPostState extends State<BottomSheetPost> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Gkey = GlobalKey();
  var title = TextEditingController(),
      content = TextEditingController(),
      image = TextEditingController(),
      focusT = FocusNode(),
      focusC = FocusNode(),
      focusI = FocusNode(),
      loading = false,
      imageFile,
      url;

  addPost() async {
    if (!Gkey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = !loading;
    });

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'content': content.text,
        'image': image.text,
        'uid': FirebaseAuth.instance.currentUser!.uid
      });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      height: double.infinity,
      child: Form(
        key: Gkey,
        child: Column(
          children: [
            const Text(
              'New post',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            EditTextFiled(
              focus: focusC,
              hint: 'Post content',
              icon: Icons.text_fields_outlined,
              controller: content,
              secure: false,
              validator: (val) {
                if (val!.isEmpty) return 'Please enter a post content';
                return null;
              },
            ),
            GestureDetector(
                onTap: () {
                  Get.put(Functions()).getFromGallery();
                 
                  
                },
                child: imageFile == null
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1)),
                        child: const Icon(
                          Icons.person,
                          size: 75,
                        ),
                      )
                    : CircleAvatar(
                        radius: 75,
                        backgroundImage: FileImage(
                          imageFile,
                        ))),
            const SizedBox(
              height: 50,
            ),
            loading
                ? const CircularProgressIndicator()
                : EButton(
                    color: Colors.green,
                    title: 'Share',
                    function: addPost,
                    h: 50,
                    w: 150,
                  )
          ],
        ),
      ),
    );
  }
}
