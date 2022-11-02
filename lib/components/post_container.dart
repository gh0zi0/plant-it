import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PostContainer extends StatelessWidget {
  PostContainer(
      {super.key,
      required this.index,
      required this.list,
      required this.likes});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index, likes;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      width: double.infinity,
      child: Card(
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      list![index]['title'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (likes != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    if (likes != 0)
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    if (likes != 0)
                      const SizedBox(
                        width: 5,
                      ),
                    if (likes != 0) Text(likes.toString())
                  ],
                ),
              ),
              if (list![index]['image'].toString().isNotEmpty)
                Hero(
                  tag: list![index]['image'].toString(),
                  child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                            context,
                            '/fullScreen',
                            arguments: {
                              'imageUrl': list![index]['image'].toString()
                            },
                          ),
                      child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(
                                      list![index]['image'].toString()))))),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(list![index]['content']),
              )
            ],
          )),
    );
  }
}
