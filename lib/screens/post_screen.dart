import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/bottom_sheet_post.dart';
import '../components/list_tile_post.dart';
import '../components/lottie_file.dart';

// ignore: must_be_immutable
class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return BottomSheetPost(
               
              );
            },
          );
        },
        child: Icon(Icons.add),
        mini: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final postData = snapshot.data?.docs;
          if (snapshot.hasData) {
            if (postData!.isEmpty) {
              return LottieFile(
                file: 'error',
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: postData.length,
                itemBuilder: (context, index) {
                  return ListTilePost(
                    list: postData,
                    index: index,
                  );
                },
              ),
            );
          }
          return LottieFile(
            file: 'loading',
          );
        },
      ),
    );
  }
}
