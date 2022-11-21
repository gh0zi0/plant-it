import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/card_post.dart';
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
        heroTag: null,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final postData = snapshot.data?.docs;
                if (postData!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(100),
                    alignment: Alignment.center,
                    child: LottieFile(
                      file: 'error',
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 0.3,
                      color: Color(0xFF009345),
                    ),
                    physics: const NeverScrollableScrollPhysics(),
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
              return Container(
                  padding: const EdgeInsets.all(100),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
