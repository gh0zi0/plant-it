import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      loading = false;

  addPost() async {
    if (!Gkey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = !loading;
    });

    try {
     
        await FirebaseFirestore.instance.collection('posts').add({
          'title': title.text,
          'content': content.text,
          'image': image.text,
          'uid': FirebaseAuth.instance.currentUser!.uid
        });
    
      Get.back();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('post added')));
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
            Text(
              'Add post',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            EditTextFiled(
              hint: 'Post title',
              icon: Icons.text_fields_outlined,
              controller: title,
              secure: false,
              validator: (val) {
                if (val!.isEmpty) return 'Please enter a post title';
                return null;
              },
            ),
            EditTextFiled(
              hint: 'Post content',
              icon: Icons.content_copy,
              controller: content,
              secure: false,
              validator: (val) {
                if (val!.isEmpty) return 'Please enter a post content';
                return null;
              },
            ),
            EditTextFiled(
                hint: 'Image url',
                icon: Icons.photo,
                controller: image,
                secure: false,
                validator: null),
            const SizedBox(
              height: 50,
            ),
            loading
                ? const CircularProgressIndicator()
                : EButton(title: 'Add', function: addPost,h: 50,w: 150,)
          ],
        ),
      ),
    );
  }
}
