import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TButton extends StatelessWidget {
  TButton({super.key, required this.title, required this.function});
  String title;
  Function function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          function();
        },
        child: Text(
          title,
        ));
  }
}
