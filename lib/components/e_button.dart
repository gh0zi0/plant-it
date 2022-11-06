import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EButton extends StatelessWidget {
  EButton(
      {super.key,
      required this.title,
      required this.function,
      required this.h,
      required this.w,
      this.color});
  String title;
  Function function;
  double h, w;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      width: w,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            function();
          },
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }
}
