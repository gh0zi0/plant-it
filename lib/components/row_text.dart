import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RowText extends StatelessWidget {
  RowText(
      {super.key,
      required this.t1,
      required this.t2,
      required this.alignment,
      this.size = 14.0});
  String t1, t2;
  MainAxisAlignment alignment;
  double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          t1,
          style: TextStyle(fontSize: size),
        ).tr(),
        const SizedBox(
          width: 5,
        ),
        Text(
          t2,
          style: TextStyle(fontSize: size),
        ),
      ],
    );
  }
}
