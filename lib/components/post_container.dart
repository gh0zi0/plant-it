import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.list![widget.index]['Uimage'].toString().isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xFF009345))),
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        )
                      : ClipOval(
                          child: SizedBox.fromSize(
                              size: const Size.fromRadius(20),
                              child: CachedNetworkImage(
                                imageUrl: widget.list![widget.index]['Uimage'],
                                progressIndicatorBuilder: (context, x, url) =>
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
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
          const SizedBox(
            height: 10,
          ),
          if (widget.list![widget.index]['image'].toString().isNotEmpty)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.list![widget.index]['image'].toString(),
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(top: 10, right: 10, left: 15, bottom: 10),
            child: Text(
              widget.list![widget.index]['content'],
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
