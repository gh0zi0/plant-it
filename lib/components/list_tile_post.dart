import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plantit/components/post_container.dart';
import 'package:plantit/components/t_button.dart';

// ignore: must_be_immutable
class ListTilePost extends StatefulWidget {
  ListTilePost(
      {super.key, required this.list, required this.index});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index;

  @override
  State<ListTilePost> createState() => _ListTilePostState();
}

class _ListTilePostState extends State<ListTilePost> {
  var doubleTap = false, auth = FirebaseAuth.instance.currentUser!.uid;
  int likeCount = 0;

  likePost() async {
    setState(() {
      doubleTap = true;
    });

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.list![widget.index].id)
        .collection('likes')
        .doc(auth)
        .set({});

    setState(() {
      doubleTap = false;
    });
  }

  deletePost(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete the post?'),
          actions: [
            TButton(
                title: 'Yes',
                function: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.list![widget.index].id)
                        .delete();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('post deleted')));
                  } on FirebaseException catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }),
            TButton(
                title: 'No',
                function: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  getLikeCount() async {
    var like = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.list![widget.index].id)
        .collection('likes')
        .get();
    setState(() {
      likeCount = like.size;
    });
  }

  @override
  void initState() {
    getLikeCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
            onDoubleTap: (() async {
              likePost();
              getLikeCount();
            }),
            child: Stack(
              children: [
                PostContainer(
                  index: widget.index,
                  list: widget.list,
                  likes: likeCount,
                ),
                if (doubleTap)
                  Positioned(
                      left: 0,
                      top: 0,
                      child: Lottie.asset('lottie/heart.json',
                          height: 100, repeat: false)),
              ],
            ),
          );
       
  }
}
