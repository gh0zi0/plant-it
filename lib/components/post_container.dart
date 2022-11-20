import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

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
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.list![widget.index]['image'].toString().isEmpty
                            ? const Icon(
                                Icons.person,
                              )
                            : ClipOval(
                                child: SizedBox.fromSize(
                                    size: const Size.fromRadius(15),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.list![widget.index]
                                          ['Uimage'],
                                      progressIndicatorBuilder:
                                          (context, x, url) =>
                                              const Icon(Icons.person),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person),
                                    )),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.list![widget.index]['name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (widget.likes != 0)
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.likes.toString())
                        ],
                      )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (widget.list![widget.index]['image'].toString().isNotEmpty)
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.list![widget.index]['image'].toString(),
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                    top: 10, right: 10, left: 15, bottom: 10),
                child: Text(
                  widget.list![widget.index]['content'],
                ),
              )
            ],
          )),
    );
  }
}
