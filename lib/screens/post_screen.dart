import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/e_button.dart';
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
              return const BottomSheetPost();
            },
          );
        },
        child: Icon(Icons.add),
        mini: true,
      ),
      body: ListView(
        children: [
          Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/tree.png',
                      height: 150,
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'هذه الارض تستحق الحياة',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'الطبيعة مصدر إلهامنا',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'لنحافظ عليها',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: EButton(
                              title: 'إبدأ ', function: () {}, h: 25, w: 100),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
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
