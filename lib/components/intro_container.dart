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
        Flexible(
          child: Image.asset(
            'assets/images/$image.png',
            // height: 100,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text(
          content,
          style: const TextStyle(fontSize: 18),
        )
      ]),
    );
  }
}
