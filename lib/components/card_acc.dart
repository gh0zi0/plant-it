import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class CardAcc extends StatelessWidget {
  CardAcc(
      {super.key, required this.text, required this.icon, required this.color});
  String text;
  IconData icon;
  Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 60,
      child: Card(
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
