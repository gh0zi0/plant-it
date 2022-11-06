import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroContainer extends StatelessWidget {
  IntroContainer(
      {super.key,
      required this.image,
      required this.title,
      required this.content});
  String image, title, content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(children: [
        CachedNetworkImage(imageUrl: image),
        Text(
          title,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text(
          content,
          style: TextStyle(fontSize: 18),
        )
      ]),
    );
  }
}
