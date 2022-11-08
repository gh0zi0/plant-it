import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullScreen extends StatelessWidget {
  FullScreen({super.key, required this.imageurl});
  String imageurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
      ),
      body: Hero(
        tag: imageurl.toString(),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(imageurl))),
          ),
        ),
      ),
    );
  }
}
