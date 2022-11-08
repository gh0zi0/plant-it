import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/card_post.dart';
import 'package:plantit/components/e_button.dart';
import '../components/bottom_sheet_post.dart';
import '../components/list_tile_post.dart';
import '../components/lottie_file.dart';

// ignore: must_be_immutable
class PostScreen extends StatelessWidget {
  PostScreen({super.key, required this.function});
  Function function;

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
              return const BottomSheetPost();
            },
          );
        },
        mini: true,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          CardPost(
            function: function,
          ),
          StreamBuilder(
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
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                    shrinkWrap: true,
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
        ],
      ),
    );
  }
}
