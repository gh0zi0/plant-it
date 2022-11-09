import 'package:easy_localization/easy_localization.dart';
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
    return Column(children: [
      Flexible(
        child: Image.asset(
          'assets/images/$image.png',
        ),
      ),
      Text(
        title,
        style: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
      ).tr(),
      Text(
        content,
        style: const TextStyle(fontSize: 18),
      )
    ]);
  }
}
