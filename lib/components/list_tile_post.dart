import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/components/post_container.dart';

// ignore: must_be_immutable
class ListTilePost extends StatefulWidget {
  ListTilePost({super.key, required this.list, required this.index});
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
    return GestureDetector(
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
                child: LottieFile(
                  file: 'heart',
                )),
        ],
      ),
    );
  }
}
