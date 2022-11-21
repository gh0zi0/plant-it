import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EButton extends StatelessWidget {
  EButton(
      {super.key,
      required this.title,
      required this.function,
      required this.h,
      required this.w,
      this.tColor = Colors.white,
      this.color = Colors.green});
  String title;
  Function function;
  double h, w;
  Color color, tColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      width: w,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(
                    color: Color(0xFF009345),
                  ),
                ),
              )),
          onPressed: () {
            function();
          },
          child: Text(
            title,
            style: TextStyle(color: tColor, fontSize: 18),
          ).tr()),
    );
  }
}
