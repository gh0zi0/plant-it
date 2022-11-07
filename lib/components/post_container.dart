import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/full_screen.dart';

// ignore: must_be_immutable
class PostContainer extends StatefulWidget {
  PostContainer(
      {super.key,
      required this.index,
      required this.list,
      required this.likes});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index, likes;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  var name = '', image = '';
  getUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.list![widget.index]['uid'])
        .get()
        .then((value) {
      setState(() {
        image = value['image'];
        name = value['name'];
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
                    ClipOval(
                      child: SizedBox.fromSize(
                          size: const Size.fromRadius(15),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          )),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (widget.likes != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    if (widget.likes != 0)
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    if (widget.likes != 0)
                      const SizedBox(
                        width: 5,
                      ),
                    if (widget.likes != 0) Text(widget.likes.toString())
                  ],
                ),
              ),
              if (widget.list![widget.index]['image'].toString().isNotEmpty)
                Hero(
                  tag: widget.list![widget.index]['image'].toString(),
                  child: GestureDetector(
                      onTap: () => Get.to(() => FullScreen(
                            imageurl: widget.list![widget.index]['image'],
                          )),
                      child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(widget.list![widget.index]
                                          ['image']
                                      .toString()))))),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(widget.list![widget.index]['content']),
              )
            ],
          )),
    );
  }
}
