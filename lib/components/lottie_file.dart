import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieFile extends StatelessWidget {
  LottieFile({super.key, required this.file});
  String file;

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            Lottie.asset('assets/lotties/$file.json', height: 100, width: 100));
  }
}
