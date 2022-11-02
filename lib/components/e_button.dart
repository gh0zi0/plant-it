import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EButton extends StatelessWidget {
  EButton({super.key, required this.title, required this.function});
  String title;
  Function function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
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
