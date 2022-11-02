import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class BottomSheetPost extends StatefulWidget {
  BottomSheetPost({super.key, required this.data, required this.index});
  List<QueryDocumentSnapshot<Object?>>? data;
  int index;

  @override
  State<BottomSheetPost> createState() => _BottomSheetPostState();
}

class _BottomSheetPostState extends State<BottomSheetPost> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Gkey = GlobalKey();
  var title = TextEditingController(),
      content = TextEditingController(),
      image = TextEditingController(),
      loading = false,
      x = 'Add';

  addPost() async {
    if (!Gkey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = !loading;
    });

    try {
      if (x == 'Add') {
        await FirebaseFirestore.instance.collection('posts').add({
          'title': title.text,
          'content': content.text,
          'image': image.text
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.data![widget.index].id)
            .set({
          'title': title.text,
          'content': content.text,
          'image': image.text
        });
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('post $x ed')));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    if (widget.data!.isNotEmpty) {
      title.text = widget.data![widget.index]['title'];
      content.text = widget.data![widget.index]['content'];
      image.text = widget.data![widget.index]['image'];
      x = 'Edit';
    }
    super.initState();
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
              '$x post',
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
                : EButton(title: x, function: addPost)
          ],
        ),
      ),
    );
  }
}
